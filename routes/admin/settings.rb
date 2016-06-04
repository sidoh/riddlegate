module Riddlegate
  class AdminApp < Sinatra::Application
    get '/settings' do
      haml :'admin/settings'
    end

    post '/settings' do
      params[:settings].each do |k, v|
        update_setting(k, v)
      end

      redirect '/admin/settings'
    end
  end
end
