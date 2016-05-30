$LOAD_PATH << ::File.expand_path(::File.join(__FILE__, '..'))
$LOAD_PATH << ::File.expand_path(::File.join(__FILE__, '../..'))

require 'sinatra'
require 'sinatra/json'
require 'sinatra/param'

module Riddlegate
  class App < Sinatra::Application
  end
end

require 'routes/init'
require 'helpers/init'
