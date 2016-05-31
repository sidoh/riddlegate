module Riddlegate
  class App < Sinatra::Application
    get '/settings' do
      haml :settings
    end

    post '/settings' do
      params[:settings].each do |k, v|
        update_setting(k, v)
      end

      redirect '/settings'
    end
  end
end
