require './constants'

desc 'download src files'
task :download do
  sh <<-EOS
parallel --line-buffer -j 2 ruby dl.rb ::: #{SRC_FILES.join(' ')}
  EOS
end

desc 'produce tiles'
task :produce do
  output = "--output-to-directory=docs/zxy"
  #output = "--output=#{MBTILES_PATH}"
  sh <<-EOS
seq #{MINZOOM} #{MAXZOOM} | 
parallel --jobs=#{JOBS} --line-buffer '\
Z={} ruby rs.rb | pdal pipeline --stdin | \
Z={} ruby togeojson.rb' | \
tippecanoe --minimum-zoom=#{MINZOOM} \
--maximum-zoom=#{MAXZOOM} --force \
#{output} \
--no-tile-size-limit \
--no-feature-limit \
--no-tile-compression \
--projection=EPSG:3857
  EOS
end

desc 'generate style'
task :style do
  sh "ruby style.rb > docs/style.json"
end

desc 'host the site locallly'
task :host do
  sh "budo -d docs"
end

