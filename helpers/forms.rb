module Riddlegate
  module Forms
    include Riddlegate::Settings

    def setting_field(key, type = 'text')
      "<input type='#{type}' class='form-control' name='settings[#{key}]' value='#{get_setting(key)}'/>"
    end

    def setting_checkbox(key)
      checked_prop = get_boolean_setting(key) ? ' checked' : ''
      "<input type='checkbox' class='bootstrap-switch' name='settings[#{key}]'#{checked_prop}/>"
    end
  end
end
