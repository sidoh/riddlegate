require 'data_mapper'
require 'dm-timestamps'

root = File.expand_path(File.join(__FILE__, '../..'))

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite://#{root}/db/sqlite3.db")

require 'db/schema'

DataMapper.finalize
DataMapper.auto_upgrade!
