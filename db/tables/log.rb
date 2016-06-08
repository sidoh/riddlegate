class Log
  include DataMapper::Resource

  property :id, Serial
  property :message, Text
  property :metadata, Text

  timestamps :created_at
end
