require './constants'

desc 'download src files'
task :download do
  sh <<-EOS
cat urls.txt | sort | \
parallel --line-buffer -j 2 URL={} ruby dl.rb
  EOS
end

desc 'produce tiles'
task :tiles do
  Dir.glob("#{SRC_DIR}/*.las").sort.each {|path|
    basename = File.basename(path, '.las')
    mbtiles_path = "#{LOT_DIR}/#{basename}.mbtiles"
    if CONTINUE and
      File.exist?(mbtiles_path) and 
      !File.exist?("#{mbtiles_path}-journal")
        print "skip #{mbtiles_path}.\n"
        next
    end
    sh <<-EOS
seq #{MINZOOM} #{MAXZOOM} | 
parallel --jobs=#{JOBS} --line-buffer '\
Z={} BASENAME=#{basename} ruby rs.rb | \
pdal pipeline --stdin | \
Z={} ruby togeojson.rb' | \
tippecanoe --minimum-zoom=#{MINZOOM} \
--maximum-zoom=#{MAXZOOM} --force \
--output=#{mbtiles_path} \
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

