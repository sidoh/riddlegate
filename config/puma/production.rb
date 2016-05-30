root = File.expand_path(File.join(__FILE__, '../../..'))

require "#{root}/config/puma/environment"

pidfile "#{root}/tmp/puma.pid"
state_path "#{root}/tmp/puma.state"
bind "unix://#{root}/tmp/puma.sock"

stdout_redirect "#{root}/log/puma.out", "#{root}/log/puma.err", true
threads 4, 8

rackup "#{root}/config.ru"
daemonize true
