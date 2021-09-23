require './constants'
require 'yaml'
require 'json'

print JSON.dump(YAML.load(
<<EOS
version: 8
center:
  - 138.938
  - 34.791
zoom: 17
layers:
  -
    id: sky
    type: sky
    paint:
      sky-type: atmosphere
  -
    id: background
    type: background
    paint:
      background-color: rgb(20, 20, 20)
  -
    id: voxel
    type: fill-extrusion
    source: voxel
    source-layer: voxel
    paint: 
      fill-extrusion-base: 
        - get
        - h
      fill-extrusion-color: "#ccc"
#      fill-extrusion-color:
#        - get
#        - color
      fill-extrusion-height: 
        - '+'
        -
          - get
          - h
        - 
          - get
          - spacing
sources:
  voxel:
    type: vector
    attribution: "出典:静岡県ポイントクラウドデータベース"
    minzoom: #{MINZOOM}
    maxzoom: #{MAXZOOM}
    tiles:
      - #{BASE_URL}/{z}/{x}/{y}.pbf
EOS
))