JOBS = 2

SRC_BASE_URL = "https://gic-shizuoka.s3-ap-northeast-1.amazonaws.com/2020/LP/00"
SRC_FILES = %w{
  08OE4948 08OE4949 08OF4040 08OF4041
  08OE4958 08OE4959 08OF4050 08OF4051
  08OE4968 08OE4969 08OF4060 08OF4061
  08OE4978 08OE4979 08OF4070 08OF4071
}

SRC_DIR = 'src'
LOT_DIR = 'lot'
MBTILES_PATH = 'tiles.mbtiles'

Z_ONE_METER = 17

MINZOOM = 8
MAXZOOM = 15 #18
LAYER_NAME = 'voxel'

STYLE_YAML_PATH = 'style.yaml'
BASE_URL = 'http://m343:9966/zxy'
