module Riddlegate
  class ApiApp
    BLACKLIST_SETTINGS = %w{
      admin_username
      admin_password
      hmac_secret
      security_enabled
      twilio_auth_token
    }

    put '/settings' do
      (params || {})
        .reject { |k, _| BLACKLIST_SETTINGS.include?(k) }
        .each do |k, v|
          update_setting(k, v)
        end

      halt 200
    end

    get '/settings' do
    end
  end
end
