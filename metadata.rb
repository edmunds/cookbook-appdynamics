name             'appdynamics'
maintainer       'Edmunds.com'
maintainer_email 'pmacdougall@edmunds.com'
license          'Apache 2.0'
description      'Installs/Configures AppDynamics Controller, Java App Agent and Machine Agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

recipe 'appdynamics::agent', 'Installs AppDynamics Java Agent and configures it for local apps'
recipe 'appdynamics::machine_agent', 'Installs AppDynamics Machine Agent'
recipe 'appdynamics::controller', 'Installs and configures AppDynamics Controller'
recipe 'appdynamics::production_controller', "Edmunds' specific Production Controller configuration"
