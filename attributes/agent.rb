#
# Author:: Paul MacDougall (<pmacdougall@edmunds.com>)
# Cookbook Name:: appdynamics
# Attributes:: agent
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


# Java Agent specific attributs

default['filerepo_host'] = 'filerepo.example.com'

default['appdynamics']['agent']['version']       = '3.5.5'
default['appdynamics']['agent']['checksum']      = 'ad7a66ae43669ff442da285a0baa5998f9043350a9d944ca7cf1cb28661c59cc'
default['appdynamics']['agent']['install_dir']   = "/usr/local/appdynamics-agent-#{node['appdynamics']['agent']['version']}"
default['appdynamics']['agent']['logdir']        = "/logs/appdynamics/#{node['fqdn']}"
default['appdynamics']['agent']['filerepo_path'] = "/AppDynamics/agent/#{node['appdynamics']['agent']['version']}"

default['appdynamics']['agent']['application'] = 'Unknown  Application'
default['appdynamics']['agent']['tier']        = 'unknown'


default['appdynamics']['agent']['user']  = 'webapps' # also used by machine agent
default['appdynamics']['agent']['group'] = 'webapps' # also used by machine agent

