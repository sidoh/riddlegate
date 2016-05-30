class Setting
  include DataMapper::Resource

  property :id, Serial
  property :setting_key, String, required: true, index: true
  property :setting_value, Text
end
