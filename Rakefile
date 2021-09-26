require './constants'
require 'digest/md5'
require 'slack-notifier' if SLACK

$notifier = Slack::Notifier.new WEBHOOK_URL if SLACK

def hostname
  `hostname`.strip
end

desc 'install required libraries'
task :install do
  sh "sudo gem install slack-notifier"
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
  $notifier.ping "[#{pomocode}] tiles task started@#{hostname}." if SLACK
  Dir.glob("#{SRC_DIR}/*.las").sort.each {|path|
    if false && File.size(path) < 1000000000 * 0.8
      print "skip #{path}.\n"
      next
    end
    basename = File.basename(path, '.las')
    next unless FILTERS[hostname].match basename
    mbtiles_path = "#{LOT_DIR}/#{basename}.mbtiles"
    if DIGEST_FILTER && !Digest::MD5.hexdigest(mbtiles_path)[-1] == DIGEST_KEY
      next
    end
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
    $notifier.ping "[#{pomocode}] finished #{basename}@#{hostname}." if SLACK
  }
  $notifier.ping "[#{pomocode}] tiles task@#{hostname} complete!" if SLACK
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

