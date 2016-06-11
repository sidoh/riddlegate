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

require 'twilio-ruby'

module Riddlegate
  class TwilioApp < Sinatra::Application
    before do
      auth_token = get_setting(:twilio_auth_token, default: "")

      if !auth_token.empty?
        validator = Twilio::Util::RequestValidator.new(auth_token)
        signed_params = request.post? ? request.POST : {}

        if !validator.validate(request.url, signed_params, request.env['HTTP_X_TWILIO_SIGNATURE'] || "")
          halt 401, "Not authorized\n"
        end
      end
    end
  end

  class AdminApp < Sinatra::Application
    before do
      if !authorized?(request)
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized\n"
      end
    end
  end

  class RootApp < Sinatra::Application
  end

  class ApiApp < Sinatra::Application
    before do
      if get_setting(:api_security_mode) == 'hmac_signature'
        timestamp = request.env['HTTP_X_SIGNATURE_TIMESTAMP']
        params    = request.post? ? request.POST : {}
        payload   = request.url + params.sort.join
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
      elsif !authorized?(request)
        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized\n"
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
