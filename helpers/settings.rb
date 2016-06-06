module Riddlegate
  module Settings
    KEYS = [

    ]

    def initialize_setting(key, value)
      v = get_setting(key)
      if !v || v.empty?
        update_setting(key, value)
      end
    end

    def security_enabled?
      to_bool(get_setting(:security_enabled))
    end

    def update_setting(key, value)
      v = Setting.first_or_create(setting_key: key)
      v.setting_value = value
      v.save!
    end

    def get_setting(key, default: nil)
      v = Setting.first(setting_key: key)
      v &&= v.setting_value
      v || default
    end

    def get_boolean_setting(key, default: false)
      to_bool(get_setting(key, default: default))
    end

    def to_bool(v)
      return true   if v == true   || v =~ (/(true|t|yes|y|1)$/i)
      return false  if v == false  || v.blank? || v =~ (/(false|f|no|n|0)$/i)
      raise ArgumentError.new("invalid value for Boolean: \"#{v}\"")
    end
  end
end
