require './constants'
require 'yaml'
require 'json'

pipeline = <<-EOS
pipeline: 
  - "#{SRC_DIR}/*-1.0.las"
  - "#{SRC_DIR}/merged.las"
EOS

print JSON.dump(YAML.load(pipeline)), "\n"

