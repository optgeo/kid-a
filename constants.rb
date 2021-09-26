JOBS = 1 #2
DELAY = 0 #60
CONTINUE = true

DOWNLOAD_JOBS = 1

DIGEST_FILTER = false
DIGEST_KEY = '6'

FILTERS = {
  'm354' => /^08N/,
  'm321' => /^08OE8/,
  'm434' => /^08OE4/
}

URLS_PATH = 'urls-atami.txt'
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

