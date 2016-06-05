require 'securerandom'

module Riddlegate
  class AdminApp < Sinatra::Application
    get '/settings' do
      haml :'admin/settings'
    end

    post '/settings' do
      checkboxes = %w{security_enabled}

      params[:settings].each do |k, v|
        if !checkboxes.include?(k)
          update_setting(k, v)
        end
      end

      checkboxes.each do |k|
        update_setting(k, !params[:settings][k].nil?)
      end

      if security_enabled? && get_setting(:hmac_secret, default: "").empty?
        update_setting(:hmac_secret, SecureRandom.hex)
      end

      redirect '/admin/settings'
    end
  end
end
