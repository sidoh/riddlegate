root = File.expand_path(File.join(__FILE__, '../../..'))

require "#{root}/config/puma/environment"

pidfile "#{root}/tmp/puma.pid"
state_path "#{root}/tmp/puma.state"

# Comment this out and uncomment the following "bind" directive if you prefer
# to listen on a unix socket
bind "tcp://0.0.0.0:8000"

# Uncomment this if you want to listen on a unix socket
# bind "unix://#{root}/tmp/puma.sock"

stdout_redirect "#{root}/log/puma.out", "#{root}/log/puma.err", true
threads 4, 8

rackup "#{root}/config.ru"
daemonize true
