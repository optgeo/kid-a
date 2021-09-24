require './constants'
require 'yaml'
require 'json'
Z = ENV['Z'].to_i
spacing = (2 ** (Z_ONE_METER - Z)).to_f
#$stderr.print "Creating GeoJSONSeq for z=#{Z}.\n"
start_time = Time.now
n = 0

first = true
while gets
  if first
    first = false
    next
  else
    n += 1
  end
  r = $_.strip.split(',')
  x = r[0].to_f - r[0].to_f % spacing
  y = r[1].to_f - r[1].to_f % spacing
  h = r[2].to_f - r[2].to_f % spacing
  h = h.to_i
#  color = '#' + r[13..15].map{|v| sprintf('%02x', v.to_f / 256)}.join
  color = '#' + r[13..15].map{|v| sprintf('%01x', (v.to_f / 4096).round)}.join
  g = <<-EOS
type: Polygon
coordinates: 
  -
    -
      - #{x}
      - #{y}
    -
      - #{x + spacing}
      - #{y}
    -
      - #{x + spacing}
      - #{y + spacing}
    -
      - #{x}
      - #{y + spacing}
    -
      - #{x}
      - #{y}
  EOS
  g = YAML.load(g)
  f = <<-EOS
type: Feature
properties: 
  color: '#{color}'
  classification: #{r[8].to_i}
#  height: #{r[2].to_f}
  h: #{h}
  spacing: #{spacing}
tippecanoe:
  minzoom: #{Z}
  maxzoom: #{Z}
  layer: #{LAYER_NAME}
  EOS
  f = YAML.load(f)
  f[:geometry] = g
  print JSON.dump(f), "\n"
end

$stderr.print "z=#{Z}: #{n} voxels, #{(Time.now - start_time).round}s.\n"
