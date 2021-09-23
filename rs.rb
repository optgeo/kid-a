require './constants'
require 'yaml'
require 'json'

spacing = (2 ** (Z_ONE_METER - ENV['Z'].to_i)).to_f
basename = ENV['BASENAME']

pipeline = <<-EOS
pipeline: 
  - 
    filename: #{SRC_DIR}/#{basename}.las
    type: readers.las
    spatialreference: "EPSG:6676"
  -
    type: filters.reprojection
    out_srs: "EPSG:3857"
  -
    type: filters.voxelcenternearestneighbor
    cell: #{spacing}
  -
    type: writers.text
    format: csv
    filename: STDOUT
EOS

print JSON.dump(YAML.load(pipeline))
