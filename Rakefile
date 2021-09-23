require './constants'

desc 'download src files'
task :download do
  sh <<-EOS
parallel --line-buffer -j 2 ruby dl.rb ::: #{SRC_FILES.join(' ')}
  EOS
end

desc 'produce tiles'
task :tiles do
  Dir.glob("#{SRC_DIR}/*.las") {|path|
    basename = File.basename(path, '.las')
    output = "--output=#{LOT_DIR}/#{basename}.mbtiles"
    sh <<-EOS
seq #{MINZOOM} #{MAXZOOM} | 
parallel --jobs=#{JOBS} --line-buffer '\
Z={} BASENAME=#{basename} ruby rs.rb | \
pdal pipeline --stdin | \
Z={} ruby togeojson.rb' | \
tippecanoe --minimum-zoom=#{MINZOOM} \
--maximum-zoom=#{MAXZOOM} --force \
#{output} \
--no-tile-size-limit \
--no-feature-limit \
--projection=EPSG:3857
    EOS
  }
end

desc 'generate style'
task :style do
  sh "ruby style.rb > docs/style.json"
end

desc 'host the site locallly'
task :host do
  sh "budo -d docs"
end

desc 'deploy tiles'
task :deploy do
  files = Dir.glob("#{LOT_DIR}/*.mbtiles").select {|path|
    not File.exists?("#{path}-journal")
  }
  raise "you have no lot files ready." if files.empty?
  sh <<-EOS
tile-join --force --output=#{MBTILES_PATH} \
--no-tile-size-limit \
--minimum-zoom=#{MINZOOM} --maximum-zoom=#{MAXZOOM} \
#{files.join(' ')}; \
tile-join --force --output-to-directory=docs/zxy \
--no-tile-size-limit \
--no-tile-compression \
--minimum-zoom=#{MINZOOM} --maximum-zoom=#{MAXZOOM} \
#{MBTILES_PATH}
  EOS
end

desc 'run vt-optimizer'
task :optimize do
  sh "node ~/vt-optimizer/index.js -m #{MBTILES_PATH}"
end

