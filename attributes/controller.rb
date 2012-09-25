#
# Author:: Paul MacDougall (<pmacdougall@edmunds.com>)
# Cookbook Name:: appdynamics
# Attributes:: controller
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


# Controller specific attributes
default['appdynamics']['controller']['host'] = nil # this is set at the environment level
default['appdynamics']['controller']['version'] = '3.5.5'
default['appdynamics']['controller']['checksum'] = 'b1e919d108935d06896dafd475bd3686a6d0b3437d2ede380b408fe221c8b31d'
default['appdynamics']['controller']['filerepo_path'] = "/AppDynamics/controller/#{node['appdynamics']['controller']['version']}"

default['appdynamics']['controller']['install_profile'] = '1'  # 1: Demo, 2: Small, 3: Medium, 4: Large (Extra Large not supported at this time)
default['appdynamics']['controller']['install_dir'] = '/home/appdynamics/AppDynamics/Controller'
default['appdynamics']['controller']['appserver_port'] = '8090'
default['appdynamics']['controller']['database_port'] = '3388'
default['appdynamics']['controller']['admin_port'] = '4848'
default['appdynamics']['controller']['jms_port'] = '7676'
default['appdynamics']['controller']['iiop_port'] = '3700'
default['appdynamics']['controller']['ssl_port'] = '8181'
default['appdynamics']['controller']['admin_user'] = 'admin'
default['appdynamics']['controller']['admin_password'] = 'admin321'
default['appdynamics']['controller']['tenancy_mode'] = '1' # 1: Single, 2: Multi
default['appdynamics']['controller']['ha_mode'] = '1' # 1: not enabled, 2: primary, 3: secondary

default['appdynamics']['controller']['ldap_support'] = false
default['appdynamics']['controller']['ldap_url'] = 'ldap://ldap.example.com:389'
default['appdynamics']['controller']['ldap_base'] = 'ou=People,dc=example,dc=com'
