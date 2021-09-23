require './constants'
require 'yaml'
require 'json'

url = ENV['URL']
fn = File.basename(url.split('/')[-1], '.zip')

zip_path = "#{SRC_DIR}/#{fn}.zip"
las_path = "#{SRC_DIR}/#{fn}.las"
if File.exist?(las_path)
  print "skipping #{zip_path} for #{las_path} is already there.\n"
  exit true
end
print "Downloading #{zip_path}"
system "curl -o #{zip_path} #{url}"
system "unzip -d #{SRC_DIR} #{zip_path}"
system "rm #{zip_path}"

