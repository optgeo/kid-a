JOBS = 1 #2
DELAY = 0 #60
CONTINUE = true

DOWNLOAD_JOBS = 1

FILTERS = {
  'm321' => /(0|3|6)$/,
  'm343' => /(1|4|7)$/,
  'm354' => /(2|5|8|9)$/
}

URLS_PATH = 'urls.txt'
SRC_DIR = 'src'
LOT_DIR = 'lot'
DIV_DIR = 'div'
N_DIV = 6
MBTILES_PATH = 'tiles.mbtiles'

Z_ONE_METER = 17

MINZOOM = 10 #8
MAXZOOM = 14 #15 #18
LAYER_NAME = 'voxel'

STYLE_YAML_PATH = 'style.yaml'
BASE_URL = 'https://x.optgeo.org/kid-a/zxy'

SLACK = true
WEBHOOK_URL = ENV['WEBHOOK_URL']

def hostname
  `hostname`.strip
end

def pomocode
  "[#{Time.now.to_i / 1800}@#{hostname}]"
end

