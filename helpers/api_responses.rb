module Riddlegate
  module ApiResponses
    include Riddlegate::Settings

    def resolve_template_name(request_params)
      case get_setting(:mode)
      when 'forward'
        'forward'
      when 'unlocked'
        'unlock'
      when 'locked'
        if !request_params[:state] || request_params[:state] == 'index'
          'index'
        elsif request_params[:state] == 'code_entered'
          if request_params[:Digits] == get_setting(:passcode)
            'unlock'
          else
            'forward'
          end
        end
      end
    end
  end
end
