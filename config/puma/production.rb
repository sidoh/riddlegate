root = File.expand_path(File.join(__FILE__, '../../..'))

require "#{root}/config/puma/environment"

pidfile "#{root}/tmp/puma.pid"
state_path "#{root}/tmp/puma.state"

stdout_redirect "#{root}/log/puma.out", "#{root}/log/puma.err", true
threads 4, 8

bind "unix://#{root}/tmp/puma/socket"
rackup "#{root}/config.ru"
