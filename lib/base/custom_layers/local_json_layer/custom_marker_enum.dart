import 'package:flutter/material.dart';

enum LayerIds {
  bicycleInfrastructure,
  bicycleParking,
  // charging,
  lorawanGateways,
  publicToilets
}

extension LayerIdsToString on LayerIds {
  static Map<LayerIds, String> enumStrings = {
    LayerIds.bicycleInfrastructure: "Bicycle Infrastructure",
    LayerIds.bicycleParking: "Bicycle Parking",
    LayerIds.lorawanGateways: "Lorawan Gateways",
    LayerIds.publicToilets: "Public Toilets"
  };

  Color enumToColor() {
    final Map<LayerIds, Color> enumStrings = {
      LayerIds.bicycleInfrastructure: Colors.black,
      LayerIds.bicycleParking: Colors.blue[600]!,
      LayerIds.lorawanGateways: Colors.black,
      LayerIds.publicToilets: Colors.black,
    };

    return enumStrings[this] ?? Colors.black;
  }

  String get enumString => enumStrings[this] ?? '';

  String enumToStringEN() {
    final Map<LayerIds, String> enumStrings = {
      LayerIds.bicycleInfrastructure: "Service stations and stores",
      LayerIds.bicycleParking: "Bike parking spaces",
      LayerIds.lorawanGateways: "LoRaWAN Gateways",
      LayerIds.publicToilets: "Public Toilets"
    };

    return enumStrings[this] ?? "Service stations and stores";
  }

  String enumToStringDE() {
    final Map<LayerIds, String> enumStrings = {
      LayerIds.bicycleInfrastructure: "Service Stationen und Läden",
      LayerIds.bicycleParking: "Fahrradparkplätze",
      LayerIds.lorawanGateways: "LoRaWAN Gateways",
      LayerIds.publicToilets: "Nette Toilette"
    };

    return enumStrings[this] ?? "Service Stationen und Läden";
  }
}

Map<LayerIds, String> layerFileNames = {
  LayerIds.bicycleInfrastructure: "bicycleinfrastructure.geojson",
  LayerIds.bicycleParking: "bicycle-parking.geojson",
  LayerIds.lorawanGateways: "lorawan-gateways.geojson",
  LayerIds.publicToilets: "toilet.geojson",
};

Map<LayerIds, String> layerIcons = {
  LayerIds.bicycleInfrastructure: """
  <svg xmlns="http://www.w3.org/2000/svg" id="Ebene_1" data-name="Ebene 1" viewBox="0 0 32.53 32.54">    <path fill="#000001" d="M313.29 384.05A16.27 16.27 0 11297 367.78a16.27 16.27 0 0116.26 16.27" transform="translate(-280.76 -367.78)" />    <path d="M299.66 384.6a1.43 1.43 0 01-1.05-.44 1.35 1.35 0 01-.46-1 1.56 1.56 0 011.51-1.51 1.42 1.42 0 011 .45 1.51 1.51 0 01.44 1.06 1.5 1.5 0 01-1.48 1.47zm-7.87 4.89a3.55 3.55 0 012.65 1.09 3.62 3.62 0 011.07 2.67 3.66 3.66 0 01-3.72 3.72 3.65 3.65 0 01-2.67-1.07 3.55 3.55 0 01-1.09-2.65 3.72 3.72 0 013.76-3.76zm0 6.36a2.59 2.59 0 002.6-2.6 2.53 2.53 0 00-.76-1.86 2.45 2.45 0 00-1.84-.78 2.66 2.66 0 00-2.64 2.64 2.46 2.46 0 00.78 1.84 2.53 2.53 0 001.86.76zm4.32-7.49l1.65 1.73v4.63h-1.47V391l-2.43-2.11a1.18 1.18 0 01-.42-1.05 1.45 1.45 0 01.42-1.06l2.11-2.11a1.19 1.19 0 011.06-.42 1.86 1.86 0 011.19.42l1.44 1.45a3.68 3.68 0 002.67 1.12v1.51a5.18 5.18 0 01-3.79-1.58l-.6-.6zm6.15 1.13a3.72 3.72 0 013.76 3.76 3.55 3.55 0 01-1.09 2.65 3.62 3.62 0 01-2.67 1.07 3.66 3.66 0 01-3.72-3.72 3.62 3.62 0 011.07-2.67 3.55 3.55 0 012.65-1.09zm0 6.36a2.53 2.53 0 001.86-.76 2.46 2.46 0 00.78-1.84 2.66 2.66 0 00-2.64-2.64 2.46 2.46 0 00-1.84.78 2.53 2.53 0 00-.76 1.86 2.59 2.59 0 002.6 2.6zM304 374.92a.38.38 0 01.38.14.65.65 0 01.15.48v1.86a.51.51 0 01-.57.58h-7.4a3.46 3.46 0 01-1.34 1.58 3.67 3.67 0 01-2.07.61 3.79 3.79 0 01-2.22-.69 3.33 3.33 0 01-1.33-1.79h3.55v-2.44h-3.55a3.8 3.8 0 013.54-2.48 3.76 3.76 0 012.08.61 3.46 3.46 0 011.34 1.58z" fill="#fff" transform="translate(-280.76 -367.78)" /></svg>
  """,
  LayerIds.bicycleParking: """
  <svg xmlns="http://www.w3.org/2000/svg" id="Ebene_1" data-name="Ebene 1" viewBox="0 0 32.53 32.53">    <path fill="#005ab4" d="M320.34 384.05a16.27 16.27 0 11-16.26-16.27 16.27 16.27 0 0116.26 16.27" transform="translate(-287.81 -367.78)" />    <path d="M298.37 373v.32a.6.6 0 00.83.56l4.65-1.9a.61.61 0 01.46 0l4.64 1.9a.61.61 0 00.84-.56V373a.6.6 0 00-.38-.56l-5.1-2.09a.61.61 0 00-.46 0l-5.11 2.09a.6.6 0 00-.37.56" fill="#fff" transform="translate(-287.81 -367.78)" />    <path d="M307.13 376.2a2.34 2.34 0 00-2.51-2.37h-2.95v7.6h1.49v-2.86h1.46a2.34 2.34 0 002.51-2.37m-1.49 0a1 1 0 01-1.1 1h-1.38v-2.09h1.38a1 1 0 011.1 1.05M306.71 384.17a1.47 1.47 0 01-1-.44 1.38 1.38 0 01-.46-1 1.43 1.43 0 01.46-1.05 1.41 1.41 0 011-.46 1.38 1.38 0 011 .46 1.49 1.49 0 01.44 1.05 1.5 1.5 0 01-1.48 1.48zm-7.87 4.88a3.57 3.57 0 012.65 1.09 3.66 3.66 0 011.08 2.67 3.67 3.67 0 01-3.73 3.73 3.69 3.69 0 01-2.67-1.07 3.57 3.57 0 01-1.09-2.66 3.63 3.63 0 011.09-2.67 3.67 3.67 0 012.67-1.09zm0 6.36a2.56 2.56 0 002.6-2.6 2.59 2.59 0 00-.75-1.86 2.51 2.51 0 00-1.85-.77 2.63 2.63 0 00-2.63 2.63 2.48 2.48 0 00.77 1.85 2.57 2.57 0 001.86.75zm4.32-7.48l1.65 1.72v4.64h-1.47v-3.73l-2.43-2.1a1.19 1.19 0 01-.42-1.06 1.42 1.42 0 01.42-1l2.11-2.11a1.19 1.19 0 011.06-.42 1.86 1.86 0 011.19.42l1.44 1.44a3.64 3.64 0 002.67 1.12v1.52a5.15 5.15 0 01-3.79-1.59l-.6-.59zm6.15 1.12a3.72 3.72 0 013.76 3.76 3.57 3.57 0 01-1.09 2.66 3.66 3.66 0 01-2.67 1.07 3.66 3.66 0 01-3.72-3.73 3.69 3.69 0 011.07-2.67 3.59 3.59 0 012.65-1.09zm0 6.36a2.56 2.56 0 001.86-.75 2.49 2.49 0 00.78-1.85 2.65 2.65 0 00-2.64-2.63 2.49 2.49 0 00-1.84.77 2.56 2.56 0 00-.76 1.86 2.58 2.58 0 002.6 2.6z" fill="#fff" transform="translate(-287.81 -367.78)" /></svg>
  """,
  LayerIds.lorawanGateways: """
  <svg xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cc="http://creativecommons.org/ns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd" xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape" version="1.1" id="Layer_1" x="0px" y="0px" viewBox="172.3 -67.1 630 400" enable-background="new 172.3 -67.1 935 935" xml:space="preserve" width="630" height="400" inkscape:version="0.92.1 r15371">    <g id="g4" transform="matrix(1,0,0,1.1522729,-146.58897,-222.89451)">        <path d="m 891,381.9 c 1.4,17.2 -4,33.4 -15,45.8 -11.8,13.2 -29.4,20.4 -49.2,20.4 H 398.2 v 0 c -0.2,0 -0.4,0 -0.6,0 h -0.2 -0.4 v 0 c -17.4,-0.2 -33.8,-7 -46,-19.2 -13,-12.8 -20,-30 -20.2,-48.2 v 0 c 0,-33.8 23,-61.2 54.4,-66.4 4.2,-28.2 28.8,-51.2 59.2,-56 1.8,-11.2 7.2,-22 15.8,-30.8 12.4,-12.8 29.2,-20 46.4,-20 22.2,0 41.6,12 52,30 12.2,-43.6 52.2,-75.6 99.6,-75.6 51.8,0 95,38.4 102.2,88.4 26,-19.4 60.6,-17.6 86.6,6.8 l -2.8,-2.4 c 20.8,16.8 28,39.6 27,58.8 -0.6,11.4 -4.4,21.4 -11.2,29.6 6.6,2.2 12,6 17.2,11.2 7.2,7.2 12.2,16.2 13.6,26.2 v 0 c 0,0.4 0,0.8 0.2,1.4 0,-0.6 0,-0.4 0,0 z m 32.2,-161.4 c -15.2,-20.6 -37.8,-35.8 -62.6,-42.2 -5.6,-1.2 -11.4,2.6 -12.6,8 -2.2,5.6 1.4,12.8 7.4,14 25,6.6 46.6,24.2 58,47.4 9.4,19 11.8,41.4 6.6,62 -1.4,5.8 2.8,12 8.8,12.8 5.4,1.6 11.4,-1.6 13.2,-6.8 8.2,-32.2 1.2,-68.4 -18.8,-95.2 z m -71.4,-3.2 c -8.6,-1.6 -15.2,9 -11.4,16.4 1.4,3.2 4.6,5.4 8,6.2 13,3.4 24.4,12.4 30.4,24.4 5.4,10.6 6.6,23 3.6,34.4 -1.6,5.8 2.6,12.2 8.6,13.2 5.4,1.6 11.8,-1.6 13.4,-7.2 5.6,-20.4 1.4,-43.2 -11,-60.2 -10,-13.6 -25,-24 -41.6,-27.2 z" id="path2" inkscape:connector-curvature="0" fill="#0d83d0" />    </g></svg>
  """,
  LayerIds.publicToilets: """
  <svg xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cc="http://creativecommons.org/ns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd" xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape" id="icon-icon_public_toilets" viewBox="0 0 32.529999 32.529999" xml:space="preserve" version="1.1" sodipodi:docname="nette_toilette.svg" inkscape:version="0.92.4 (5da689c313, 2019-01-14)">   <sodipodi:namedview pagecolor="#ffffff" bordercolor="#666666" borderopacity="1" objecttolerance="10" gridtolerance="10" guidetolerance="10" inkscape:pageopacity="0" inkscape:pageshadow="2" inkscape:window-width="2560" inkscape:window-height="1017" showgrid="false" inkscape:zoom="10.190974" inkscape:cx="38.540369" inkscape:cy="8.21068" inkscape:window-x="1912" inkscape:window-y="-8" inkscape:window-maximized="1" inkscape:current-layer="g12"/>   <metadata id="metadata8">    <rdf:RDF>     <cc:Work rdf:about="">      <dc:format>image/svg+xml</dc:format>      <dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/>      <dc:title/>      </cc:Work>     </rdf:RDF>    </metadata>   <defs id="defs6"/>   <g transform="matrix(1.3333333,0,0,-1.3333333,0,32.53)" id="g10">    <g transform="scale(0.1)" id="g12">     <path id="path14" style="fill:#231f20;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.06010462" d="M 0.31567062,243.75264 H 243.70347 V 0.16463956 H 0.31567062 V 243.75264" inkscape:connector-curvature="0"/>     <path id="path16" style="fill:#ed1c24;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.06010462" d="M 7.6001666,235.65318 H 236.15112 V 9.0728526 H 7.6001666 V 235.65318" inkscape:connector-curvature="0"/>     <path id="path44" style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.11358375" d="m 63.732549,159.32192 c 0,15.13259 9.254358,27.40019 20.670392,27.40019 11.416151,0 20.670409,-12.2676 20.670409,-27.40019 0,-15.13275 -9.254258,-27.40018 -20.670409,-27.40018 -11.416034,0 -20.670392,12.26743 -20.670392,27.40018" inkscape:connector-curvature="0"/>     <path id="path46" style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.11358375" d="m 136.61794,159.32192 c 0,15.13259 9.2549,27.40019 20.67153,27.40019 11.41547,0 20.66926,-12.2676 20.66926,-27.40019 0,-15.13275 -9.25379,-27.40018 -20.66926,-27.40018 -11.41663,0 -20.67153,12.26743 -20.67153,27.40018" inkscape:connector-curvature="0"/>     <path id="path48" style="fill:#231f20;fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:0.11687034" d="m 85.198481,199.59918 c -19.865107,0 -33.531815,-15.20838 -33.531815,-38.08852 0,-22.88121 12.821768,-37.80205 33.392292,-37.80205 19.867442,0 33.534142,15.20604 33.534142,38.08618 0,22.88246 -12.82177,37.80439 -33.394619,37.80439 z M 97.881182,161.3699 c 0,-14.35626 -3.242438,-23.73576 -12.822224,-23.73576 -7.185189,0 -12.67992,4.26417 -12.67992,24.30388 0,14.3538 3.239656,23.73224 12.819443,23.73224 7.187517,0 12.682701,-4.2631 12.682701,-24.30036" inkscape:connector-curvature="0"/>     <path id="path50" style="fill:#231f20;fill-opacity:1;fill-rule:evenodd;stroke:none;stroke-width:0.11687034" d="m 160.74469,199.59918 c -19.86499,0 -33.53228,-15.20838 -33.53228,-38.08852 0,-22.88121 12.8213,-37.80205 33.39149,-37.80205 19.8673,0 33.53458,15.20604 33.53458,38.08618 0,22.88246 -12.82129,37.80439 -33.39379,37.80439 z m 12.68165,-38.22928 c 0,-14.35626 -3.24197,-23.73576 -12.82244,-23.73576 -7.18449,0 -12.67936,4.26417 -12.67936,24.30388 0,14.3538 3.23967,23.73224 12.82015,23.73224 7.18682,0 12.68165,-4.2631 12.68165,-24.30036" inkscape:connector-curvature="0"/>     <path id="path52" style="fill:#231f20;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.11334047" d="m 44.728314,111.42701 c 0,0 56.217806,-57.306087 95.104146,-46.373504 25.30032,7.111411 54.88833,46.373504 54.88833,46.373504 0,0 -22.2048,-61.048091 -51.13447,-72.818869 -42.6501,-17.351648 -98.858006,72.818869 -98.858006,72.818869" inkscape:connector-curvature="0"/>     </g>    </g>   </svg>
  """,
};
