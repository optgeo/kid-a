JOBS = 1 #2
DELAY = 0 #60
CONTINUE = true

DOWNLOAD_JOBS = 1

FILTERS = {
  'm321' => /(0|3)$/,
  'm343' => /(1|4|7|9)$/,
  'm354' => /(2|5|6|8)$/
}

URLS_PATH = 'urls-middle.txt'
SRC_DIR = 'src'
LOT_DIR = 'lot'
DIV_DIR = 'div'
N_DIV = 16
MBTILES_PATH = 'tiles.mbtiles'

Z_ONE_METER = 17

MINZOOM = 8 # 10 #8
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

