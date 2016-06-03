require 'helpers/forms'
require 'helpers/settings'
require 'helpers/api_responses'

[Riddlegate::App, Riddlegate::AdminApp].each do |c|
  c.helpers Riddlegate::Forms
  c.helpers Riddlegate::Settings
  c.helpers Riddlegate::ApiResponses
end
