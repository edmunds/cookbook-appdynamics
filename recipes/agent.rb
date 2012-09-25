#
# Author:: Paul MacDougall (<pmacdougall@edmunds.com>)
# Cookbook Name:: appdynamics
# Recipe:: agent
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


# only run this if there is an AppDynamics Controller set (typically in the Environment)
if ! node['appdynamics']['controller']['host'].nil? then

  directory node['appdynamics']['agent']['logdir'] do
    recursive true
    owner node['appdynamics']['agent']['user']
    group node['appdynamics']['agent']['group']
    mode '0775'
  end

  #TODO find a nicer way to be more generic if any version of tomcat is installed...but eventually it will only be tomcat
  has_tomcat = false
  possible_tomcat_recipes = ['tomcat', 'tomcat::default', 'tomcat::tomcat6', 'tomcat::tomcat7']
  if (node['recipes'] & possible_tomcat_recipes).length > 0 then
    has_tomcat = true
    service 'tomcat' do
      action :nothing
    end
  end

  install_dir = node['appdynamics']['agent']['install_dir']
  local_zip_file = "AppServerAgent_#{node['appdynamics']['agent']['version']}.zip"
  remote_file "#{Chef::Config[:file_cache_path]}/#{local_zip_file}" do
    source "http://#{node['filerepo_host']}#{node['appdynamics']['agent']['filerepo_path']}/AppServerAgent.zip"
    checksum node['appdynamics']['agent']['checksum']
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

  execute "unzip-agent-file" do
    command "unzip -qq #{Chef::Config[:file_cache_path]}/#{local_zip_file} -d #{install_dir}"
    user node['appdynamics']['agent']['user']
    group node['appdynamics']['agent']['group']

    if has_tomcat then
      notifies :restart, "service[tomcat]"
    end
    only_if{ Dir["#{install_dir}/*"].empty? }
  end

  template "#{install_dir}/conf/controller-info.xml" do
    source "controller-info.xml.erb"
    owner node['appdynamics']['agent']['user']
    group node['appdynamics']['agent']['group']
    mode 0644

    if has_tomcat then
      notifies :restart, "service[tomcat]"
    end
  end
end
