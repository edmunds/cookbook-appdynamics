#
# Author:: Paul MacDougall (<pmacdougall@edmunds.com>)
# Cookbook Name:: appdynamics
# Attributes:: machine_agent
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


# Machine Agent specific attributes
# note that the machine_agent recipe also makes use of:
# ['appdynamics']['agent']['user']
# ['appdynamics']['agent']['group']
# which are defined in attributes/agent.rb

default['appdynamics']['machine_agent']['version'] = '3.5.5'
default['appdynamics']['machine_agent']['checksum'] = 'af56c86105ec8244bc2f3abe2f13205135cc49d7299d378db7e483d5b99e5c91'
default['appdynamics']['machine_agent']['install_dir'] = "/usr/local/appdynamics-machine-agent-#{node['appdynamics']['machine_agent']['version']}"
default['appdynamics']['machine_agent']['logdir'] = "/logs/appdynamics/machine_agent/#{node['fqdn']}"
default['appdynamics']['machine_agent']['filerepo_path'] = "/AppDynamics/machine_agent/#{node['appdynamics']['machine_agent']['version']}"
