require './constants'
require 'yaml'
require 'json'

url = ENV['URL']
fn = File.basename(url.split('/')[-1], '.zip')

zip_path = "#{SRC_DIR}/#{fn}.zip"
las_path = "#{SRC_DIR}/#{fn}.las"
mbtiles_path = "#{LOT_DIR}/#{fn}.mbtiles"

[mbtiles_path, las_path, zip_path].each {|path|
  if File.exist?(path)
    print "skipping #{zip_path} because #{path} is already there.\n"
    exit true
  end
}
print "Downloading #{zip_path}"
system "curl -o #{zip_path} #{url}"
system "unzip -d #{SRC_DIR} #{zip_path}"
system "rm #{zip_path}"

