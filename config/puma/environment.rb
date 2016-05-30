root = File.expand_path(File.join(__FILE__, '../../..'))

%w{
  tmp/puma
  log
}.each do |d|
  FileUtils.mkdir_p(d)
end
