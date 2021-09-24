JOBS = 2 #2
DELAY = 20 #60
CONTINUE = true

DOWNLOAD_JOBS = 1

DIGEST_FILTER = false
DIGEST_KEY = '6'

URLS_PATH = 'urls.txt'
SRC_DIR = 'src'
LOT_DIR = 'lot'
MBTILES_PATH = 'tiles.mbtiles'

Z_ONE_METER = 17

MINZOOM = 10 #8
MAXZOOM = 15 #18
LAYER_NAME = 'voxel'

STYLE_YAML_PATH = 'style.yaml'
BASE_URL = 'https://x.optgeo.org/kid-a/zxy'

SLACK = true
WEBHOOK_URL = ENV['WEBHOOK_URL']

def pomocode
  Time.now.to_i / 1800
end

