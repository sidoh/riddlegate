module Riddlegate
  module HttpAuth
    include Riddlegate::Settings
    
    def authorized?(request)
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials &&
        @auth.credentials == [
          get_setting(:admin_username),
          get_setting(:admin_password)
        ]
    end
  end
end
