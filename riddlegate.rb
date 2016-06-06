$LOAD_PATH << ::File.expand_path(::File.join(__FILE__, '..'))
$LOAD_PATH << ::File.expand_path(::File.join(__FILE__, '../..'))

require 'sinatra'
require 'sinatra/json'
require 'sinatra/param'
require 'sinatra/bootstrap'
require 'sinatra/multi_route'
require 'sprockets'
require 'openssl'

require 'haml'
require 'tilt/haml'
require 'tilt/erb'

module Riddlegate
  class TwilioApp < Sinatra::Application
  end

  class AdminApp < Sinatra::Application
    helpers do
      def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials &&
          @auth.credentials == [
            get_setting(:admin_username, default: 'admin'),
            get_setting(:admin_password, default: 'hunter2')
          ]
      end
    end

    before do
      if !authorized?
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized\n"
      end
    end
  end

  class RootApp < Sinatra::Application
  end

  class ApiApp < Sinatra::Application
    before do
      if security_enabled?
        timestamp = request.env['HTTP_X_SIGNATURE_TIMESTAMP']
        payload   = request.env['HTTP_X_SIGNATURE_PAYLOAD']
        signature = request.env['HTTP_X_SIGNATURE']

        if [payload, timestamp, signature].any?(&:nil?)
          logger.info "Access denied: incomplete signature params."
          logger.info "timestamp = #{timestamp}, payload = #{payload}, signature = #{signature}"
          halt 403
        end

        digest = OpenSSL::Digest.new('sha1')
        data = (payload + timestamp)
        hmac = OpenSSL::HMAC.hexdigest(digest, get_setting(:hmac_secret), data)

        if hmac != signature
          logger.info "Access denied: incorrect signature. Computed = '#{hmac}', provided = '#{signature}'"
          halt 403
        end

        if ((Time.now.to_i - 20) > timestamp.to_i)
          logger.info "Invalid parameter. Timestamp expired: #{timestamp}"
          halt 412
        end
      end
    end
  end
end

Riddlegate::APPS = [
  Riddlegate::RootApp,
  Riddlegate::TwilioApp,
  Riddlegate::AdminApp,
  Riddlegate::ApiApp
]

# Make assets available for all apps
Riddlegate::APPS.each do |c|
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
