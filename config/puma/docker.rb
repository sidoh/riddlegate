root = File.expand_path(File.join(__FILE__, '../../..'))

require "#{root}/config/puma/environment"

bind "tcp://0.0.0.0:8000"
stdout_redirect "#{root}/log/puma.out", "#{root}/log/puma.err", true
threads 4, 8

rackup "#{root}/config.ru"
daemonize false
