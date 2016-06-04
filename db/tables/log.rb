class Log
  include DataMapper::Resource

  property :id, Serial
  property :message, Text
  property :metadata, Text

  property :created_at, DateTime
end
