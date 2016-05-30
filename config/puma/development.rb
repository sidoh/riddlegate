root = File.expand_path(File.join(__FILE__, '../../..'))

require "#{root}/config/puma/environment.rb"

bind "tcp://0.0.0.0:8000"
rackup "#{root}/config.ru"
activate_control_app 'tcp://0.0.0.0:8001', { no_token: true }
