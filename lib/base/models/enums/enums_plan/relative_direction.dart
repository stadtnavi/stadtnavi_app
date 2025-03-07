import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/relative_directions_icons.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

enum RelativeDirection {
  depart,
  hardLeft,
  left,
  slightlyLeft,
  continue_,
  slightlyRight,
  right,
  hardRight,
  circleClockwise,
  circleCounterclockwise,
  elevator,
  uturnLeft,
  uturnRight,
  enterStation,
  exitStation,
  followSigns,
}

RelativeDirection getRelativeDirectionByString(String direction) {
  return RelativeDirectionExtension.names.keys.firstWhere(
    (key) => key.name == direction,
    orElse: () => RelativeDirection.continue_,
  );
}

extension RelativeDirectionExtension on RelativeDirection {
  static const names = <RelativeDirection, String>{
    RelativeDirection.depart: 'DEPART',
    RelativeDirection.hardLeft: 'HARD_LEFT',
    RelativeDirection.left: 'LEFT',
    RelativeDirection.slightlyLeft: 'SLIGHTLY_LEFT',
    RelativeDirection.continue_: 'CONTINUE',
    RelativeDirection.slightlyRight: 'SLIGHTLY_RIGHT',
    RelativeDirection.right: 'RIGHT',
    RelativeDirection.hardRight: 'HARD_RIGHT',
    RelativeDirection.circleClockwise: 'CIRCLE_CLOCKWISE',
    RelativeDirection.circleCounterclockwise: 'CIRCLE_COUNTERCLOCKWISE',
    RelativeDirection.elevator: 'ELEVATOR',
    RelativeDirection.uturnLeft: 'UTURN_LEFT',
    RelativeDirection.uturnRight: 'UTURN_RIGHT',
    RelativeDirection.enterStation: 'ENTER_STATION',
    RelativeDirection.exitStation: 'EXIT_STATION',
    RelativeDirection.followSigns: 'FOLLOW_SIGNS',
  };
  static Widget? _images(RelativeDirection transportMode, Color? color) {
    switch (transportMode) {
      case RelativeDirection.depart:
        return iconInstructionStraightSvg;
      case RelativeDirection.hardLeft:
        return iconInstructionSharpTurnLeftSvg;
      case RelativeDirection.left:
        return iconInstructionTurnLeftSvg;
      case RelativeDirection.slightlyLeft:
        return iconInstructionTurnSlightLeftSvg;
      case RelativeDirection.continue_:
        return iconInstructionStraightSvg;
      case RelativeDirection.slightlyRight:
        return iconInstructionTurnSlightRightSvg;
      case RelativeDirection.right:
        return iconInstructionTurnRightSvg;
      case RelativeDirection.hardRight:
        return iconInstructionSharpTurnRightSvg;
      case RelativeDirection.circleClockwise:
        return iconInstructionRoundaboutLeftSvg;
      case RelativeDirection.circleCounterclockwise:
        return iconInstructionRoundaboutLeftSvg;
      case RelativeDirection.elevator:
        return iconInstructionElevatorSvg;
      case RelativeDirection.uturnLeft:
        return iconInstructionUTurnLeftSvg;
      case RelativeDirection.uturnRight:
        return iconInstructionUTurnRightSvg;
      case RelativeDirection.enterStation:
        return iconInstructionEnterStationSvg;
      case RelativeDirection.exitStation:
        return iconInstructionExitStationSvg;
      case RelativeDirection.followSigns:
        return iconInstructionFollowSignsSvg;
      // ignore: unreachable_switch_default
      default:
        return null;
    }
  }

  String translatesTitle(
    StadtnaviBaseLocalization localization,
    String streetName, {
    String exitNumber = '',
  }) {
    return {
          RelativeDirection.depart:
              localization.relativeDirectionDepart(streetName),
          RelativeDirection.hardLeft:
              localization.relativeDirectionHardLeft(streetName),
          RelativeDirection.left:
              localization.relativeDirectionLeft(streetName),
          RelativeDirection.slightlyLeft:
              localization.relativeDirectionSlightlyLeft(streetName),
          RelativeDirection.continue_:
              localization.relativeDirectionContinue(streetName),
          RelativeDirection.slightlyRight:
              localization.relativeDirectionSlightlyRight(streetName),
          RelativeDirection.right:
              localization.relativeDirectionRight(streetName),
          RelativeDirection.hardRight:
              localization.relativeDirectionHardRight(streetName),
          RelativeDirection.circleClockwise: localization
              .relativeDirectionCircleClockwise(exitNumber, streetName),
          RelativeDirection.circleCounterclockwise: localization
              .relativeDirectionCircleCounterclockwise(exitNumber, streetName),
          RelativeDirection.elevator:
              localization.relativeDirectionElevator(streetName),
          RelativeDirection.uturnLeft:
              localization.relativeDirectionUturnLeft(streetName),
          RelativeDirection.uturnRight:
              localization.relativeDirectionUturnRight(streetName),
          RelativeDirection.enterStation:
              localization.relativeDirectionEnterStation(streetName),
          RelativeDirection.exitStation:
              localization.relativeDirectionExitStation(streetName),
          RelativeDirection.followSigns:
              localization.relativeDirectionFollowSigns(streetName),
        }[this] ??
        'errorType';
  }

  String get name => names[this] ?? 'CONTINUE';

  Widget getImage({Color? color, double size = 24}) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      child: FittedBox(
        child: _images(this, color) ??
            const Icon(
              Icons.error,
              color: Colors.red,
            ),
      ),
    );
  }
}
