module Riddlegate
  class AdminApp < Sinatra::Application
    get '/logs' do
      haml :'admin/logs'
    end
  end
end
