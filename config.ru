root = ::File.dirname(__FILE__)
require ::File.join( root, 'riddlegate' )
require 'sinatra'

configure do
  set :server, :puma
end

run Riddlegate::App.new
