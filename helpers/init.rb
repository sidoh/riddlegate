require 'helpers/forms'
require 'helpers/settings'
require 'helpers/api_responses'
require 'helpers/logs'

Riddlegate::APPS.each do |c|
  c.helpers Riddlegate::Forms
  c.helpers Riddlegate::Settings
  c.helpers Riddlegate::ApiResponses
  c.helpers Riddlegate::Logs
end
