import 'package:flutter_svg/svg.dart';

const String iconInstructionElevator = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M7 18h3v-4h1V9.5H6V14h1zm1.5-9.5q.525 0 .888-.363t.362-.887t-.363-.888T8.5 6t-.888.363t-.362.887t.363.888t.887.362M13 11h5l-2.5-4zm2.5 6l2.5-4h-5zM3 21V3h18v18zm2-2h14V5H5zm0 0V5z"/></svg>
''';

const String iconInstructionEnterStation = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="currentColor"><path d="M20 5H8v4H6V3h16v18H6v-6h2v4h12z"/><path d="m13.074 16.95l-1.414-1.414L14.196 13H2v-2h12.196L11.66 8.465l1.414-1.415l4.95 4.95z"/></g></svg>
''';

const String iconInstructionExitStation = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M10.09 15.59L11.5 17l5-5l-5-5l-1.41 1.41L12.67 11H3v2h9.67zM21 3H3v6h2V5h14v14H5v-4H3v6h18z"/></svg>
''';
const String iconInstructionFollowSigns = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M9.5 5.5c1.1 0 2-.9 2-2s-.9-2-2-2s-2 .9-2 2s.9 2 2 2M5.75 8.9L3 23h2.1l1.75-8L9 17v6h2v-7.55L8.95 13.4l.6-3C10.85 12 12.8 13 15 13v-2c-1.85 0-3.45-1-4.35-2.45l-.95-1.6C9.35 6.35 8.7 6 8 6q-.375 0-.75.15L2 8.3V13h2V9.65zM13 2v7h3.75v14h1.5V9H22V2zm5.01 6V6.25H14.5v-1.5h3.51V3l2.49 2.5z"/></svg>
''';
const String iconInstructionRoundaboutLeft = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M15 21v-6.1q0-.725.475-1.275t1.2-.675q1.45-.25 2.388-1.362T20 9q0-1.65-1.175-2.825T16 5q-1.475 0-2.588.938T12.05 8.325q-.125.725-.675 1.2T10.1 10H5.825l1.6 1.6L6 13L2 9l4-4l1.4 1.4L5.825 8h4.25q.35-2.2 2.038-3.6T16 3q2.5 0 4.25 1.75T22 9q0 2.2-1.4 3.888T17 14.924V21z"/></svg>
''';
const String iconInstructionRoundaboutRight = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M7 21v-6.075q-2.2-.35-3.6-2.037T2 9q0-2.5 1.75-4.25T8 3q2.2 0 3.888 1.4T13.924 8h4.25L16.6 6.4L18 5l4 4l-4 4l-1.425-1.4l1.6-1.6H13.9q-.725 0-1.275-.475t-.675-1.2q-.25-1.45-1.362-2.387T8 5Q6.35 5 5.175 6.175T4 9q0 1.475.938 2.588t2.387 1.362q.725.125 1.2.675T9 14.9V21z"/></svg>
''';

const String iconInstructionSharpTurnLeft = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path d="M17 18V6.69a.7.7 0 0 0-1.195-.495L6 16"/><path d="M11 16H6v-5"/></g></svg>
''';

const String iconInstructionSharpTurnRight = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path d="M7 18V6.69a.7.7 0 0 1 1.195-.495L18 16"/><path d="M13 16h5v-5"/></g></svg>
''';
const String iconInstructionStraight = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M11 21V6.825L9.4 8.4L8 7l4-4l4 4l-1.4 1.4L13 6.825V21z"/></svg>
''';

const String iconInstructionTurnLeft = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M7 20v-9q0-.825.588-1.412T9 9h8.2l-1.6-1.6L17 6l4 4l-4 4l-1.4-1.4l1.6-1.6H9v9z"/></svg>
''';

const String iconInstructionTurnRight= '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M7 20v-9q0-.825.588-1.412T9 9h8.2l-1.6-1.6L17 6l4 4l-4 4l-1.4-1.4l1.6-1.6H9v9z"/></svg>
''';

const String iconInstructionTurnLeftRight = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M7 20v-9q0-.825.588-1.412T9 9h8.2l-1.6-1.6L17 6l4 4l-4 4l-1.4-1.4l1.6-1.6H9v9z"/></svg>
''';
const String iconInstructionTurnSlightLeft = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M13 20v-7.6l-5-5v2.25H6V4h5.65v2H9.4l5.025 5.025q.275.275.425.638t.15.762V20z"/></svg>
''';

const String iconInstructionTurnSlightRight = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M9 20v-7.575q0-.4.15-.763t.425-.637L14.6 6h-2.25V4H18v5.65h-2V7.4l-5 5V20z"/></svg>
''';
const String iconInstructionUTurnLeft = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M18 9v12h-2V9c0-2.21-1.79-4-4-4S8 6.79 8 9v4.17l1.59-1.59L11 13l-4 4l-4-4l1.41-1.41L6 13.17V9c0-3.31 2.69-6 6-6s6 2.69 6 6"/></svg>
''';

const String iconInstructionUTurnRight = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="currentColor" d="M6 21V9q0-2.5 1.75-4.25T12 3t4.25 1.75T18 9v4.2l1.6-1.6L21 13l-4 4l-4-4l1.4-1.4l1.6 1.6V9q0-1.65-1.175-2.825T12 5T9.175 6.175T8 9v12z"/></svg>
''';

SvgPicture iconInstructionElevatorSvg =
    SvgPicture.string(iconInstructionElevator);
SvgPicture iconInstructionEnterStationSvg =
    SvgPicture.string(iconInstructionEnterStation);
SvgPicture iconInstructionExitStationSvg =
    SvgPicture.string(iconInstructionExitStation);
SvgPicture iconInstructionFollowSignsSvg =
    SvgPicture.string(iconInstructionFollowSigns);
SvgPicture iconInstructionRoundaboutLeftSvg =
    SvgPicture.string(iconInstructionRoundaboutLeft);
SvgPicture iconInstructionRoundaboutRightSvg =
    SvgPicture.string(iconInstructionRoundaboutRight);
SvgPicture iconInstructionSharpTurnLeftSvg =
    SvgPicture.string(iconInstructionSharpTurnLeft);
SvgPicture iconInstructionSharpTurnRightSvg =
    SvgPicture.string(iconInstructionSharpTurnRight);
SvgPicture iconInstructionStraightSvg =
    SvgPicture.string(iconInstructionStraight);
SvgPicture iconInstructionTurnLeftSvg =
    SvgPicture.string(iconInstructionTurnLeft);
SvgPicture iconInstructionTurnRightSvg =
    SvgPicture.string(iconInstructionTurnRight);
SvgPicture iconInstructionTurnLeftRightSvg =
    SvgPicture.string(iconInstructionTurnLeftRight);
SvgPicture iconInstructionTurnSlightLeftSvg =
    SvgPicture.string(iconInstructionTurnSlightLeft);
SvgPicture iconInstructionTurnSlightRightSvg =
    SvgPicture.string(iconInstructionTurnSlightRight);
SvgPicture iconInstructionUTurnLeftSvg =
    SvgPicture.string(iconInstructionUTurnLeft);
SvgPicture iconInstructionUTurnRightSvg =
    SvgPicture.string(iconInstructionUTurnRight);
    
