Description
===========
For the installation of AppDynamics Controller, Application Agent and Machine Agent.


See __Usage__ for more information

Requirements
============

Platforms
---------
* RHEL 5
* RHEL 6


Attributes
==========
General
-------
* `node['filerepo_host']` - the www server host that serves the install files

Controller
----------
* `node['appdynamics']['controller']['filerepo_path']` - path to the controller installer file in the file repository
* `node['appdynamics']['controller']['host']`          - the controller the agent should connect to
* `node['appdynamics']['controller']['version']`       - controller version to install
* `node['appdynamics']['controller']['checksum']`      - sha256sum value of the controller installer file

* `node['appdynamics']['controller']['install_profile']` - which profile to choose when installing the controller
* `node['appdynamics']['controller']['install_dir']`     - where to install the controller
* `node['appdynamics']['controller']['appserver_port']`  - Application Server Port
* `node['appdynamics']['controller']['database_port']`   - Database Server Port
* `node['appdynamics']['controller']['admin_port']`      - Application Server Admin Port
* `node['appdynamics']['controller']['jms_port']`        - Application Server JMS Port
* `node['appdynamics']['controller']['iiop_port']`       - Application Server IIOP Port
* `node['appdynamics']['controller']['ssl_port']`        - Application Server SSL Port
* `node['appdynamics']['controller']['admin_user']`      - username for admin user when installing the controller
* `node['appdynamics']['controller']['admin_password']`  - password for admin user when installing the controller
* `node['appdynamics']['controller']['tenancy_mode']`    - Controller's Tenancy Mode
* `node['appdynamics']['controller']['ha_mode']`         - Conroller's HA Configuration

* `node['appdynamics']['controller']['ldap_support']` - true if using LDAP authentication, else false
* `node['appdynamics']['controller']['ldap_url']`     - LDAP url if using LDAP authentication
* `node['appdynamics']['controller']['ldap_base']`    - the ldap search base for users

Agent
-----
* `node['appdynamics']['agent']['filerepo_path']` - path to the Java Agent zip file in the file repository
* `node['appdynamics']['agent']['version']`       - Java Agent version to install
* `node['appdynamics']['agent']['checksum']`      - sha256sum value of the Java Agent zip file
* `node['appdynamics']['agent']['install_dir']`   - where to install the Java Agent
* `node['appdynamics']['agent']['logdir']`        - where the Java Agent should write its logs

* `node['appdynamics']['agent']['application']` - the AppDynamics application this Java Agent should use
* `node['appdynamics']['agent']['tier']`        - the AppDynamics Tier this Java Agent belongs to

* `node['appdynamics']['agent']['user']`  - the user that should own the Java and Machine Agent files and directories and who should run the Machine Agent
* `node['appdynamics']['agent']['group']` - the group that should own the Java and Machine Agent files and directories

* `node['appdynamics']['machine_agent']['filerepo_path']` - path to the Machine Agent zip file in the file repository
* `node['appdynamics']['machine_agent']['versionn']`       - Machine Agent version to install
* `node['appdynamics']['machine_agent']['checksum']`      - sha256sum value of the Machine Agent zip file
* `node['appdynamics']['machine_agent']['install_dir']`   - where to install the Machine Agent
* `node['appdynamics']['machine_agent']['logdir']`        - where the Machine Agent should write its logs


Usage
=====
Prerequisites/Assumptions
-------------------------
* user appdynamics is created prior to running any of these recipes and the user's home is /home/appdynamics
* Java is installed prior to running the agent or machine_agent recipes
* a www server to host the AppDynamics controller install file and agent tar balls
  * We use a simple http server for hosting files such as the controller installer and agent zip files.  
    This helps keep the cookbook a reasonable size as opposed to using cookbook files.
  * The files are not renamed or modified from what is downloaded from download.appdynamics.com
* we assume your controller server meets requirements for the profile you are installing

Notes
-----
* tested with Chef 10.12.0
* Controller HA Mode untested
* Controller Multitenancy Mode untested

* The Java Agent will need the `node['controller']['host']` attribute defined, else the recipe is a no-op.  This allows us to use the same roles in different environments, where some have an AppDynamics controller and some do not.

* We use commandline parameters to control the Java Agent's log dir and node name.  These are set as part of our Tomcat cookbook.

* Host specific AppDynamics Licence file can be added to the cookbook using the host specific cookbook_file feature of Chef.  e.g. if you have a controller running on controller.example.com then add the license file to your local cookbook at `files/host-controller.example.com/license.lic`

* The controller installer file will stay in the appdynamics user's home directory.  This is used to determine if the installer version referenced by the cookbook needs to be run to install or upgrade.  Previous versions of the installer will be removed after upgrading.

* Could not get LDAPS to work for the LDAP configuration.  YYMV.
* The LDAP templates work off of a data bag called "appdynamics" with an array named "users" that is a list of LDAP usernames.  e.g.:

    {
        "id": "users",
        "ldap_usernames": [
            "user1",
            "user2"
        ]
    }



License and Author
==================

Author:: Paul MacDougall (<pmacdougall@edmunds.com>)

Copyright 2012, Edmunds, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

