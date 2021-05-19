import 'parkings_enum.dart';

const String _parking = """
<svg xmlns="http://www.w3.org/2000/svg" width="22.857142857142854" height="22.857142857142854" viewBox="0 0 32.529998779296875 32.529998779296875">
  <path fill="#005ab4" d="M32.53 16.27A16.27 16.27 0 1116.27 0a16.26 16.26 0 0116.26 16.27" />
  <path fill="#fff" d="M22.51 13.75a4.49 4.49 0 00-4.8-4.54h-5.64v14.55h2.84v-5.47h2.8a4.49 4.49 0 004.8-4.54m-2.84 0a1.92 1.92 0 01-2.11 2h-2.65v-4h2.65a1.94 1.94 0 012.11 2" />
</svg>
""";
const String _parkingGarage = """
<svg xmlns="http://www.w3.org/2000/svg" width="22.857142857142854" height="22.857142857142854" viewBox="0 0 32.529998779296875 32.529998779296875">
  <path fill="#fff" d="M293.22 379.21v.63a1.16 1.16 0 001.6 1.07l8.89-3.64a1.12 1.12 0 01.88 0l8.89 3.64a1.16 1.16 0 001.6-1.07v-.63a1.16 1.16 0 00-.72-1.08l-9.77-4a1.21 1.21 0 00-.88 0l-9.77 4a1.16 1.16 0 00-.72 1.08" transform="translate(-287.81 -367.78)" />
  <path fill="#fff" d="M309.48 384a4.48 4.48 0 00-4.8-4.53H299v14.55h2.84v-5.48h2.8a4.48 4.48 0 004.8-4.54m-2.84 0a1.92 1.92 0 01-2.1 2h-2.66v-4h2.66a1.94 1.94 0 012.1 2" transform="translate(-287.81 -367.78)" />
  <path fill="#005ab4" d="M320.34 384.05a16.27 16.27 0 11-16.26-16.27 16.26 16.26 0 0116.26 16.27" transform="translate(-287.81 -367.78)" />
  <path fill="#fff" d="M293.15 378.09v.63a1.15 1.15 0 001.59 1.07l8.9-3.64a1.12 1.12 0 01.88 0l8.89 3.64a1.16 1.16 0 001.6-1.07v-.63a1.17 1.17 0 00-.72-1.07l-9.77-4a1.21 1.21 0 00-.88 0l-9.77 4a1.15 1.15 0 00-.72 1.07" transform="translate(-287.81 -367.78)" />
  <path fill="#fff" d="M310.42 384.32a4.48 4.48 0 00-4.8-4.53H300v14.54h2.84v-5.47h2.8a4.48 4.48 0 004.8-4.54m-2.84 0a1.91 1.91 0 01-2.1 2h-2.66v-4h2.66a1.93 1.93 0 012.1 2" transform="translate(-287.81 -367.78)" />
</svg>
""";
const String _rvParking = """
<svg xmlns="http://www.w3.org/2000/svg" width="22.857142857142854" height="22.857142857142854" viewBox="0 0 32.5 32.5">
  <title fill="rgb(34, 34, 34)">womoparken</title>
  <path fill="#005AB4" d="M32.5,16.3c0,9-7.3,16.3-16.3,16.3S0,25.3,0,16.3C0,7.3,7.3,0,16.3,0h0C25.2,0,32.5,7.3,32.5,16.3          C32.5,16.3,32.5,16.3,32.5,16.3" />
  <path fill="#FFFFFF" d="M15.7,7.6c0-1.7-1.3-3-2.9-3.1c-0.1,0-0.2,0-0.3,0H8.7v9.8h1.9v-3.7h1.9c1.7,0.1,3.1-1.1,3.2-2.7          C15.7,7.8,15.7,7.7,15.7,7.6 M13.8,7.6c0,0.7-0.5,1.3-1.3,1.3c-0.1,0-0.1,0-0.2,0h-1.8V6.2h1.8c0.7-0.1,1.4,0.5,1.4,1.2          C13.8,7.5,13.8,7.5,13.8,7.6" />
  <g fill="rgb(34, 34, 34)">
    <defs>
      <path id="SVGID_1_" d="M32.5,16.3c0,9-7.3,16.3-16.3,16.3S0,25.3,0,16.3C0,7.3,7.3,0,16.3,0h0C25.2,0,32.5,7.3,32.5,16.3    C32.5,16.3,32.5,16.3,32.5,16.3" />
    </defs>
    <clipPath id="SVGID_2_">
      <use xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="#SVGID_1_" overflow="visible" />
    </clipPath>
    <g class="st2" clipPath="url(#SVGID_2_)">
      <path fill="#FFFFFF" stroke="#005AB4" class="st3" d="M20.6,27.7c0,1.3-1,2.3-2.3,2.3c-1.3,0-2.3-1-2.3-2.3c0-1.3,1-2.3,2.3-2.3C19.6,25.4,20.6,26.5,20.6,27.7" />
      <path fill="#FFFFFF" d="M37.3,27.7c0,1.3-1,2.3-2.3,2.3c-1.3,0-2.3-1-2.3-2.3c0-1.3,1-2.3,2.3-2.3C36.3,25.4,37.3,26.5,37.3,27.7" />
    </g>
  </g>
  <path fill="#FFFFFF" d="M32.5,16.3C32.5,16.3,32.5,16.3,32.5,16.3c0-1.2-0.1-2.3-0.4-3.4c-0.1,0-0.3-0.1-0.4-0.1c-5,0-10.1,0-15.1,0          c-0.4,0-0.7,0.1-1,0.3c-0.9,0.5-1.7,1.1-2.6,1.7c-0.3,0.1-0.5,0.4-0.4,0.8c0,0,0,0,0,0.1c0,1,0.8,1.8,1.9,1.8h7.3          c0.1,0.4,0,0.6-0.3,0.7c-0.8,0.1-1.5,0.2-2.2,0.4c-0.4,0.1-0.7,0.3-0.9,0.6c-0.6,0.8-1.2,1.8-1.8,2.6c-0.2,0.3-0.6,0.6-0.9,0.7          c-0.8,0.3-1.6,0.6-2.4,0.9c-0.2,0.1-0.4,0.3-0.5,0.6c0,1.1,0,2.2,0,3.2c0,0,0,0,0,0.1c0,0.3,0.2,0.5,0.5,0.5c0.8,0,1.5,0,2.2,0          c0.5-2,1.4-2.8,2.8-2.8c0.6,0,1.2,0.2,1.8,0.5c0.8,0.5,1.3,1.4,1.3,2.3h6.6c0.3-0.4,0.7-0.7,1-1.1h-2.4c-0.4,0-0.6-0.2-0.6-0.6          c0-1.3,0-2.7,0-4c0-1.4,0-2.7,0-4l0,0c0-0.4,0.1-0.6,0.6-0.6c1.3,0,2.7,0,4,0c0.4,0,0.6,0.2,0.6,0.6c0,1.7,0,3.5,0,5.2          C32,21.1,32.5,18.7,32.5,16.3z M21.8,21.8c0,0.3-0.1,0.5-0.4,0.5c-0.7,0-2.2,0.2-2.2,0.2h-2l0,0c-0.4,0-0.5-0.2-0.3-0.5          c0.6-0.9,1.2-1.8,1.8-2.7c0.1-0.2,0.4-0.3,0.6-0.3c0.7,0,1.3,0,2,0c0.3,0,0.5,0.2,0.5,0.5C21.8,20.3,21.8,21,21.8,21.8z M21.9,15.8          c0,0.3-0.1,0.5-0.5,0.5c-0.6,0-1.3,0-1.9,0c-0.6,0-1.2,0-1.8,0c-0.4,0-0.5-0.1-0.5-0.5c0-0.4,0-1,0-1.3c0-0.3,0.2-0.5,0.5-0.5h3.7          c0.3,0,0.5,0,0.5,0.5S21.8,15.5,21.9,15.8z" />
</svg>
""";
const String _parkingRide = """
<svg xmlns="http://www.w3.org/2000/svg" width="22.857142857142854" height="22.857142857142854" viewBox="0 0 32.529998779296875 32.529998779296875">
  <path fill="#005ab4" d="M320.34 384.05a16.27 16.27 0 11-16.26-16.27 16.26 16.26 0 0116.26 16.27" transform="translate(-287.81 -367.78)" />
  <path fill="#fff" d="M299.17 383.45a2.18 2.18 0 01-.63.85 2.57 2.57 0 01-1 .49 4.58 4.58 0 01-1.2.16h-1.83v2.95h-1.66v-8.33h3.64a3.68 3.68 0 011.11.16 2.71 2.71 0 01.92.49 2.33 2.33 0 01.61.83 2.64 2.64 0 01.23 1.16 3.08 3.08 0 01-.23 1.24m-1.81-2a1.42 1.42 0 00-.89-.25h-1.92v2.12h1.94q1.2 0 1.2-1.08a.93.93 0 00-.33-.79" transform="translate(-287.81 -367.78)" />
  <path fill="#fff" d="M16.8 16.79v2.26h-1.63v-2.26h-2.18v-1.55h2.18v-2.26h1.63v2.26h2.18v1.55H16.8z" />
  <path fill="#fff" d="M313.34 387.9l-1.49-3h-1.68v3h-1.65v-8.33h3.87a3.68 3.68 0 011.11.16 2.71 2.71 0 01.92.49 2.48 2.48 0 01.62.83 2.76 2.76 0 01.22 1.16 2.69 2.69 0 01-.4 1.54 2.43 2.43 0 01-1.19.91l1.59 3.24zm-.11-6.46a1.42 1.42 0 00-.88-.24h-2.18v2.13h2.18q1.2 0 1.2-1.08a1 1 0 00-.32-.81" transform="translate(-287.81 -367.78)" />
  <path fill="#fff" fillRule="evenodd" d="M292.9 378.33h22.36a2.18 2.18 0 00-1.87-2.13h-18.62a2.13 2.13 0 00-1.87 2.13M292.89 389.14h22.36a2.17 2.17 0 01-1.87 2.12h-18.62a2.13 2.13 0 01-1.87-2.12" transform="translate(-287.81 -367.78)" />
</svg>
""";
const String _parkingCarpool = """
<svg xmlns="http://www.w3.org/2000/svg" width="22.857142857142854" height="22.857142857142854" viewBox="0 0 32.540000915527344 32.540000915527344">
  <path fill="#005ab4" d="M32.53 16.27A16.27 16.27 0 1116.26 0a16.26 16.26 0 0116.27 16.26" transform="translate(.01)" />
  <path fill="#fff" d="M10.44 15.67a2.18 2.18 0 01-.64.85 2.6 2.6 0 01-1 .49 4.59 4.59 0 01-1.2.15H5.81v2.95H4.16v-8.33H7.8a4 4 0 011.1.16 2.64 2.64 0 01.92.5 2.31 2.31 0 01.62.82 2.79 2.79 0 01.22 1.16 3.14 3.14 0 01-.22 1.25m-1.82-2a1.41 1.41 0 00-.89-.26H5.81v2.12h2c.79 0 1.19-.36 1.19-1.07a.92.92 0 00-.33-.79" transform="translate(.01)" />
  <path fill="#fff" d="M15.89 16.79v2.26h-1.63v-2.26h-2.18v-1.55h2.18v-2.26h1.63v2.26h2.17v1.55h-2.17z" />
  <path fill="#fff" fillRule="evenodd" d="M4.16 10.54h24.2a2.18 2.18 0 00-1.87-2.12H6a2.13 2.13 0 00-1.87 2.12M4.16 21.35h24.19a2.18 2.18 0 01-1.87 2.13H6a2.13 2.13 0 01-1.87-2.13" class="cls-3" transform="translate(.01)" />
  <path fill="#fff" d="M26.66 14.12l-2.23 6h-.74l-2.23-6v6h-1.68v-8.34h2.36L24.06 17 26 11.78h2.38v8.34h-1.7z" transform="translate(.01)" />
</svg>
""";

const Map<ParkingsLayerIds, String> parkingMarkerIcons = {
  ParkingsLayerIds.parkingGarage: _parkingGarage,
  ParkingsLayerIds.parkingSpot: _parking,
  ParkingsLayerIds.rvParking: _rvParking,
  ParkingsLayerIds.parkRide: _parkingRide,
  ParkingsLayerIds.undergroundCarPark: _parkingGarage,
  ParkingsLayerIds.barrierFreeParkingSpace: _parking,
  ParkingsLayerIds.parkCarpool: _parkingCarpool,
};