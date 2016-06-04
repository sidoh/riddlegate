root = ::File.dirname(__FILE__)
require ::File.join( root, 'riddlegate' )

require 'sinatra'

configure do
  set :server, :puma
end

map '/twilio' do
  run Riddlegate::TwilioApp.new
end

map '/admin' do
  run Riddlegate::AdminApp.new
end
