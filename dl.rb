require './constants'
require 'yaml'
require 'json'

fn = ARGV[0]

zip_path = "#{SRC_DIR}/#{fn}.zip"
las_path = "#{SRC_DIR}/#{fn}.las"
exit true if File.exist?(las_path)
print "Downloading #{zip_path}"
system "curl -o #{zip_path} #{SRC_BASE_URL}/#{fn}.zip"
system "unzip -d #{SRC_DIR} #{zip_path}"
system "rm #{zip_path}"

