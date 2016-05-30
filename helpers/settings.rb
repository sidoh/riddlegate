module Riddlegate
  module Settings
    KEYS = [

    ]

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
  end
end
