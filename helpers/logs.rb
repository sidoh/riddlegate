module Riddlegate
  module Logs
    def create_log(msg, metadata = {})
      Log.create!(message: msg, metadata: metadata.to_json)
    end
  end
end
