import 'package:flutter/material.dart';
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

  static const icons = <RelativeDirection, IconData>{
    RelativeDirection.depart: Icons.directions_walk,
    RelativeDirection.hardLeft: Icons.keyboard_double_arrow_left,
    RelativeDirection.left: Icons.turn_left,
    RelativeDirection.slightlyLeft: Icons.turn_slight_left,
    RelativeDirection.continue_: Icons.arrow_upward,
    RelativeDirection.slightlyRight: Icons.turn_slight_right,
    RelativeDirection.right: Icons.turn_right,
    RelativeDirection.hardRight: Icons.keyboard_double_arrow_right,
    RelativeDirection.circleClockwise: Icons.rotate_right,
    RelativeDirection.circleCounterclockwise: Icons.rotate_left,
    RelativeDirection.elevator: Icons.elevator,
    RelativeDirection.uturnLeft: Icons.u_turn_left,
    RelativeDirection.uturnRight: Icons.u_turn_right,
    RelativeDirection.enterStation: Icons.subway,
    RelativeDirection.exitStation: Icons.exit_to_app,
    RelativeDirection.followSigns: Icons.signpost_outlined,
  };

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
  IconData get icon => icons[this] ?? Icons.help_outline;
}
