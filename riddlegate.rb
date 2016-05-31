$LOAD_PATH << ::File.expand_path(::File.join(__FILE__, '..'))
$LOAD_PATH << ::File.expand_path(::File.join(__FILE__, '../..'))

require 'sinatra'
require 'sinatra/json'
require 'sinatra/param'
require 'sprockets'

require 'haml'
require 'tilt/haml'

module Riddlegate
  class App < Sinatra::Application
    set :environment, Sprockets::Environment.new
    environment.append_path "assets/stylesheets"
    environment.append_path "assets/javascripts"
    environment.js_compressor  = :uglify
    environment.css_compressor = :sass

    get "/assets/*" do
      env["PATH_INFO"].sub!("/assets", "")
      settings.environment.call(env)
    end

    get '/' do
      haml :index
    end
  end
end

require 'routes/init'
require 'helpers/init'
