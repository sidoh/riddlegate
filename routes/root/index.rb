module Riddlegate
  class RootApp
    get '/' do
      haml :index
    end
  end
end
