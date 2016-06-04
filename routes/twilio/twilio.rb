module Riddlegate
  class TwilioApp < Sinatra::Application
    get '/' do
      template = resolve_template_name(params)
      create_log "Call received. Serving template: #{template}", params

      erb "twilio/#{template}.xml".to_sym
    end
  end
end
