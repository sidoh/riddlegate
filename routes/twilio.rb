module Riddlegate
  class App < Sinatra::Application
    get '/api/twilio' do
      template = resolve_template_name(params)
      erb "twilio/#{template}.xml".to_sym
    end
  end
end
