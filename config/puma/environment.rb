require 'fileutils'

root = File.expand_path(File.join(__FILE__, '../../..'))
$LOAD_PATH << root

%w{
  tmp/puma
  log
}.each do |d|
  FileUtils.mkdir_p(d)
end

require "db/db"
