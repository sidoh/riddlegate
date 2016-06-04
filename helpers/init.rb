require 'helpers/forms'
require 'helpers/settings'
require 'helpers/api_responses'
require 'helpers/logs'

[Riddlegate::TwilioApp, Riddlegate::AdminApp].each do |c|
  c.helpers Riddlegate::Forms
  c.helpers Riddlegate::Settings
  c.helpers Riddlegate::ApiResponses
  c.helpers Riddlegate::Logs
end
