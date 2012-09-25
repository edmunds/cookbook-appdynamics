#
# Author:: Paul MacDougall (<pmacdougall@edmunds.com>)
# Cookbook Name:: appdynamics
# Recipe:: machine_agent
#
# Copyright 2012, Edmunds, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# only run this if there is an AppDynamics controller set for the environment
if ! node['appdynamics']['controller']['host'].nil? then

  directory node['appdynamics']['machine_agent']['logdir'] do
    recursive true
    owner node['appdynamics']['agent']['user']
    group node['appdynamics']['agent']['group']
    mode "0775"
  end

  install_dir = node['appdynamics']['machine_agent']['install_dir']
  local_zip_file = "MachineAgent_#{node['appdynamics']['machine_agent']['version']}.zip"

  remote_file "#{Chef::Config[:file_cache_path]}/#{local_zip_file}" do
    source "http://#{node['filerepo_host']}#{node['appdynamics']['machine_agent']['filerepo_path']}/MachineAgent.zip"
    checksum node['appdynamics']['machine_agent']['checksum']
    mode "0444"
    owner node['appdynamics']['agent']['user']
    group node['appdynamics']['agent']['group']

    only_if{ Dir["#{install_dir}/*"].empty? }
  end

  directory install_dir do
    owner node['appdynamics']['agent']['user']
    group node['appdynamics']['agent']['group']
    mode "0775"
  end

  execute "unzip-machine-agent-file" do
    command "unzip -qq #{Chef::Config[:file_cache_path]}/#{local_zip_file} -d #{install_dir}"
    user node['appdynamics']['agent']['user']
    group node['appdynamics']['agent']['group']

    notifies :run, "execute[restart-machine-agent]"
    only_if{ Dir["#{install_dir}/*"].empty? }
  end

  ['machine-agent-start.sh', 'machine-agent-stop.sh']. each do |t|
    template "#{install_dir}/#{t}" do
      source "#{t}.erb"
      owner node['appdynamics']['agent']['user']
      group node['appdynamics']['agent']['group']
      mode "0500"
      variables(
          :install_dir => install_dir
      )
    end
  end

  template "#{install_dir}/conf/controller-info.xml" do
    source "controller-info.xml.erb"
    owner node['appdynamics']['agent']['user']
    group node['appdynamics']['agent']['group']
    mode 0644
    variables(
        :node_name => node[:fqdn]
    )
    notifies :run, "execute[restart-machine-agent]"
  end

  # until the bug is fixed to set -Dappdynamics.agent.logging.dir in the start script, we will symlink.
  # A support ticket has been filed with AppDynamics.
  directory "#{install_dir}/logs" do
    action :delete
    only_if{ ! File.symlink?("#{install_dir}/logs") }
  end

  link "#{install_dir}/logs" do
    to node['appdynamics']['machine_agent']['logdir']
    owner node['appdynamics']['agent']['user']
    group node['appdynamics']['agent']['group']
  end
  
  execute "restart-machine-agent" do
    user node['appdynamics']['agent']['user']
    cwd install_dir
    command "./machine-agent-stop.sh && ./machine-agent-start.sh"
    notifies :run, "execute[previous-install-cleanup]"
    action :nothing
  end

  execute "previous-install-cleanup" do
    cwd "#{install_dir}/.."
    command "find . -type d -user #{node['appdynamics']['agent']['user']} \\( -name 'appdynamics-machine-agent*' \! -name 'appdynamics-machine-agent-#{node['appdynamics']['machine_agent']['version']}' \\) -print0 | xargs -0 rm -rf"
    action :nothing
  end

  execute "start-machine-agent" do
    user node['appdynamics']['agent']['user']
    cwd install_dir
    command "./machine-agent-start.sh"
    action :run
    only_if "test -z \"$(ps -C java -u #{node['appdynamics']['agent']['user']} -f | grep machineagent.jar | grep -v grep)\""
  end

end
