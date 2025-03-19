import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/city_bike_config.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/default_options.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/default_settings.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/transport_mode_config.dart';

final configHerrenbergMerged = ConfigData(
  showBikeAndPublicItineraries: true,
  showBikeAndParkItineraries: true,
  optimize: 'TRIANGLE',
  suggestCarMinDistance: 800,
  suggestWalkMaxDistance: 3000,
  suggestBikeAndPublicMinDistance: 3000,
  suggestBikeAndParkMinDistance: 3000,
  defaultSettings: DefaultSettings(
    optimize: 'TRIANGLE',
    safetyFactor: 0.4,
    slopeFactor: 0.3,
    timeFactor: 0.3,
    walkReluctance: 3,
    walkBoardCost: 150,
  ),
  defaultOptions: DefaultOptions(
    walkSpeed: [0.83, 1.38, 1.94],
  ),
  cityBike: CityBikeConfig(
    minZoomStopsNearYou: 10,
    showStationId: false,
    useSpacesAvailable: false,
    showCityBikes: true,
    networks: {
      "deer": NetworkConfig(
        icon: "brand_deer",
        operator: "deer",
        name: {"de": "deer", "en": "deer"},
        type: "car",
        formFactors: ["car"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://www.deer-carsharing.de/",
          "en": "https://www.deer-carsharing.de/"
        },
      ),
      "stadtmobil_stuttgart": NetworkConfig(
        icon: "brand_stadtmobil",
        operator: "stadtmobil",
        name: {"de": "Stadtmobil Stuttgart", "en": "Stadtmobil Stuttgart"},
        type: "car",
        formFactors: ["car"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://stuttgart.stadtmobil.de/",
          "en": "https://stuttgart.stadtmobil.de/"
        },
      ),
      "stadtmobil_karlsruhe": NetworkConfig(
        icon: "brand_stadtmobil",
        operator: "stadtmobil",
        name: {"de": "Stadtmobil Karlsruhe", "en": "Stadtmobil Karlsruhe"},
        formFactors: ["car"],
        type: "car",
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://karlsruhe.stadtmobil.de/",
          "en": "https://karlsruhe.stadtmobil.de/"
        },
      ),
      "flinkster_carsharing": NetworkConfig(
        icon: "brand_flinkster",
        operator: "flinkster",
        name: {"de": "Flinkster", "en": "Flinkster"},
        formFactors: ["car"],
        type: "car",
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://www.flinkster.de/de/start",
          "en": "https://www.flinkster.de/en/home",
        },
      ),
      "oekostadt_renningen": NetworkConfig(
        icon: "brand_stadtmobil",
        operator: "stadtmobil",
        name: {
          "de": "Ökostadt Renningen e.V.",
          "en": "Ökostadt Renningen e.V."
        },
        formFactors: ["car"],
        type: "car",
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://carsharing-renningen.de/",
          "en": "https://carsharing-renningen.de/",
        },
      ),
      "teilauto_neckar-alb": NetworkConfig(
        icon: "brand_stadtmobil",
        operator: "stadtmobil",
        name: {"de": "Teilauto Neckar-Alb", "en": "Teilauto Neckar-Alb"},
        formFactors: ["car"],
        type: "car",
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://www.teilauto-neckar-alb.de/",
          "en": "https://www.teilauto-neckar-alb.de/",
        },
      ),
      "regiorad_stuttgart": NetworkConfig(
        icon: "brand_regiorad",
        operator: "regiorad",
        name: {"de": "RegioRad Stuttgart"},
        type: "bicycle",
        formFactors: ["bicycle"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://www.regioradstuttgart.de",
          "en": "https://www.regioradstuttgart.de"
        },
      ),
      "bolt_stuttgart": NetworkConfig(
        icon: "brand_bolt",
        operator: "bolt",
        name: {"de": "Bolt OÜ", "en": "Bolt OÜ"},
        type: "scooter",
        formFactors: ["scooter", "bicycle"],
        hideCode: true,
        enabled: true,
        url: {"de": "https://www.bolt.eu/", "en": "https://www.bolt.eu/"},
      ),
      "bolt_reutlingen_tuebingen": NetworkConfig(
        icon: "brand_bolt",
        operator: "bolt",
        name: {"de": "Bolt OÜ", "en": "Bolt OÜ"},
        type: "scooter",
        formFactors: ["scooter", "bicycle"],
        hideCode: true,
        enabled: true,
        url: {"de": "https://www.bolt.eu/", "en": "https://www.bolt.eu/"},
      ),
      "zeo_bruchsal": NetworkConfig(
        icon: "brand_zeus",
        operator: "other",
        name: {"de": "Zeo Bruchsal", "en": "Zeo Bruchsal"},
        formFactors: ["car"],
        type: "car",
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://www.zeo-carsharing.de/",
          "en": "https://www.zeo-carsharing.de/",
        },
      ),
      "zeus_ludwigsburg": NetworkConfig(
        icon: "brand_zeus",
        operator: "zeus",
        name: {"de": "Zeus Scooters", "en": "Zeus Scooters"},
        type: "scooter",
        formFactors: ["scooter"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://zeusscooters.com",
          "en": "https://zeusscooters.com"
        },
      ),
      "zeus_pforzheim": NetworkConfig(
        icon: "brand_zeus",
        operator: "zeus",
        name: {"de": "Zeus Scooters", "en": "Zeus Scooters"},
        type: "scooter",
        formFactors: ["scooter"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://zeusscooters.com",
          "en": "https://zeusscooters.com"
        },
      ),
      "zeus_tubingen": NetworkConfig(
        icon: "brand_zeus",
        operator: "zeus",
        name: {"de": "Zeus Scooters", "en": "Zeus Scooters"},
        type: "scooter",
        formFactors: ["scooter"],
        hideCode: true,
        enabled: true,
        url: {
          "de": "https://zeusscooters.com",
          "en": "https://zeusscooters.com"
        },
      ),
      "voi_de": NetworkConfig(
        icon: "brand_voi",
        operator: "voi",
        name: {"de": "Voi Scooter", "en": "Voi Scooter"},
        type: "scooter",
        formFactors: ["scooter"],
        hideCode: true,
        enabled: true,
      ),
      "dott_boblingen": NetworkConfig(
        icon: "brand_dott",
        operator: "dott",
        name: {
          "de": "Dott Böblingen",
          "en": "Dott Böblingen",
        },
        type: "scooter",
        url: {
          "de": "https://ridedott.com/de/fahr-mit-uns/",
          "en": "https://ridedott.com/ride-with-us/",
        },
        visibleInSettingsUi: true,
        hideCode: true,
        enabled: true,
      ),
      "dott_ludwigsburg": NetworkConfig(
        icon: "brand_dott",
        operator: "dott",
        name: {
          "de": "Dott Ludwigsburg",
          "en": "Dott Ludwigsburg",
        },
        type: "scooter",
        url: {
          "de": "https://ridedott.com/de/fahr-mit-uns/",
          "en": "https://ridedott.com/ride-with-us/",
        },
        visibleInSettingsUi: true,
        hideCode: true,
        enabled: true,
      ),
      "dott_reutlingen": NetworkConfig(
        icon: "brand_dott",
        operator: "dott",
        name: {
          "de": "Dott Reutlingen",
          "en": "Dott Reutlingen",
        },
        type: "scooter",
        formFactors: ["scooter", "bicycle"],
        url: {
          "de": "https://ridedott.com/de/fahr-mit-uns/",
          "en": "https://ridedott.com/ride-with-us/",
        },
        visibleInSettingsUi: true,
        hideCode: true,
        enabled: true,
      ),
      "dott_stuttgart": NetworkConfig(
        icon: "brand_dott",
        operator: "dott",
        name: {
          "de": "Dott Stuttgart",
          "en": "Dott Stuttgart",
        },
        type: "scooter",
        url: {
          "de": "https://ridedott.com/de/fahr-mit-uns/",
          "en": "https://ridedott.com/ride-with-us/",
        },
        visibleInSettingsUi: true,
        hideCode: true,
        enabled: true,
      ),
      "dott_tubingen": NetworkConfig(
        icon: "brand_dott",
        operator: "dott",
        name: {
          "de": "Dott Tübingen",
          "en": "Dott Tübingen",
        },
        type: "scooter",
        formFactors: ["scooter", "bicycle"],
        url: {
          "de": "https://ridedott.com/de/fahr-mit-uns/",
          "en": "https://ridedott.com/ride-with-us/",
        },
        visibleInSettingsUi: true,
        hideCode: true,
        enabled: true,
      ),
      "de.stadtnavi.gbfs.alf": NetworkConfig(
        icon: "cargobike",
        operator: "other",
        name: {
          "de": "Lastenrad Alf",
          "en": "Cargobike Alf",
        },
        type: "cargo_bicycle",
        enabled: true,
        season: SeasonConfig.futureSeason(),
      ),
      "de.stadtnavi.gbfs.gueltstein": NetworkConfig(
        icon: "cargobike",
        operator: "other",
        name: {
          "de": "Lastenrad Gültstein-Mobil",
          "en": "Cargobike Gültstein-Mobil",
        },
        type: "cargo_bicycle",
        enabled: true,
        season: SeasonConfig.futureSeason(),
      ),
      "de.stadtnavi.gbfs.stadtrad": NetworkConfig(
        icon: "cargobike",
        operator: "other",
        name: {
          "de": "stadtRad der Stadt Herrenberg",
          "en": "City of Herrenberg's StadtRad",
        },
        type: "cargo_bicycle",
        enabled: true,
        season: SeasonConfig.futureSeason(),
      ),
      "de.stadtnavi.gbfs.bananologen": NetworkConfig(
        icon: "cargobike",
        operator: "other",
        name: {
          "de": "Lastenrad Bananologen",
          "en": "Cargobike Bananologen",
        },
        type: "cargo_bicycle",
        enabled: true,
        season: SeasonConfig.futureSeason(),
      ),
    },
    operators: {
      "taxi": OperatorConfig(
        icon: "brand_taxi",
        iconCode: """<svg
   width="350"
   height="350"
   id="icon-icon_brand_taxi"
   version="1.1"
   inkscape:version="1.1 (c4e8f9e, 2021-05-24)"
   sodipodi:docname="icon-icon_brand_taxi.svg"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:dc="http://purl.org/dc/elements/1.1/">
  <sodipodi:namedview
     id="base"
     pagecolor="#ffffff"
     bordercolor="#666666"
     borderopacity="1.0"
     inkscape:pageopacity="0.0"
     inkscape:pageshadow="2"
     inkscape:zoom="1.4142136"
     inkscape:cx="405.17217"
     inkscape:cy="155.20993"
     inkscape:document-units="px"
     inkscape:current-layer="text3786"
     showgrid="false"
     inkscape:window-width="1680"
     inkscape:window-height="997"
     inkscape:window-x="0"
     inkscape:window-y="25"
     inkscape:window-maximized="1"
     inkscape:pagecheckerboard="0"
     inkscape:lockguides="true" />
  <g
     inkscape:label="Ebene 1"
     inkscape:groupmode="layer"
     id="layer1"
     transform="translate(-100,-833.36218)">
    <rect
       style="fill:#000000;fill-opacity:1;stroke:none;stroke-width:1.06363"
       id="rect3819"
       width="330"
       height="330"
       x="100.05853"
       y="848.53247" />
    <rect
       style="fill:#000000;fill-opacity:1;stroke:none;stroke-width:1.06363"
       id="rect3819"
       width="311.81104"
       height="284.45081"
       x="113.05853"
       y="863.53247" />
    <g
       transform="matrix(1.1450813,3.6327727e-4,-2.7420152e-4,0.87330036,0,0)"
       style="font-style:normal;font-weight:normal;font-size:162.766px;line-height:125%;font-family:Sans;letter-spacing:0px;word-spacing:0px;fill:#ffcc00;fill-opacity:1;stroke:none"
       id="text3786">
      <path
         d="m 168.2058,1143.7552 v -96.8011 h -34.57184 v -19.7099 h 92.58895 v 19.7099 h -34.49236 v 96.8011 z"
         style="font-weight:bold;-inkscape-font-specification:'Sans Bold';fill:#ffcc00;fill-opacity:1"
         id="path2991" />
      <path
         d="M 346.54881,1143.7552 H 320.9577 l -10.17286,-26.4653 H 264.2122 l -9.61654,26.4653 h -24.9553 l 45.3805,-116.511 h 24.87583 z m -43.31415,-46.0957 -16.05405,-43.2347 -15.73614,43.2347 z"
         style="font-weight:bold;-inkscape-font-specification:'Sans Bold';fill:#ffcc00;fill-opacity:1"
         id="path2993" />
    </g>
    <g
       transform="matrix(1.1450813,3.6327727e-4,-2.7420152e-4,0.87330036,-4.2903506,126.40492)"
       style="font-style:normal;font-weight:normal;font-size:162.766px;line-height:125%;font-family:Sans;letter-spacing:0px;word-spacing:0px;fill:#ffcc00;fill-opacity:1;stroke:none"
       id="text3786-1">
      <path
         d="m 130.51304,1132.5096 39.81723,-60.7987 -36.08188,-55.7123 h 27.49852 l 23.3658,37.4329 22.88894,-37.4329 h 27.26009 l -36.24082,56.5865 39.81722,59.9245 h -28.37275 l -25.82954,-40.294 -25.90901,40.294 z"
         style="font-weight:bold;-inkscape-font-specification:'Sans Bold';fill:#ffcc00;fill-opacity:1"
         id="path2995-2"
         inkscape:label="path-X" />
    </g>
    <g
       transform="matrix(1.1450813,3.6327727e-4,-2.7420152e-4,0.87330036,26.853166,127.07257)"
       style="font-style:normal;font-weight:normal;font-size:162.766px;line-height:125%;font-family:Sans;letter-spacing:0px;word-spacing:0px;fill:#ffcc00;fill-opacity:1;stroke:none"
       id="text3786-1-7">
      <path
         d="m 250.36209,1132.5096 v -116.511 h 23.52474 v 116.511 z"
         style="font-weight:bold;-inkscape-font-specification:'Sans Bold';fill:#ffcc00;fill-opacity:1"
         id="path2997-1-1"
         inkscape:label="path-I" />
    </g>
    <rect
       style="fill:#ffcc00;fill-opacity:1;stroke:none"
       id="rect3033"
       width="50.204582"
       height="22.627417"
       x="302.64169"
       y="112.93398"
       transform="translate(0,833.36218)"
       inkscape:label="path-TA" />
  </g>
</svg>""",
        name: {"de": "Taxi", "en": "Taxi"},
        colors: {"background": "#FFCD00"},
      ),
      "flinkster": OperatorConfig(
        icon: "brand_flinkster",
        iconCode: """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="225px" height="225px" style="shape-rendering:geometricPrecision; text-rendering:geometricPrecision; image-rendering:optimizeQuality; fill-rule:evenodd; clip-rule:evenodd" xmlns:xlink="http://www.w3.org/1999/xlink">
<g><path style="opacity:1" fill="#fffefe" d="M -0.5,-0.5 C 74.5,-0.5 149.5,-0.5 224.5,-0.5C 224.5,23.8333 224.5,48.1667 224.5,72.5C 149.5,72.5 74.5,72.5 -0.5,72.5C -0.5,48.1667 -0.5,23.8333 -0.5,-0.5 Z"/></g>
<g><path style="opacity:1" fill="#ed201e" d="M 82.5,12.5 C 102.925,12.0236 123.259,12.5236 143.5,14C 144.701,14.9025 145.535,16.0692 146,17.5C 146.963,31.2611 146.63,44.9278 145,58.5C 144.25,59.1258 143.416,59.6258 142.5,60C 122.167,60.6667 101.833,60.6667 81.5,60C 80.6667,59.1667 79.8333,58.3333 79,57.5C 78.3333,43.8333 78.3333,30.1667 79,16.5C 80.1022,15.051 81.2689,13.7177 82.5,12.5 Z"/></g>
<g><path style="opacity:1" fill="#fff1f2" d="M 83.5,17.5 C 102.503,17.3334 121.503,17.5001 140.5,18C 141.489,30.42 141.822,42.92 141.5,55.5C 122.164,55.6666 102.83,55.5 83.5,55C 82.1759,42.5001 82.1759,30.0001 83.5,17.5 Z"/></g>
<g><path style="opacity:1" fill="#ed181d" d="M 114.5,21.5 C 121.284,21.0796 127.95,21.5796 134.5,23C 137.649,27.9618 136.982,32.2951 132.5,36C 137.738,39.2738 138.904,43.7738 136,49.5C 134.581,50.4601 133.081,51.2935 131.5,52C 125.843,52.4994 120.176,52.6661 114.5,52.5C 114.5,42.1667 114.5,31.8333 114.5,21.5 Z"/></g>
<g><path style="opacity:1" fill="#ec0f17" d="M 87.5,21.5 C 107.526,17.9183 115.026,25.9183 110,45.5C 108.878,47.6238 107.378,49.4571 105.5,51C 99.6208,52.4101 93.6208,52.9101 87.5,52.5C 87.5,42.1667 87.5,31.8333 87.5,21.5 Z"/></g>
<g><path style="opacity:1" fill="#fefbfb" d="M 99.5,26.5 C 100.794,27.2899 101.961,28.2899 103,29.5C 103.667,34.1667 103.667,38.8333 103,43.5C 101.682,46.9414 99.1816,48.2747 95.5,47.5C 95.5,40.5 95.5,33.5 95.5,26.5C 96.8333,26.5 98.1667,26.5 99.5,26.5 Z"/></g>
<g><path style="opacity:1" fill="#fff0f0" d="M 122.5,25.5 C 129.004,25.1377 130.671,27.6377 127.5,33C 125.866,33.4935 124.199,33.6602 122.5,33.5C 122.5,30.8333 122.5,28.1667 122.5,25.5 Z"/></g>
<g><path style="opacity:1" fill="#f79fa3" d="M 99.5,26.5 C 98.1667,26.5 96.8333,26.5 95.5,26.5C 95.5,33.5 95.5,40.5 95.5,47.5C 94.5084,40.3524 94.175,33.0191 94.5,25.5C 96.4147,25.2155 98.0813,25.5489 99.5,26.5 Z"/></g>
<g><path style="opacity:1" fill="#fef8f9" d="M 122.5,39.5 C 124.527,39.3379 126.527,39.5045 128.5,40C 131.167,42.3333 131.167,44.6667 128.5,47C 126.527,47.4955 124.527,47.6621 122.5,47.5C 122.5,44.8333 122.5,42.1667 122.5,39.5 Z"/></g>
<g><path style="opacity:1" fill="#ec0116" d="M -0.5,72.5 C 74.5,72.5 149.5,72.5 224.5,72.5C 224.5,123.167 224.5,173.833 224.5,224.5C 149.5,224.5 74.5,224.5 -0.5,224.5C -0.5,173.833 -0.5,123.167 -0.5,72.5 Z"/></g>
<g><path style="opacity:1" fill="#fff4f4" d="M 61.5,112.5 C 80.2135,112.066 98.8802,112.566 117.5,114C 129.67,118.085 141.003,123.752 151.5,131C 162.828,133.665 174.162,136.332 185.5,139C 195.548,143.269 199.048,150.769 196,161.5C 195.167,163.667 193.667,165.167 191.5,166C 187.568,167.655 183.568,168.655 179.5,169C 178.167,167.333 178.167,165.667 179.5,164C 183.099,162.691 186.599,161.191 190,159.5C 192.711,151.226 189.877,146.059 181.5,144C 170.736,142.047 160.069,139.714 149.5,137C 139.003,129.752 127.67,124.085 115.5,120C 97.8862,118.389 80.2195,118.056 62.5,119C 52.1568,125.334 42.9901,133.168 35,142.5C 34.3333,148.833 34.3333,155.167 35,161.5C 37.3914,162.429 39.2247,163.929 40.5,166C 39.7916,168.723 38.1249,169.723 35.5,169C 32.4173,168.214 30.2506,166.381 29,163.5C 28.3333,155.833 28.3333,148.167 29,140.5C 36.5,133 44,125.5 51.5,118C 54.7667,115.87 58.1,114.037 61.5,112.5 Z"/></g>
<g><path style="opacity:1" fill="#fef6f6" d="M 92.5,124.5 C 94.1439,124.286 95.6439,124.62 97,125.5C 97.2069,129.089 97.7069,132.589 98.5,136C 109.833,136.333 121.167,136.667 132.5,137C 133.991,139.022 133.658,140.688 131.5,142C 119.833,142.667 108.167,142.667 96.5,142C 94.3333,141.167 92.8333,139.667 92,137.5C 91.2316,133.08 91.3982,128.747 92.5,124.5 Z"/></g>
<g><path style="opacity:1" fill="#fff4f5" d="M 56.5,154.5 C 72.9972,154.183 78.8306,161.85 74,177.5C 65.9629,186.366 57.6295,186.699 49,178.5C 43.6717,167.862 46.1717,159.862 56.5,154.5 Z"/></g>
<g><path style="opacity:1" fill="#fff4f4" d="M 152.5,154.5 C 165.999,153.171 172.499,159.171 172,172.5C 166.232,185.555 157.566,187.889 146,179.5C 139.709,168.87 141.876,160.537 152.5,154.5 Z"/></g>
<g><path style="opacity:1" fill="#ec101a" d="M 153.5,160.5 C 163.859,160.014 167.692,164.681 165,174.5C 159.963,179.712 154.963,179.712 150,174.5C 148.543,171.634 148.21,168.634 149,165.5C 150.707,163.963 152.207,162.296 153.5,160.5 Z"/></g>
<g><path style="opacity:1" fill="#ec111a" d="M 57.5,160.5 C 68.8085,160.285 72.3085,165.285 68,175.5C 61.8382,180.134 56.8382,179.134 53,172.5C 52.3333,170.167 52.3333,167.833 53,165.5C 54.3657,163.638 55.8657,161.972 57.5,160.5 Z"/></g>
<g><path style="opacity:1" fill="#fef7f7" d="M 83.5,166.5 C 100.837,166.333 118.17,166.5 135.5,167C 136.991,169.022 136.658,170.688 134.5,172C 117.5,172.667 100.5,172.667 83.5,172C 82.2475,170.172 82.2475,168.339 83.5,166.5 Z"/></g>
</svg>
""",
        name: {
          "de": "Flinkster",
          "en": "Flinkster",
        },
        url: {
          "de": "https://www.flinkster.de/de/start",
          "en": "https://www.flinkster.de/en/home"
        },
        colors: {
          "background": "#D50F0F",
        },
      ),
      "deer": OperatorConfig(
        icon: "brand_deer",
        iconCode: """
<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="100%" viewBox="0 0 300 300" enable-background="new 0 0 300 300" xml:space="preserve">
<path fill="#32A600" opacity="1.000000" stroke="none" 
	d="
M142.000000,301.000000 
	C94.666664,301.000000 47.833332,301.000000 1.000000,301.000000 
	C1.000000,201.000000 1.000000,101.000000 1.000000,1.000000 
	C101.000000,1.000000 201.000000,1.000000 301.000000,1.000000 
	C301.000000,101.000000 301.000000,201.000000 301.000000,301.000000 
	C248.166672,301.000000 195.333328,301.000000 142.000000,301.000000 
M171.263199,200.573166 
	C155.618927,198.031860 142.216827,191.207352 131.644333,179.319534 
	C129.160553,176.526764 127.481522,173.018265 125.432259,169.839035 
	C125.797356,169.461945 126.162445,169.084869 126.527542,168.707779 
	C132.480942,169.976273 138.383850,171.618881 144.398880,172.430817 
	C155.011032,173.863312 165.669891,175.348297 176.349854,175.762192 
	C186.052902,176.138245 195.424606,167.337906 197.817810,156.638092 
	C201.027863,142.286224 199.739990,127.805565 198.009796,113.439095 
	C196.710571,102.651009 192.329651,92.988762 184.684860,85.036255 
	C174.021866,73.944038 161.487534,72.010643 148.040680,79.459427 
	C136.494003,85.855621 129.423355,96.091957 125.447411,108.219467 
	C122.316032,117.770874 120.590691,127.783241 118.112045,138.128326 
	C112.244850,138.876114 107.192719,134.616150 101.398430,133.186188 
	C98.102203,132.372696 97.216949,130.507538 96.867760,127.214462 
	C95.691719,116.123650 91.408585,106.525902 81.003288,101.113785 
	C73.812523,97.373634 66.239960,94.367546 59.262737,91.224747 
	C57.250862,94.407242 55.888481,99.072845 53.546558,99.631393 
	C50.619686,100.329468 46.883450,97.658897 43.504951,96.419899 
	C42.728081,96.134987 41.989872,95.746330 41.225822,95.424545 
	C37.123466,93.696800 33.693501,94.641159 32.439404,98.065887 
	C30.980919,102.048790 33.151844,104.295616 36.524197,105.917458 
	C41.171173,108.152298 45.769733,110.487793 50.770176,112.969299 
	C48.980457,118.418396 47.206295,123.820114 45.274158,129.702805 
	C40.866711,127.740639 37.138184,125.998573 33.343086,124.416161 
	C30.087587,123.058746 26.809082,123.087837 25.339209,126.794266 
	C23.983788,130.212082 24.860853,133.250015 28.695387,134.993393 
	C32.812321,136.865189 36.793648,139.035202 40.843628,141.079880 
	C39.878090,144.601395 39.012703,147.757660 38.046112,151.283035 
	C43.609116,154.138382 49.042747,156.956299 54.502281,159.723099 
	C63.775269,164.422531 73.062363,164.963409 81.957458,159.014343 
	C86.766472,155.798065 91.153008,151.718124 96.291481,158.298798 
	C96.387070,158.421219 96.562279,158.500610 96.716225,158.555557 
	C101.808090,160.372665 106.794296,162.639511 112.024033,163.875732 
	C117.900917,165.264923 119.234810,168.799744 120.291893,174.304581 
	C124.805748,197.810822 136.490921,215.996796 160.301117,224.189575 
	C170.637405,227.746155 181.649826,228.784103 191.963531,226.477051 
	C204.335831,223.709518 216.022125,218.182388 226.159943,209.976349 
	C250.870850,189.974106 261.515869,163.051193 264.890259,132.122543 
	C263.850586,132.702850 262.698914,132.950012 262.300568,133.635147 
	C260.365936,136.962814 258.931000,140.610947 256.773956,143.773819 
	C249.892044,153.864731 243.632187,164.560638 235.557907,173.619843 
	C218.863632,192.350540 198.407822,203.692978 171.263199,200.573166 
z"/>
<path fill="#FCFDFB" opacity="1.000000" stroke="none" 
	d="
M171.704803,200.643616 
	C198.407822,203.692978 218.863632,192.350540 235.557907,173.619843 
	C243.632187,164.560638 249.892044,153.864731 256.773956,143.773819 
	C258.931000,140.610947 260.365936,136.962814 262.300568,133.635147 
	C262.698914,132.950012 263.850586,132.702850 264.890259,132.122543 
	C261.515869,163.051193 250.870850,189.974106 226.159943,209.976349 
	C216.022125,218.182388 204.335831,223.709518 191.963531,226.477051 
	C181.649826,228.784103 170.637405,227.746155 160.301117,224.189575 
	C136.490921,215.996796 124.805748,197.810822 120.291893,174.304581 
	C119.234810,168.799744 117.900917,165.264923 112.024033,163.875732 
	C106.794296,162.639511 101.808090,160.372665 96.716225,158.555557 
	C96.562279,158.500610 96.387070,158.421219 96.291481,158.298798 
	C91.153008,151.718124 86.766472,155.798065 81.957458,159.014343 
	C73.062363,164.963409 63.775269,164.422531 54.502281,159.723099 
	C49.042747,156.956299 43.609116,154.138382 38.046112,151.283035 
	C39.012703,147.757660 39.878090,144.601395 40.843628,141.079880 
	C36.793648,139.035202 32.812321,136.865189 28.695387,134.993393 
	C24.860853,133.250015 23.983788,130.212082 25.339209,126.794266 
	C26.809082,123.087837 30.087587,123.058746 33.343086,124.416161 
	C37.138184,125.998573 40.866711,127.740639 45.274158,129.702805 
	C47.206295,123.820114 48.980457,118.418396 50.770176,112.969299 
	C45.769733,110.487793 41.171173,108.152298 36.524197,105.917458 
	C33.151844,104.295616 30.980919,102.048790 32.439404,98.065887 
	C33.693501,94.641159 37.123466,93.696800 41.225822,95.424545 
	C41.989872,95.746330 42.728081,96.134987 43.504951,96.419899 
	C46.883450,97.658897 50.619686,100.329468 53.546558,99.631393 
	C55.888481,99.072845 57.250862,94.407242 59.262737,91.224747 
	C66.239960,94.367546 73.812523,97.373634 81.003288,101.113785 
	C91.408585,106.525902 95.691719,116.123650 96.867760,127.214462 
	C97.216949,130.507538 98.102203,132.372696 101.398430,133.186188 
	C107.192719,134.616150 112.244850,138.876114 118.112045,138.128326 
	C120.590691,127.783241 122.316032,117.770874 125.447411,108.219467 
	C129.423355,96.091957 136.494003,85.855621 148.040680,79.459427 
	C161.487534,72.010643 174.021866,73.944038 184.684860,85.036255 
	C192.329651,92.988762 196.710571,102.651009 198.009796,113.439095 
	C199.739990,127.805565 201.027863,142.286224 197.817810,156.638092 
	C195.424606,167.337906 186.052902,176.138245 176.349854,175.762192 
	C165.669891,175.348297 155.011032,173.863312 144.398880,172.430817 
	C138.383850,171.618881 132.480942,169.976273 126.527542,168.707779 
	C126.162445,169.084869 125.797356,169.461945 125.432259,169.839035 
	C127.481522,173.018265 129.160553,176.526764 131.644333,179.319534 
	C142.216827,191.207352 155.618927,198.031860 171.704803,200.643616 
M183.027847,148.132431 
	C185.741470,146.571274 188.914856,145.479401 191.079956,143.358322 
	C196.889435,137.666962 198.599472,133.213120 196.126724,127.296669 
	C192.285019,118.104782 186.124573,111.128555 177.761841,105.672211 
	C168.230103,99.453140 151.790756,101.220238 143.393143,108.485161 
	C133.265839,117.246475 127.798096,128.782944 122.844368,141.317612 
	C135.055573,145.807388 147.433548,147.751160 160.805054,149.102631 
	C167.975433,148.782211 175.145798,148.461777 183.027847,148.132431 
z"/>
<path fill="#32A602" opacity="1.000000" stroke="none" 
	d="
M159.979477,148.919937 
	C147.433548,147.751160 135.055573,145.807388 122.844368,141.317612 
	C127.798096,128.782944 133.265839,117.246475 143.393143,108.485161 
	C151.790756,101.220238 168.230103,99.453140 177.761841,105.672211 
	C186.124573,111.128555 192.285019,118.104782 196.126724,127.296669 
	C198.599472,133.213120 196.889435,137.666962 191.079956,143.358322 
	C188.914856,145.479401 185.741470,146.571274 182.184387,148.099182 
	C174.220428,148.350601 167.099960,148.635269 159.979477,148.919937 
z"/>
<path fill="#2FA924" opacity="1.000000" stroke="none" 
	d="
M160.392273,149.011292 
	C167.099960,148.635269 174.220428,148.350601 181.828552,148.103638 
	C175.145798,148.461777 167.975433,148.782211 160.392273,149.011292 
z"/>
</svg>""",
        name: {"de": "deer", "en": "deer"},
        url: {"de": "https://www.deer-carsharing.de/"},
        colors: {"background": "#3C8325"},
      ),
      "bolt": OperatorConfig(
        icon: "brand_bolt",
        iconCode: """
<svg
   version="1.1"
   id="Layer_1"
   x="0px"
   y="0px"
   width="400"
   viewBox="0 0 400 400"
   enable-background="new 0 0 400 400"
   xml:space="preserve"
   sodipodi:docname="bolt.svg"
   height="400"
   inkscape:version="1.2.1 (9c6d41e410, 2022-07-14)"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg"><defs
   id="defs23" /><sodipodi:namedview
   id="namedview21"
   pagecolor="#ffffff"
   bordercolor="#000000"
   borderopacity="0.25"
   inkscape:showpageshadow="2"
   inkscape:pageopacity="0.0"
   inkscape:pagecheckerboard="0"
   inkscape:deskcolor="#d1d1d1"
   showgrid="false"
   inkscape:zoom="2.0925"
   inkscape:cx="198.80526"
   inkscape:cy="199.28315"
   inkscape:window-width="1920"
   inkscape:window-height="1017"
   inkscape:window-x="-8"
   inkscape:window-y="-8"
   inkscape:window-maximized="1"
   inkscape:current-layer="Layer_1" />
<path
   fill="#34d186"
   opacity="1"
   stroke="none"
   d="M 231,400 C 153.66667,400 76.833336,400 0,400 0,266.66666 0,133.33333 0,0 c 133.33333,0 266.66666,0 400,0 0,133.33333 0,266.66666 0,400 -56.16666,0 -112.33334,0 -169,0 M 145.97133,237.32677 c 5.96036,-14.20018 4.84418,-27.65892 -4.71738,-39.9262 -2.08587,-2.67613 -2.08078,-4.44783 -0.73558,-7.42532 10.60227,-23.46698 -3.80134,-50.11662 -29.44376,-53.07451 -13.315295,-1.5359 -26.918879,-0.57889 -40.392405,-0.7321 -3.10334,-0.0353 -6.207428,-0.005 -9.437126,-0.005 0,41.23425 0,81.78109 0,122.83879 1.856804,0 3.473831,0 5.090851,0 14.484428,0 28.968941,-0.0318 43.45326,0.009 16.09862,0.0448 28.11529,-6.81854 36.18214,-21.68397 m 20.51906,-48.32016 c -0.75415,1.0979 -1.55715,2.16569 -2.25519,3.29817 -12.10959,19.64651 -6.97524,45.63566 11.71135,59.34157 18.29532,13.41893 44.69679,10.71885 59.3902,-6.07382 16.88015,-19.29189 15.08638,-47.55031 -4.05445,-63.87215 -19.46724,-16.60018 -47.65696,-13.64717 -64.79191,7.30623 m 158.04162,25.49488 c 0,-4.08529 0,-8.1706 0,-12.8638 5.19516,0 9.58518,0 13.97535,0 0,-9.88243 0,-19.12478 0,-28.82153 -3.46402,0 -6.61567,-0.18745 -9.73475,0.0512 -3.31677,0.25374 -4.39456,-1.04907 -4.28869,-4.28085 0.18866,-5.75974 0.0531,-11.53011 0.0531,-17.97638 -8.70102,1.86482 -16.57828,3.79098 -24.55191,5.15341 -3.54825,0.60625 -4.61295,1.93904 -4.59119,5.48286 0.14514,23.6399 -0.0478,47.28194 0.11252,70.92163 0.14529,21.422 20.78934,34.47509 40.51663,25.74044 1.17188,-0.51889 2.78534,-1.83173 2.82407,-2.82831 0.25387,-6.53391 0.1308,-13.08246 0.1308,-19.69402 -11.24323,1.38437 -14.17536,-1.07283 -14.42978,-11.39755 -0.0697,-2.82855 -0.0143,-5.6602 -0.0161,-9.48705 m -63.88716,-73.3172 c -1.58371,0.43506 -3.16745,0.87011 -4.80676,1.32043 0,38.85518 0,77.5288 0,116.25089 9.64105,0 18.89825,0 28.36352,0 0,-40.76195 0,-81.26284 0,-122.41069 -7.87817,1.62452 -15.3085,3.1567 -23.55676,4.83937 m -47.0501,152.82278 c 4.13245,-5.54037 4.43898,-11.31842 0.82862,-17.1788 -2.93076,-4.75723 -8.87241,-7.33341 -14.16283,-6.39163 -6.40059,1.13937 -11.19119,5.66226 -12.22122,11.5383 -1.1256,6.4212 1.76808,12.67187 7.25551,15.67273 5.57708,3.04992 12.35064,1.87619 18.29992,-3.6406 z"
   id="path2" />
<path
   fill="#fefffe"
   opacity="1"
   stroke="none"
   d="m 145.81302,237.66869 c -7.90854,14.52351 -19.92521,21.38688 -36.02383,21.34205 -14.484319,-0.0403 -28.968832,-0.009 -43.45326,-0.009 -1.61702,0 -3.234047,0 -5.090851,0 0,-41.0577 0,-81.60454 0,-122.83879 3.229698,0 6.333786,-0.0301 9.437126,0.005 13.473526,0.15321 27.07711,-0.8038 40.392405,0.7321 25.64242,2.95789 40.04603,29.60753 29.44376,53.07451 -1.3452,2.97749 -1.35029,4.74919 0.73558,7.42532 9.56156,12.26728 10.67774,25.72602 4.55907,40.26812 m -43.32013,-25.51545 c -3.9413,0 -7.882599,0 -12.037995,0 0,6.23636 0,11.79831 0,17.71425 7.57766,0 14.876635,0.28778 22.139065,-0.10312 4.69244,-0.25258 7.92483,-4.3814 7.88428,-8.8088 -0.043,-4.70118 -3.5392,-8.402 -8.5159,-8.7483 -2.81752,-0.19604 -5.65903,-0.0474 -9.46945,-0.054 m 7.40853,-45.92355 c -6.37405,-0.4939 -12.748107,-0.98779 -19.460899,-1.50795 0,6.63295 0,12.19618 0,18.2888 4.894295,0 9.519959,-0.13046 14.134879,0.0363 4.71971,0.1705 8.17883,-1.59822 9.80632,-6.07218 1.59268,-4.37823 -0.16173,-7.76139 -4.4803,-10.74493 z"
   id="path4" />
<path
   fill="#fdfffe"
   opacity="1"
   stroke="none"
   d="m 166.71072,188.72403 c 16.91462,-20.67082 45.10434,-23.62383 64.57158,-7.02365 19.14083,16.32184 20.9346,44.58026 4.05445,63.87215 -14.69341,16.79267 -41.09488,19.49275 -59.3902,6.07382 -18.68659,-13.70591 -23.82094,-39.69506 -11.71135,-59.34157 0.69804,-1.13248 1.50104,-2.20027 2.47552,-3.58075 m 45.43012,16.61665 c -6.39937,-4.87056 -12.17598,-5.32902 -17.84821,-1.41649 -5.22128,3.60147 -7.53528,9.99805 -5.61487,15.74982 1.98287,5.93883 6.16866,9.51772 12.33648,10.12303 5.97517,0.58643 10.78712,-2.02492 13.66317,-7.30362 3.20058,-5.87428 2.34172,-11.52733 -2.53657,-17.15274 z"
   id="path6" />
<path
   fill="#fafefc"
   opacity="1"
   stroke="none"
   d="m 324.53192,214.9998 c 0.002,3.32854 -0.0535,6.16019 0.0162,8.98874 0.25442,10.32472 3.18655,12.78192 14.42978,11.39755 0,6.61156 0.12307,13.16011 -0.1308,19.69402 -0.0387,0.99658 -1.65219,2.30942 -2.82407,2.82831 -19.72729,8.73465 -40.37134,-4.31844 -40.51663,-25.74044 -0.16031,-23.63969 0.0326,-47.28173 -0.11252,-70.92163 -0.0218,-3.54382 1.04294,-4.87661 4.59119,-5.48286 7.97363,-1.36243 15.85089,-3.28859 24.55191,-5.15341 0,6.44627 0.13559,12.21664 -0.0531,17.97638 -0.10587,3.23178 0.97192,4.53459 4.28869,4.28085 3.11908,-0.2386 6.27073,-0.0512 9.73475,-0.0512 0,9.69675 0,18.9391 0,28.82153 -4.39017,0 -8.78019,0 -13.97535,0 0,4.6932 0,8.77851 -9e-5,13.36211 z"
   id="path8" />
<path
   fill="#f8fdfb"
   opacity="1"
   stroke="none"
   d="m 261.05386,141.10979 c 7.8393,-1.60743 15.26963,-3.13961 23.1478,-4.76413 0,41.14785 0,81.64874 0,122.41069 -9.46527,0 -18.72247,0 -28.36352,0 0,-38.72209 0,-77.39571 0,-116.25089 1.63931,-0.45032 3.22305,-0.88537 5.21572,-1.39567 z"
   id="path10" />
<path
   fill="#fbfefd"
   opacity="1"
   stroke="none"
   d="m 213.34766,294.28543 c -5.70214,5.23917 -12.4757,6.4129 -18.05278,3.36298 -5.48743,-3.00086 -8.38111,-9.25153 -7.25551,-15.67273 1.03003,-5.87604 5.82063,-10.39893 12.22122,-11.5383 5.29042,-0.94178 11.23207,1.6344 14.16283,6.39163 3.61036,5.86038 3.30383,11.63843 -1.07576,17.45642 z"
   id="path12" />
<path
   fill="#39d289"
   opacity="1"
   stroke="none"
   d="m 102.98275,212.15326 c 3.32056,0.007 6.16207,-0.14203 8.97959,0.054 4.9767,0.3463 8.47285,4.04712 8.5159,8.7483 0.0405,4.4274 -3.19184,8.55622 -7.88428,8.8088 -7.26243,0.3909 -14.561405,0.10312 -22.139065,0.10312 0,-5.91594 0,-11.47789 0,-17.71425 4.155396,0 8.096695,0 12.527855,2e-5 z"
   id="path14" />
<path
   fill="#39d289"
   opacity="1"
   stroke="none"
   d="m 110.23692,166.4373 c 3.98307,2.77593 5.73748,6.15909 4.1448,10.53732 -1.62749,4.47396 -5.08661,6.24268 -9.80632,6.07218 -4.61492,-0.16672 -9.240584,-0.0363 -14.134879,-0.0363 0,-6.09262 0,-11.65585 0,-18.2888 6.712792,0.52016 13.086849,1.01405 19.796399,1.71556 z"
   id="path16" />
<path
   fill="#37d288"
   opacity="1"
   stroke="none"
   d="m 212.40063,205.60638 c 4.6185,5.35971 5.47736,11.01276 2.27678,16.88704 -2.87605,5.2787 -7.688,7.89005 -13.66317,7.30362 -6.16782,-0.60531 -10.35361,-4.1842 -12.33648,-10.12303 -1.92041,-5.75177 0.39359,-12.14835 5.61487,-15.74982 5.67223,-3.91253 11.44884,-3.45407 18.108,1.68219 z"
   id="path18" />
</svg>
""",
        name: {"de": "bolt", "en": "bolt"},
        colors: {"background": "#30D287"},
      ),
      "voi": OperatorConfig(
        icon: "brand_voi",
        iconCode: """
<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	 width="100%" viewBox="0 0 225 225" enable-background="new 0 0 225 225" xml:space="preserve">
<path fill="#F46C63" opacity="1.000000" stroke="none" 
	d="
M147.000000,226.000000 
	C98.000000,226.000000 49.500008,226.000000 1.000006,226.000000 
	C1.000004,151.000000 1.000004,76.000015 1.000002,1.000017 
	C75.999992,1.000011 150.999985,1.000011 225.999969,1.000005 
	C225.999985,75.999985 225.999985,150.999969 226.000000,225.999969 
	C199.833328,226.000000 173.666672,226.000000 147.000000,226.000000 
M82.821411,103.659775 
	C76.972137,89.336571 71.168190,74.994431 65.204361,60.719090 
	C64.599800,59.271954 63.060265,57.189762 61.906586,57.158199 
	C51.688637,56.878685 41.459839,56.995831 31.215219,56.995831 
	C31.215219,58.040607 31.114206,58.406387 31.229538,58.681469 
	C46.152218,94.273216 61.059437,129.871643 76.152542,165.391068 
	C76.708733,166.699951 79.067474,167.958801 80.624397,168.007019 
	C88.948395,168.264801 97.291786,167.927094 105.613228,168.223404 
	C109.337769,168.356033 111.133873,167.198349 112.589287,163.693237 
	C124.646408,134.655807 136.923523,105.709717 149.137375,76.737381 
	C151.827774,70.355499 154.531219,63.979115 157.491913,56.977654 
	C148.147812,56.977654 139.666367,57.146881 131.197342,56.896282 
	C127.696648,56.792694 125.970154,57.856750 124.603630,61.199333 
	C117.238564,79.214584 109.591820,97.114769 102.026207,115.047882 
	C99.671028,120.630478 97.265762,126.191940 94.566628,132.503906 
	C90.488289,122.540085 86.773735,113.465019 82.821411,103.659775 
M187.250443,166.924484 
	C196.168106,160.202057 199.119812,149.685577 194.659897,140.525787 
	C190.596283,132.179916 180.434479,127.770683 170.863113,130.468994 
	C163.597092,132.517395 158.635254,137.115494 157.011169,144.701981 
	C155.223343,153.053513 157.235962,160.370407 164.112320,165.670944 
	C171.108521,171.063858 178.768372,171.375916 187.250443,166.924484 
z"/>
<path fill="#FFFEFE" opacity="1.000000" stroke="none" 
	d="
M82.940292,104.024872 
	C86.773735,113.465019 90.488289,122.540085 94.566628,132.503906 
	C97.265762,126.191940 99.671028,120.630478 102.026207,115.047882 
	C109.591820,97.114769 117.238564,79.214584 124.603630,61.199333 
	C125.970154,57.856750 127.696648,56.792694 131.197342,56.896282 
	C139.666367,57.146881 148.147812,56.977654 157.491913,56.977654 
	C154.531219,63.979115 151.827774,70.355499 149.137375,76.737381 
	C136.923523,105.709717 124.646408,134.655807 112.589287,163.693237 
	C111.133873,167.198349 109.337769,168.356033 105.613228,168.223404 
	C97.291786,167.927094 88.948395,168.264801 80.624397,168.007019 
	C79.067474,167.958801 76.708733,166.699951 76.152542,165.391068 
	C61.059437,129.871643 46.152218,94.273216 31.229538,58.681469 
	C31.114206,58.406387 31.215219,58.040607 31.215219,56.995831 
	C41.459839,56.995831 51.688637,56.878685 61.906586,57.158199 
	C63.060265,57.189762 64.599800,59.271954 65.204361,60.719090 
	C71.168190,74.994431 76.972137,89.336571 82.940292,104.024872 
z"/>
<path fill="#FFFDFD" opacity="1.000000" stroke="none" 
	d="
M186.922455,167.100906 
	C178.768372,171.375916 171.108521,171.063858 164.112320,165.670944 
	C157.235962,160.370407 155.223343,153.053513 157.011169,144.701981 
	C158.635254,137.115494 163.597092,132.517395 170.863113,130.468994 
	C180.434479,127.770683 190.596283,132.179916 194.659897,140.525787 
	C199.119812,149.685577 196.168106,160.202057 186.922455,167.100906 
z"/>
</svg>""",
        name: {"de": "VOI", "en": "VOI"},
        colors: {"background": "#F26961"},
      ),
      "dott": OperatorConfig(
        icon: "brand_dott",
        iconCode: """
<svg width="335" height="355" viewBox="0 0 335 355" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect
       style="fill:#009DDB;"
       id="rect"
       width="370"
       height="370"
       x="0"
       y="0" />
<g transform="scale(0.9) translate(20 120)">
<path d="M248.075 87.4225C237.39 85.9385 237.983 74.3361 237.983 65.5669V46.5444H256.452C257.903 46.5444 259.09 45.3302 259.09 43.8462V23.6095C259.09 22.1254 257.903 20.9112 256.452 20.9112H237.983V2.69823C237.983 1.2142 236.796 0 235.345 0H213.249C211.798 0 210.611 1.2142 210.611 2.69823C210.611 16.8639 210.611 51.4012 210.611 62.3965C210.611 73.8639 210.149 86.4107 215.69 96.7988C221.758 108.131 234.422 113.191 246.69 113.325H264.367C265.818 113.325 267.005 112.111 267.005 110.627V90.7278C267.005 89.2438 265.818 88.0296 264.367 88.0296C259.024 88.0296 253.154 88.0971 248.075 87.4225Z" fill="#ffffff"/>
<path d="M316.005 87.4225C305.32 85.9385 305.913 74.3361 305.913 65.5669V46.5444H324.381C325.832 46.5444 327.02 45.3302 327.02 43.8462V23.6095C327.02 22.1254 325.832 20.9112 324.381 20.9112H305.913V2.69823C305.913 1.2142 304.726 0 303.275 0H281.179C279.728 0 278.541 1.2142 278.541 2.69823C278.541 16.8639 278.541 51.4012 278.541 62.3965C278.541 73.8639 278.079 86.4107 283.619 96.7988C289.688 108.131 302.351 113.191 314.62 113.325H332.296C333.747 113.325 334.935 112.111 334.935 110.627V90.7278C334.935 89.2438 333.747 88.0296 332.296 88.0296C326.954 88.0296 321.083 88.0971 316.005 87.4225Z" fill="#ffffff"/>
<path d="M150.984 20.8438C125.854 20.8438 105.473 41.6875 105.473 67.3881C105.473 93.0887 125.854 113.932 150.984 113.932C176.114 113.932 196.494 93.0887 196.494 67.3881C196.494 41.6875 176.179 20.8438 150.984 20.8438ZM150.984 89.5135C139.045 89.5135 129.349 79.5976 129.349 67.3881C129.349 55.1786 139.045 45.2627 150.984 45.2627C162.922 45.2627 172.618 55.1786 172.618 67.3881C172.618 79.5976 162.922 89.5135 150.984 89.5135Z" fill="#ffffff"/>
<path d="M63.9185 2.69822V24.9586C32.9843 10.9278 -2.23722 36.426 0.137268 70.8284C2.37984 103.409 37.4694 123.849 65.9632 109.076C81.1995 101.049 90.8953 85.0615 90.9613 67.5231V2.69822C90.9613 1.2142 89.774 0 88.3229 0H66.5568C65.0398 0 63.9185 1.2142 63.9185 2.69822ZM45.7142 89.5136C33.7758 89.5136 24.08 79.5976 24.08 67.3882C24.08 55.1787 33.7758 45.2627 45.7142 45.2627C57.6525 45.2627 67.3483 55.1787 67.3483 67.3882C67.2164 79.5976 57.5866 89.3787 45.7142 89.5136Z" fill="#ffffff"/>
</g>
</svg>
""",
        name: {"de": "dott", "en": "dott"},
        colors: {
          "background": "#009DDB",
        },
      ),
      "regiorad": OperatorConfig(
        icon: "brand_regiorad",
        iconCode: """
<svg width="208" height="41" viewBox="0 0 41 41" fill="none" xmlns="http://www.w3.org/2000/svg">
<circle cx="20.4779" cy="20.4779" r="20.4779" fill="#0066AF"/>
<mask id="mask0_754_24134" style="mask-type:luminance" maskUnits="userSpaceOnUse" x="0" y="0" width="41" height="41">
<circle cx="20.4359" cy="20.5218" r="20.4359" fill="#fff"/>
</mask>
<g mask="url(#mask0_754_24134)">
<path d="M40.8718 0.0742188H0V40.946H40.8718V0.0742188Z" fill="url(#paint0_linear_754_24134)"/>
<path d="M20.4065 2.72949C10.641 2.72949 2.72461 10.6459 2.72461 20.4113C2.72461 30.1768 10.641 38.0932 20.4065 38.0932C30.1719 38.0932 38.0883 30.1768 38.0883 20.4113C38.0883 10.6459 30.1719 2.72949 20.4065 2.72949ZM20.4065 36.5133C11.5136 36.5133 4.30448 29.3043 4.30448 20.4113C4.30448 11.5184 11.5136 4.30937 20.4065 4.30937C29.2993 4.30937 36.5084 11.5188 36.5084 20.4113C36.5084 29.3039 29.2994 36.5133 20.4065 36.5133Z" fill="white"/>
<path d="M20.4063 4.48535C11.6108 4.48535 4.48071 11.6155 4.48071 20.411C4.48071 29.2065 11.6108 36.3366 20.4063 36.3366C29.2018 36.3366 36.332 29.2065 36.332 20.411C36.332 11.6155 29.2018 4.48535 20.4063 4.48535ZM35.6272 20.411C35.6272 20.9057 35.6037 21.3966 35.5567 21.8836L27.4432 20.457L35.5661 19.0458C35.606 19.4975 35.6264 19.9526 35.6272 20.411ZM33.1612 28.721C32.6369 28.9688 27.9803 31.2304 23.8464 35.2422C22.9784 35.4425 22.0945 35.566 21.2049 35.6111C26.3242 30.72 31.6636 28.3713 33.853 27.549C33.6396 27.9505 33.409 28.3411 33.1612 28.721ZM34.4314 26.3354C34.388 26.438 34.3432 26.5398 34.2975 26.6413C32.7009 27.1818 26.2005 29.6423 20.1768 35.6291C19.5215 35.6199 18.8675 35.5687 18.2188 35.4759C21.9063 31.8499 26.2154 29.4017 29.2502 27.9645C30.9983 27.1319 32.7984 26.4135 34.6393 25.8137C34.5732 25.9884 34.5045 26.1626 34.4314 26.3354ZM34.9273 24.9869C34.2072 25.2014 31.8873 25.9371 28.9636 27.3205C25.7765 28.8287 21.2068 31.4336 17.3682 35.3297C16.7478 35.2039 16.136 35.0392 15.5364 34.8363C20.107 30.5451 25.2324 27.9657 28.7742 26.5462C31.6778 25.3828 34.0066 24.7928 35.056 24.5588C35.0155 24.702 34.9721 24.8447 34.9273 24.9869ZM35.4467 22.7636C34.8698 22.8498 33.5382 23.0699 31.7485 23.4993L26.6261 22.5858L23.9833 21.0583L27.0341 20.5283L35.5428 22.0242C35.5167 22.2719 35.4846 22.5183 35.4467 22.7636ZM5.18548 20.411C5.18548 19.9282 5.20792 19.4492 5.25279 18.9739L10.5402 19.903L10.5187 21.0105L5.26237 21.9541C5.21125 21.4442 5.18562 20.9299 5.18548 20.411ZM11.0069 17.071H10.8458C10.8439 17.069 10.9439 17.07 11.0069 17.071H11.0069ZM11.0506 17.0716H11.057C11.3366 17.0167 11.4155 16.7315 11.4376 16.5615L14.0272 18.0737L11.0609 17.5691L11.0506 17.0716ZM10.7046 15.0784C10.6603 15.0785 10.6244 15.1144 10.6243 15.1586V15.6283L10.3248 15.6338C10.3248 15.6338 10.2738 15.629 10.2355 15.6964L6.75873 13.6659C7.06589 13.0438 7.41551 12.4437 7.8051 11.8697L10.7734 13.5915L10.7433 15.0786L10.7046 15.0784ZM11.3277 15.6346L11.0424 15.6293V15.1586C11.0423 15.1144 11.0064 15.0785 10.9622 15.0784H10.9215L10.9058 13.6688L15.5502 16.363L17.5193 18.6682L14.4215 18.1413L11.4467 16.4042L11.4585 15.9157C11.4588 15.6223 11.3277 15.6346 11.3277 15.6346H11.3277ZM17.2226 14.855L18.3028 17.7961L15.6423 16.2526L9.83857 9.45812C10.3596 8.95462 10.9158 8.4888 11.5029 8.06416L17.2226 14.855ZM11.617 7.98121C12.4168 7.41444 13.2699 6.92673 14.1641 6.52495L17.0803 14.4672L11.617 7.98121ZM29.4983 8.2011C30.0553 8.61755 30.5832 9.07141 31.0785 9.55954L25.4051 16.2436L22.8327 17.7159L23.904 14.7629L29.4983 8.2011ZM24.0406 14.3847L26.8571 6.6215C27.746 7.03715 28.5923 7.53837 29.3841 8.11808L24.0406 14.3847ZM34.4314 14.4864C34.7295 15.1909 34.9737 15.9169 35.162 16.6583L26.9796 18.1194L34.1934 13.9548C34.2755 14.1303 34.3555 14.3073 34.4314 14.4866V14.4864ZM9.75463 25.4949L10.4391 25.0937L10.4332 25.3984C10.1987 25.4302 9.97254 25.4625 9.75463 25.4951V25.4949ZM11.2219 25.2984L11.2083 24.643L14.396 22.7746L17.4814 22.239L15.4673 24.5875L14.7313 25.0033C13.443 25.0682 12.2653 25.1748 11.2219 25.2988V25.2984ZM14.0499 20.5195L17.0619 21.0488L14.3468 22.6402L11.178 23.1904L11.1333 21.0432L14.0499 20.5195ZM11.1303 20.901L11.1117 20.0038L13.6467 20.4493L11.1303 20.901ZM21.6015 25.1378C21.4417 25.1186 21.2792 25.1009 21.1117 25.0846L20.6048 23.7364L20.9489 22.8004L21.6015 23.5854V25.1378ZM21.7424 23.755L23.0797 25.3638C22.6242 25.2811 22.1926 25.2119 21.7424 25.1551V23.755ZM15.0441 24.9887L15.198 24.9018L15.1264 24.9853C15.099 24.9863 15.0714 24.9873 15.0441 24.9887ZM15.558 24.6984L18.2734 23.1645L17.6134 24.9376C16.8184 24.934 16.0522 24.9486 15.3188 24.9772L15.558 24.6984ZM18.2061 24.9435C18.0576 24.9411 17.91 24.9394 17.7635 24.9386L18.4639 23.0568L19.3288 22.5684V23.5562L18.21 24.9435H18.2061ZM20.4063 21.26C20.0687 21.26 19.7642 21.0565 19.635 20.7446C19.5058 20.4326 19.5772 20.0735 19.816 19.8347C20.0548 19.596 20.4139 19.5245 20.7259 19.6538C21.0379 19.783 21.2412 20.0875 21.2412 20.4252C21.2406 20.8859 20.8671 21.2593 20.4063 21.2598V21.26ZM19.4854 21.475C19.5376 21.521 19.5931 21.563 19.6514 21.6007L19.6933 21.7121L19.4698 21.7509V21.4719L19.4854 21.475ZM19.7438 21.8464L19.8448 22.115L19.4698 22.3269V21.894L19.7438 21.8464ZM19.8847 21.8219L20.0896 21.7866C20.0966 21.7882 20.1037 21.7905 20.1107 21.792L20.2086 21.9098L19.969 22.0453L19.8847 21.8219ZM20.3165 21.8192C20.3323 21.8202 20.348 21.8212 20.3639 21.8217L20.333 21.8391L20.3165 21.8192ZM20.5561 21.8749L20.6441 21.9248L20.5264 22.0709L20.425 21.9489L20.5561 21.8749ZM20.6993 21.794L20.7051 21.7907C20.7252 21.7863 20.7448 21.7806 20.7645 21.7754L20.7337 21.8136L20.6993 21.794ZM21.7141 19.9353C21.7102 19.9248 21.7071 19.9142 21.7025 19.9036L21.8558 19.9921L21.8276 20.0697L21.7141 19.9353ZM19.0781 20.86L18.9261 20.7713L19.0281 20.6523C19.0394 20.7227 19.0561 20.7921 19.0781 20.86ZM19.0721 21.0197L18.9884 21.2444L18.5816 21.173L18.8329 20.88L19.0721 21.0197ZM19.1888 21.1104C19.2268 21.1779 19.2704 21.2422 19.319 21.3025L19.1296 21.2693L19.1888 21.1104ZM19.329 21.4474V21.7749L18.9145 21.847L19.0796 21.4029L19.329 21.4474ZM19.329 21.9183V22.4063L18.5405 22.8517L18.8576 22.0002L19.329 21.9183ZM19.47 22.4886L19.8953 22.2485L20.0503 22.6615L19.4698 23.3813L19.47 22.4886ZM20.0194 22.1785L20.3005 22.0198L20.4364 22.1832L20.1532 22.5344L20.0194 22.1785ZM20.5283 22.2938L20.8454 22.6749L20.5295 23.5343L20.2111 22.6875L20.5283 22.2938ZM20.6185 22.1819L20.769 21.9954L21.0386 22.1485L20.9012 22.522L20.6185 22.1819ZM20.8586 21.8842L20.9881 21.7237L21.182 21.7583L21.0879 22.0143L20.8586 21.8842ZM21.148 21.6093C21.1861 21.5853 21.2229 21.5597 21.2583 21.5323L21.2654 21.531L21.2312 21.6242L21.148 21.6093ZM21.5051 21.2884C21.5087 21.2838 21.5121 21.2791 21.5155 21.2743L21.6017 21.2245V21.3294L21.4823 21.3501L21.5051 21.2884ZM21.7427 20.8393C21.7636 20.7699 21.779 20.699 21.789 20.6272L21.8841 20.8988L21.7427 20.9805V20.8393ZM21.8164 20.2793L21.7981 20.2857C21.7969 20.2724 21.7941 20.2596 21.7925 20.2465L21.8997 20.3738L21.8644 20.4156L21.8164 20.2793ZM21.9332 20.1948L21.9806 20.0641L22.1026 20.1346L21.9921 20.2647L21.9332 20.1948ZM22.0294 19.9296L22.1251 19.6656L22.4519 19.7231L22.1953 20.0254L22.0294 19.9296ZM21.9054 19.8579L21.7216 19.7517V19.5947L21.9839 19.6409L21.9054 19.8579ZM21.5807 19.6681C21.5579 19.6329 21.5334 19.5989 21.5077 19.5659L21.5093 19.5653L21.5062 19.5568L21.5808 19.5699L21.5807 19.6681ZM21.4503 19.4039L21.3975 19.2597L21.5812 19.227V19.4268L21.4503 19.4039ZM21.2727 19.3294C21.261 19.3201 21.2488 19.3113 21.2368 19.3025V19.3006L21.2331 19.2999C21.2292 19.297 21.2253 19.2939 21.2212 19.291L21.2564 19.2848L21.2727 19.3294ZM20.749 19.0709L20.7656 19.0614L20.7804 19.079C20.77 19.0757 20.7595 19.0732 20.749 19.0706V19.0709ZM19.6554 19.2471C19.5963 19.2849 19.5401 19.3271 19.4873 19.3734L19.4866 19.1456L19.6807 19.1786L19.6554 19.2471ZM19.1748 19.763L19.1185 19.6099L19.2958 19.578C19.2506 19.6364 19.2102 19.6982 19.1748 19.7629V19.763ZM19.0657 19.8747L18.8455 20.0035L18.5902 19.7046L18.9779 19.6351L19.0657 19.8747ZM19.063 20.0397C19.0468 20.0969 19.0342 20.1551 19.0254 20.2139L18.9388 20.1124L19.063 20.0397ZM19.0084 20.4111C19.0084 20.4158 19.0077 20.4204 19.0077 20.4252C19.0077 20.4361 19.0091 20.4467 19.0094 20.4576L18.8022 20.6992L18.3693 20.4464L18.8153 20.185L19.0084 20.4111ZM18.7089 20.8078L18.42 21.1447L17.4642 20.9766L18.2297 20.528L18.7089 20.8078ZM18.3134 21.269L17.6255 22.0711L14.743 22.5715L17.2765 21.0866L18.3134 21.269ZM18.4747 21.2972L18.9382 21.3787L18.7534 21.8751L17.8437 22.033L18.4747 21.2972ZM18.6964 22.028L18.3498 22.9593L15.8273 24.3841L17.6995 22.2012L18.6964 22.028ZM19.3288 23.7806V24.9716C19.0369 24.961 18.7241 24.9529 18.3885 24.9466L19.3288 23.7806ZM19.4698 23.6058L20.1079 22.8145L20.4545 23.7364L19.9893 25.0012C19.823 24.9922 19.6497 24.9841 19.4696 24.977L19.4698 23.6058ZM20.5304 23.9383L20.9557 25.0697C20.6973 25.0465 20.4261 25.0265 20.1366 25.0095L20.5304 23.9383ZM21.0051 22.6471L21.1626 22.2187L21.6015 22.4679V23.3646L21.0051 22.6471ZM21.212 22.0846L21.3228 21.7831L21.6015 21.8329V22.3058L21.212 22.0846ZM21.3722 21.6488L21.4259 21.5026L21.6015 21.4721V21.6896L21.3722 21.6488ZM21.7424 21.4476L22.0572 21.3929L22.1982 21.7961L21.7422 21.7148L21.7424 21.4476ZM21.7424 21.3045V21.1424L21.9313 21.0334L22.0099 21.2577L21.7424 21.3045ZM22.0555 20.962L22.2841 20.83L22.5635 21.1618L22.1509 21.2337L22.0555 20.962ZM22.0081 20.8266L21.9179 20.5693L21.9915 20.4826L22.1919 20.7205L22.0081 20.8266ZM22.084 20.3736L22.2265 20.2058L22.6547 20.4533L22.3158 20.6489L22.084 20.3736ZM22.3192 20.0967L22.6126 19.7509L23.5775 19.9205L22.7956 20.3719L22.3192 20.0967ZM22.7183 19.6264L23.3216 18.9157L26.2122 18.3995L23.7675 19.8108L22.7183 19.6264ZM22.5574 19.5982L22.1737 19.5307L22.3328 19.0923L23.1036 18.9547L22.5574 19.5982ZM22.0327 19.5059L21.7217 19.4512V19.2014L22.1722 19.121L22.0327 19.5059ZM21.7221 19.0582L21.7226 18.5134L22.5684 18.0294L22.228 18.9678L21.7221 19.0582ZM21.5811 19.0833L21.3486 19.1249L21.2284 18.7964L21.582 18.5941L21.5811 19.0833ZM21.2076 19.1501L21.049 19.1783L20.8902 18.9898L21.1042 18.8673L21.2076 19.1501ZM20.7979 18.8803L20.5967 18.6414L20.894 18.2927L21.0551 18.7331L20.7979 18.8803ZM20.6736 18.9515L20.5317 19.0327C20.4967 19.0296 20.4613 19.0278 20.4254 19.0273L20.3197 18.9661L20.5038 18.7501L20.6736 18.9515ZM20.1959 18.8942L19.9822 18.7701L20.1464 18.3256L20.4119 18.6408L20.1959 18.8942ZM20.1029 19.0032L20.0403 19.0767C20.0249 19.081 20.0089 19.0838 19.9937 19.0887L19.8721 19.0681L19.9326 18.9044L20.1029 19.0032ZM19.7308 19.0439L19.4866 19.0024L19.4856 18.6451L19.8088 18.8326L19.7308 19.0439ZM19.3455 18.9785L18.8566 18.8953L18.5697 18.1139L19.3444 18.5632L19.3455 18.9785ZM19.346 19.1215L19.3469 19.4257L19.0697 19.4755L18.9127 19.0478L19.346 19.1215ZM18.9288 19.5007L18.4848 19.5804L17.8798 18.8721L18.7526 19.0206L18.9288 19.5007ZM18.324 19.6093L17.2628 19.7996L14.7679 18.3425L17.6631 18.835L18.324 19.6093ZM18.4298 19.7335L18.7222 20.0759L18.2296 20.3649L17.4501 19.9096L18.4298 19.7335ZM18.0901 20.4464L17.2497 20.9389L14.4527 20.4474L17.2365 19.9477L18.0901 20.4464ZM13.9998 22.8436L11.2049 24.4817L11.181 23.333L13.9998 22.8436ZM23.296 25.4034L21.7424 23.5342V22.5476L22.6404 23.0572L23.474 25.4368C23.4141 25.4256 23.3548 25.4145 23.296 25.4034ZM21.7424 22.3858V21.858L22.2519 21.9489L22.5695 22.8553L21.7424 22.3858ZM22.4112 21.9771L23.3984 22.1532L25.29 24.3994L22.7558 22.961L22.4112 21.9771ZM22.3576 21.8243L22.1979 21.3683L22.6687 21.2865L23.2566 21.9847L22.3576 21.8243ZM22.8293 21.2586L23.7667 21.0957L26.2188 22.5129L23.4735 22.0234L22.8293 21.2586ZM22.7243 21.1338L22.4081 20.7583L22.7957 20.5346L23.5764 20.9857L22.7243 21.1338ZM22.9365 20.4533L23.7937 19.9584L26.6246 20.4561L23.793 20.9483L22.9365 20.4533ZM23.9837 19.8487L26.6204 18.3264L35.1951 16.7952C35.3644 17.489 35.4843 18.1939 35.5539 18.9046L27.034 20.3846L23.9837 19.8487ZM26.5712 18.192L23.4648 18.7467L25.4962 16.3537L33.0975 12.0037C33.4845 12.5865 33.8307 13.1955 34.1335 13.8262L26.5712 18.192ZM23.2469 18.7857L22.3883 18.939L22.7577 17.9209L25.1366 16.5596L23.2469 18.7857ZM22.6428 17.8241L21.7229 18.3506L21.7238 17.3188L23.6424 15.0688L22.6428 17.8241ZM21.5818 18.4314L21.1788 18.6619L20.9987 18.1693L21.5827 17.4843L21.5818 18.4314ZM20.9431 18.0173L20.6031 17.0882L21.5858 14.4277L21.583 17.2671L20.9431 18.0173ZM20.838 18.1405L20.5043 18.5319L20.2022 18.1736L20.5277 17.2926L20.838 18.1405ZM20.098 18.0492L19.4817 17.3176L19.4727 14.4094L20.4529 17.0882L20.098 18.0492ZM20.0416 18.2013L19.8584 18.6982L19.4849 18.4816L19.4822 17.5372L20.0416 18.2013ZM19.3439 18.3997L18.4937 17.9064L17.4888 15.1713L19.3406 17.3697L19.3439 18.3997ZM18.3789 18.003L18.6965 18.8678L17.7368 18.7046L15.9185 16.5756L18.3789 18.003ZM14.3732 18.2754L17.0483 19.8382L14.0493 20.3766L11.1084 19.8598L11.0637 17.7127L14.3732 18.2754ZM10.5433 19.7604L5.26625 18.8332C5.33692 18.1437 5.45503 17.4599 5.61976 16.7866L10.5845 17.6309L10.5433 19.7604ZM10.5162 21.1542L10.4739 23.3129L5.6476 24.1509C5.477 23.4748 5.35353 22.7877 5.27809 22.0945L10.5162 21.1542ZM10.4713 23.4564L10.4426 24.9286L9.37702 25.5532C7.8013 25.802 6.72977 26.055 6.31043 26.1611C6.06099 25.551 5.85169 24.9252 5.68389 24.2877L10.4713 23.4564ZM24.7746 25.6968C24.3614 25.6122 23.9865 25.5365 23.6344 25.468L22.8267 23.1633L25.5514 24.7099L25.9916 25.2327C25.5957 25.3777 25.19 25.5324 24.7744 25.6968H24.7746ZM26.1327 25.1813L25.9046 24.9104L26.2852 25.1265C26.2341 25.1448 26.1838 25.1627 26.1328 25.1813H26.1327ZM26.4602 25.0637L25.6432 24.5999L23.6155 22.192L26.5772 22.7202L29.1336 24.1976C28.5596 24.3667 27.9622 24.5528 27.3469 24.7582C27.059 24.8543 26.7634 24.9561 26.46 25.0637H26.4602ZM29.3203 24.1429L26.9842 22.7929L31.409 23.5822C30.7625 23.7412 30.0619 23.9275 29.3203 24.1429ZM33.0192 11.8863L25.7643 16.0381L31.1794 9.65884C31.8616 10.3415 32.4777 11.0873 33.0192 11.8862V11.8863ZM26.7287 6.56174L23.7796 14.691L21.7241 17.1013L21.7272 14.0447L24.764 5.82335C25.2962 5.98208 25.8192 6.1699 26.3308 6.38597C26.4646 6.44256 26.597 6.50148 26.7287 6.56167V6.56174ZM21.728 13.6368L21.7362 5.24812C22.7154 5.33185 23.6841 5.5111 24.6285 5.78332L21.728 13.6368ZM21.5956 5.236L21.5866 14.0196L20.5283 16.8838L19.4718 13.9958L19.4465 5.22092C19.7649 5.20125 20.0848 5.19026 20.4063 5.19026C20.8051 5.19026 21.2014 5.20539 21.5952 5.23593L21.5956 5.236ZM19.3297 13.6073L16.4415 5.71186C17.3785 5.45947 18.3376 5.29794 19.3056 5.22952L19.3297 13.6073ZM16.3047 5.74851L19.3309 14.0209L19.34 17.1497L17.3464 14.7831L14.2934 6.46836C14.3562 6.4408 14.4187 6.41275 14.4819 6.38597C15.0753 6.1349 15.6842 5.92198 16.3047 5.74851ZM9.64356 9.6482C9.67443 9.61733 9.706 9.58745 9.73715 9.55658L15.2745 16.0393L10.904 13.5041L10.8829 11.5991H10.8138L10.7765 13.4301L7.88538 11.7531C8.40721 11.0002 8.99564 10.2958 9.64356 9.6482ZM6.69573 13.7922L10.198 15.8375C10.1957 15.8607 10.1941 15.8857 10.1941 15.9146L10.2066 16.4325C10.2066 16.4325 10.1925 16.9917 10.5958 17.071L10.5877 17.4887L5.65324 16.6493C5.84123 15.9111 6.08474 15.1881 6.38168 14.4866C6.48068 14.252 6.58536 14.0206 6.69573 13.7924V13.7922ZM13.0792 33.756C17.5929 29.375 23.4096 26.8173 27.5542 25.4323C30.0854 24.5817 32.6805 23.9347 35.3147 23.4973C35.2942 23.5968 35.2731 23.6962 35.2507 23.7953C34.4202 23.9649 31.8791 24.5451 28.5306 25.8851C24.8608 27.3539 19.5196 30.0486 14.7994 34.566C14.6932 34.5237 14.5874 34.481 14.4822 34.4364C14.0032 34.2336 13.5349 34.0066 13.0792 33.756ZM31.1691 31.1741C29.7827 32.5644 28.1395 33.6723 26.3308 34.4364C26.0056 34.5739 25.677 34.6994 25.3449 34.8128C27.996 32.4568 30.7031 30.8256 32.2364 29.9895C31.9013 30.4024 31.5451 30.7977 31.1691 31.1738V31.1741Z" fill="white"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M2.72485 20.4456C2.72485 10.662 10.641 2.73047 20.4064 2.73047C30.1717 2.73047 38.0885 10.662 38.0885 20.4456C38.0885 30.2292 30.1724 38.1608 20.4064 38.1608C10.6404 38.1608 2.72485 30.2292 2.72485 20.4456ZM4.30479 20.4456C4.30479 29.3525 11.5142 36.5779 20.407 36.5779C29.2999 36.5779 36.5092 29.355 36.5092 20.4456C36.5092 11.5362 29.2999 4.31335 20.407 4.31335C11.5142 4.31335 4.30479 11.5362 4.30479 20.4456Z" fill="white"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M20.44 19.6348C19.9925 19.6348 19.6297 19.9976 19.6297 20.4451C19.6297 20.8927 19.9925 21.2554 20.44 21.2554C20.8875 21.2554 21.2503 20.8927 21.2503 20.4451C21.2503 19.9976 20.8875 19.6348 20.44 19.6348ZM18.53 20.4451C18.53 19.3903 19.3852 18.5352 20.44 18.5352C21.4949 18.5352 22.35 19.3903 22.35 20.4451C22.35 21.5 21.4949 22.3551 20.44 22.3551C19.3852 22.3551 18.53 21.5 18.53 20.4451Z" fill="white"/>
</g>


<defs>
<linearGradient id="paint0_linear_754_24134" x1="20.4359" y1="0.0742188" x2="20.4359" y2="40.946" gradientUnits="userSpaceOnUse">
<stop stop-color="#0066AF"/>
<stop offset="1" stop-color="#0066AF"/>
</linearGradient>
</defs>
</svg>
""",
        name: {"de": "RegioRad", "en": "RegioRad"},
        colors: {"background": "#009fe4"},
      ),
      "stadtmobil": OperatorConfig(
        icon: "brand_stadtmobil",
        iconCode: """
<svg
   version="1.1"
   width="1020.0001"
   height="1020.0001"
   viewBox="0 0 17 17"
   id="svg77651"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg">
  <g transform="translate(-94.6 -61.2)">
  <path
     d="m 109.85616,69.742232 -7.3725,4.25625 v -8.5125 z m -14.897502,0.006 c 0,-4.53625 3.6775,-8.2125 8.212502,-8.2125 4.53625,0 8.21375,3.67625 8.21375,8.2125 0,4.535 -3.6775,8.2125 -8.21375,8.2125 -4.535002,0 -8.212502,-3.6775 -8.212502,-8.2125"
     id="path74464"
     style="fill:#f18647;fill-opacity:1;fill-rule:evenodd;stroke:none" />
  <path
     d="m 109.85616,69.742232 -7.3725,4.25625 v -8.5125 l 7.3725,4.25625"
     id="path74484"
     style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none" />
   </g>
</svg>""",
        name: {"de": "stadtmobil", "en": "stadtmobil"},
        colors: {"background": "#FF8A36"},
      ),
      "zeus": OperatorConfig(
        icon: "brand_zeus",
        iconCode: """
<svg
   width="635"
   height="635"
   xml:space="preserve"
   version="1.1"
   viewBox="0 0 635 635"
   id="svg638"
   sodipodi:docname="zeus.svg"
   inkscape:version="1.2.1 (9c6d41e410, 2022-07-14)"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg"><defs
   id="defs642" /><sodipodi:namedview
   id="namedview640"
   pagecolor="#ffffff"
   bordercolor="#000000"
   borderopacity="0.25"
   inkscape:showpageshadow="2"
   inkscape:pageopacity="0.0"
   inkscape:pagecheckerboard="0"
   inkscape:deskcolor="#d1d1d1"
   showgrid="false"
   inkscape:zoom="1.4124386"
   inkscape:cx="304.43801"
   inkscape:cy="92.039397"
   inkscape:window-width="1920"
   inkscape:window-height="1017"
   inkscape:window-x="-8"
   inkscape:window-y="-8"
   inkscape:window-maximized="1"
   inkscape:current-layer="svg638" />
  <rect
   style="fill:none;fill-rule:evenodd;stroke-width:1.53942"
   id="rect761"
   width="635"
   height="635"
   x="0"
   y="0" /><image
   width="632"
   height="611"
   xlink:href="data:image/png;base64,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"
   id="image636"
   x="1.4159907"
   y="13.451912" />
</svg>
""",
        name: {"de": "ZEUS Scooters", "en": "ZEUS Scooters"},
        colors: {"background": "#F75118"},
      ),
      "other": OperatorConfig(
        icon: "brand_other",
        iconCode: """
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100"></svg>""",
        name: {"de": "Weitere Anbieter", "en": "Other Operators"},
        colors: {"background": "#C84674"},
      ),
    },
  ),
  transportModes: {
    "nearYouTitle": TransportModeConfig(
      nearYouLabel: {"de": "Fahrpläne und Routen"},
    ),
    "bus": TransportModeConfig(
      availableForSelection: true,
      defaultValue: true,
      smallIconZoom: 16,
      nearYouLabel: {"de": "Bushaltestellen in der Nähe"},
    ),
    "rail": TransportModeConfig(
      availableForSelection: true,
      defaultValue: true,
      nearYouLabel: {"de": "Bahnhaltestellen in der Nähe"},
    ),
    "tram": TransportModeConfig(
      availableForSelection: false,
      defaultValue: false,
      nearYouLabel: {"de": "Tramhaltestellen in der Nähe"},
    ),
    "subway": TransportModeConfig(
      availableForSelection: true,
      defaultValue: true,
      nearYouLabel: {"de": "U-Bahnhaltestellen in der Nähe"},
    ),
    "airplane": TransportModeConfig(
      availableForSelection: false,
      defaultValue: false,
      nearYouLabel: {"de": "Flughäfen in der Nähe"},
    ),
    "ferry": TransportModeConfig(
      availableForSelection: false,
      defaultValue: false,
      nearYouLabel: {"de": "Fähranleger in der Nähe"},
    ),
    "carpool": TransportModeConfig(
      availableForSelection: true,
      defaultValue: true,
      nearYouLabel: {
        "de": "Mitfahrpunkte in der Nähe",
        "en": "Nearby carpool stops on the map",
      },
    ),
    "funicular": TransportModeConfig(
      availableForSelection: true,
      defaultValue: true,
    ),
    "citybike": TransportModeConfig(
      availableForSelection: true,
      defaultValue: false,
      nearYouLabel: {
        "de": "Sharing-Angebote in der Nähe",
        "en": "Shared mobility near you",
      },
    ),
  },
  modeToOTP: {
    'carpool': 'CARPOOL',
  },
);
