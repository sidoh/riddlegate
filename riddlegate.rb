$LOAD_PATH << ::File.expand_path(::File.join(__FILE__, '..'))
$LOAD_PATH << ::File.expand_path(::File.join(__FILE__, '../..'))

require 'sinatra'
require 'sinatra/json'
require 'sinatra/param'
require 'sinatra/bootstrap'
require 'sprockets'

require 'haml'
require 'tilt/haml'

module Riddlegate
  class TwilioApp < Sinatra::Application
  end

  class AdminApp < Sinatra::Application
  end

  class RootApp < Sinatra::Application
  end
end

# Make assets available for all apps
[Riddlegate::RootApp, Riddlegate::TwilioApp, Riddlegate::AdminApp].each do |c|
  c.class_exec do
    register Sinatra::Bootstrap::Assets

    set :environment, Sprockets::Environment.new
    environment.append_path "assets/stylesheets"
    environment.append_path "assets/javascripts"
    environment.js_compressor  = :uglify
    environment.css_compressor = :sass

    get "/assets/*" do
      env["PATH_INFO"].sub!("/assets", "")
      settings.environment.call(env)
    end
  end
end

require 'routes/init'
require 'helpers/init'
