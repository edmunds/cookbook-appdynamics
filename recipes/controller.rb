#
# Author:: Paul MacDougall (<pmacdougall@edmunds.com>)
# Cookbook Name:: appdynamics
# Recipe:: controller
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

# ulimit settings as recommended by AppDymamics
cookbook_file '/etc/security/limits.d/appdynamics.conf' do
  source 'etc/security/limits.d/appdynamics.conf'
  mode '0755'
end

# libaio is required by AppDynamics (usually installed by default, but just being safe)
package 'libaio'
# need to use expect for the shell installer
package 'expect'

[ '/home/appdynamics/bin', 
  node['appdynamics']['controller']['install_dir']
].each do |dir|
  directory dir do
    owner 'appdynamics'
    group 'appdynamics'
    recursive true
  end
end

[ 'install_upgrade.exp' ].each do |script|
  template "/home/appdynamics/bin/#{script}" do
    source "#{script}.erb"
    owner 'appdynamics'
    group 'appdynamics'
    mode '0500'
  end
end

cookbook_file "#{node['appdynamics']['controller']['install_dir']}/license.lic" do
  source 'license.lic'
  mode '0444'
  owner 'appdynamics'
  group 'appdynamics'
end

remote_file "/home/appdynamics/controller_64bit_linux_#{node['appdynamics']['controller']['version']}.sh" do
  source "http://#{node['filerepo_host']}#{node['appdynamics']['controller']['filerepo_path']}/controller_64bit_linux.sh"
  checksum node['appdynamics']['controller']['checksum']
  mode '0544'
  owner 'appdynamics'
  group 'appdynamics'
  notifies :run, 'execute[controller_install_upgrade]', :immediately  #need to be immediately for initial install so the ldap template has a place to go
end

execute 'controller_install_upgrade' do
  user 'appdynamics'
  group 'appdynamics'
  cwd '/home/appdynamics'
  command './bin/install_upgrade.exp 2>&1 | tee expect_install_upgrade_$(date +%Y-%m-%d).log'

  action :nothing
  notifies :run, 'execute[previous_installer_cleanup]'
end

execute 'previous_installer_cleanup' do
  user 'appdynamics'
  group 'appdynamics'
  cwd '/home/appdynamics'
  command "find . -type f \\( -name 'controller*sh' \! -name 'controller_64bit_linux_#{node['appdynamics']['controller']['version']}.sh' \\) -delete"
  action :nothing
end

template "#{node['appdynamics']['controller']['install_dir']}/appserver/domains/domain1/config/ldap-config.xml" do
  source 'ldap-config.xml.erb'
  owner 'appdynamics'
  group 'appdynamics'
  mode '0444'
  only_if{ node['appdynamics']['controller']['ldap_support'] }
end

template "#{node['appdynamics']['controller']['install_dir']}/appserver/domains/domain1/config/ldap-mapping.xml" do
  source 'ldap-mapping.xml.erb'
  owner 'appdynamics'
  group 'appdynamics'
  mode '0444'
  variables( 
      :usernames => data_bag_item('appdynamics', 'users')['ldap_usernames'].uniq,
      :ldap_base => node['appdynamics']['controller']['ldap_base']
  )
  only_if{ node['appdynamics']['controller']['ldap_support'] }
end
