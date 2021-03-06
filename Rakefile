require './constants'
require 'digest/md5'
require 'slack-notifier' if SLACK

if SLACK
  $notifier = Slack::Notifier.new WEBHOOK_URL
end

desc 'install required ruby libraries'
task :install do
  sh "sudo gem install slack-notifier"
end

desc 'download maplibre-gl files'
task :maplibre do
  %w{
https://unpkg.com/maplibre-gl@1.15.2/dist/maplibre-gl.css
https://unpkg.com/maplibre-gl@1.15.2/dist/maplibre-gl.js
https://unpkg.com/maplibre-gl@1.15.2/dist/maplibre-gl.js.map
  }.each {|url|
    sh <<-EOS
curl -o docs/#{url.split('/')[-1]} #{url}
    EOS
  }
end

desc 'download src files'
task :download do
  sh <<-EOS
cat #{URLS_PATH} | sort | \
parallel --line-buffer -j #{DOWNLOAD_JOBS} URL={} ruby dl.rb
  EOS
end

desc 'produce tiles'
task :tiles do
  $notifier.ping "#{pomocode} 🐧 started." if SLACK
  Dir.glob("#{SRC_DIR}/*.las").sort.each {|path|
    basename = File.basename(path, '.las')
    next unless FILTERS[hostname].match basename
    mbtiles_path = "#{LOT_DIR}/#{basename}.mbtiles"
    if CONTINUE and
      File.exist?(mbtiles_path) and 
      !File.exist?("#{mbtiles_path}-journal")
        print "skip #{mbtiles_path}.\n"
        next
    end
    sh <<-EOS
seq #{MINZOOM} #{MAXZOOM} | \
parallel --jobs=#{JOBS} --line-buffer --delay=#{DELAY} '\
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
    $notifier.ping "#{pomocode} #{basename} 👍" if SLACK
  }
  $notifier.ping "#{pomocode} complete ✨" if SLACK
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
  sh "rm #{DIV_DIR}/*.mbtiles"
  N_DIV.times {|div|
    files = Dir.glob("#{LOT_DIR}/*.mbtiles").select {|path|
      !File.exists?("#{path}-journal") &&
      File.basename(path, '.mbtiles')[-4..-1].to_i % N_DIV == div
    }
    raise "you have no lot files ready." if files.empty?
    sh <<-EOS
tile-join --force --output=#{DIV_DIR}/#{div}.mbtiles \
--no-tile-size-limit \
--minimum-zoom=#{MINZOOM} --maximum-zoom=#{MAXZOOM} \
#{files.join(' ')}
    EOS
  }
  sh <<-EOS    
tile-join --force --output=#{MBTILES_PATH} \
--no-tile-size-limit \
--minimum-zoom=#{MINZOOM} --maximum-zoom=#{MAXZOOM} \
#{DIV_DIR}/*.mbtiles; \
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

desc 'check zoom levels inside mbtiles'
task :_zoom_levels do
  SQL = 'select distinct zoom_level from tiles'
  Dir.glob("#{LOT_DIR}/*.mbtiles") {|path|
    next if File.exist?("#{path}-journal")
    sh <<-EOS
sqlite3 #{path} '#{SQL}' 2>&1
    EOS
  }
end

desc 'delete processed las files to save disk'
task :_delete_processed_las_files do
  Dir.glob("#{SRC_DIR}/*.las").sort.each {|las_path|
    basename = File.basename(las_path, '.las')
    mbtiles_path = "#{LOT_DIR}/#{basename}.mbtiles"
    if File.exist?(mbtiles_path) && !File.exist?("#{mbtiles_path}-journal")
      print "delete #{las_path} because #{mbtiles_path} exists.\n"
      sh "rm #{las_path}" unless ENV['DRY_RUN']
    else
      print "keep #{las_path} because #{mbtiles_path} is to go.\n"
    end
  }
end

desc 'automatic'
task :automatic do
  100.times {|i|
    sh "sleep 600"
    sh "rake _delete_processed_las_files"
    sh "rake tiles"
  }
end

desc 'list files to go'
task :_togo do
  mbtiles = Dir.glob("#{LOT_DIR}/*.mbtiles").map {|path|
    File.basename(path, '.mbtiles')
  }
  las = Dir.glob("#{SRC_DIR}/*.las").map {|path|
    File.basename(path, '.las')
  }
  (las - mbtiles).sort.each {|basename|
    print "#{basename}\n"
  }
end

desc 'check number of source files'
task :_source_check do
  count = 0
  10.times {|i|
    c = Dir.glob("#{SRC_DIR}/*#{i}.las").count
    print "#{i}: #{c}\n"
    count += c
  }
  print "all: #{count}\n"
end

