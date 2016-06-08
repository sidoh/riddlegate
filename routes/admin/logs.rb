module Riddlegate
  class AdminApp < Sinatra::Application
    get '/logs' do
      @logs = Log.all(:order => :created_at.desc)
      haml :'admin/logs'
    end
  end
end
