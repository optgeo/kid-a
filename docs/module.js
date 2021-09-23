const style = href => {
  const e = document.createElement('link')
  e.href = href
  e.rel = 'stylesheet'
  document.head.appendChild(e)
}

const script = src => {
  const e = document.createElement('script')
  e.src = src
  document.head.appendChild(e)
}

const init = () => {
  style('style.css')
  style('https://api.mapbox.com/mapbox-gl-js/v2.4.1/mapbox-gl.css')
  script('https://api.mapbox.com/mapbox-gl-js/v2.4.1/mapbox-gl.js')
  const map = document.createElement('div')
  map.id = 'map'
  document.body.appendChild(map)
}
init()

const showMap = async (texts) => {
  mapboxgl.accessToken = 
    'pk.eyJ1IjoiaGZ1IiwiYSI6ImlRSGJVUTAifQ.rTx380smyvPc1gUfZv1cmw'
  const map = new mapboxgl.Map({
    container: 'map',
    hash: true,
    style: 'style.json',
    maxZoom: 17.8
  })
  map.addControl(new mapboxgl.NavigationControl())
  map.addControl(new mapboxgl.ScaleControl({
    maxWidth: 200, unit: 'metric'
  }))

  let voice = null
  for(let v of speechSynthesis.getVoices()) {
    console.log(v.name)
    if ([
      'Daniel',
      'Google UK English Male',
      'Microsoft Libby Online (Natural) - English (United Kingdom)'
    ].includes(v.name)) voice = v
  }

  const legend = {
    1: 'water',
    2: 'urban',
    3: 'rice paddy',
    4: 'crop',
    5: 'grassland',
    6: 'deciduous broad-leaved forest, or DBF',
    7: 'deciduous needle-leaved forest, or DNF',
    8: 'evergreen broad-leaved forest, or EBF',
    9: 'evergreen needle-leaved forest, or ENF',
    10: 'bare land',
    11: 'bamboo',
    12: 'solar panel'
  }

  map.on('load', () => {
    map.on('click', 'voxel', (e) => {
      let u = new SpeechSynthesisUtterance()
      u.lang = 'en-GB'
      u.text = legend[e.features[0].properties.classification]
      if (voice) u.voice = voice
      speechSynthesis.cancel()
      speechSynthesis.speak(u)
    })

  })
}

const main = async () => {
  if (typeof mapboxgl == 'undefined') {
    window.onload = () => {
      showMap()
    }
  } else {
    showMap()
  }
}
main()
