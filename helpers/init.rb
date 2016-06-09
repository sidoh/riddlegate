require 'helpers/settings'
require 'helpers/forms'
require 'helpers/api_responses'
require 'helpers/logs'
require 'helpers/http_auth'

Riddlegate::APPS.each do |c|
  c.helpers Riddlegate::Forms
  c.helpers Riddlegate::Settings
  c.helpers Riddlegate::ApiResponses
  c.helpers Riddlegate::Logs
  c.helpers Riddlegate::HttpAuth
end
