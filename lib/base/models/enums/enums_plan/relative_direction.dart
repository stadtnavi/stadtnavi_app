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
    RelativeDirection.hardLeft: Icons.turn_left,
    RelativeDirection.left: Icons.turn_left,
    RelativeDirection.slightlyLeft: Icons.subdirectory_arrow_left,
    RelativeDirection.continue_: Icons.forward,
    RelativeDirection.slightlyRight: Icons.subdirectory_arrow_right,
    RelativeDirection.right: Icons.turn_right,
    RelativeDirection.hardRight: Icons.turn_right,
    RelativeDirection.circleClockwise: Icons.refresh,
    RelativeDirection.circleCounterclockwise: Icons.undo,
    RelativeDirection.elevator: Icons.elevator,
    RelativeDirection.uturnLeft: Icons.call_missed_outgoing,
    RelativeDirection.uturnRight: Icons.call_missed,
    RelativeDirection.enterStation: Icons.train,
    RelativeDirection.exitStation: Icons.exit_to_app,
    RelativeDirection.followSigns: Icons.signpost,
  };

  String translatesTitle(
    StadtnaviBaseLocalization localization,
  ) {
    return {
          RelativeDirection.depart: localization.relativeDirectionDepart,
          RelativeDirection.hardLeft: localization.relativeDirectionHardLeft,
          RelativeDirection.left: localization.relativeDirectionLeft,
          RelativeDirection.slightlyLeft:
              localization.relativeDirectionSlightlyLeft,
          RelativeDirection.continue_: localization.relativeDirectionContinue,
          RelativeDirection.slightlyRight:
              localization.relativeDirectionSlightlyRight,
          RelativeDirection.right: localization.relativeDirectionRight,
          RelativeDirection.hardRight: localization.relativeDirectionHardRight,
          RelativeDirection.circleClockwise:
              localization.relativeDirectionCircleClockwise,
          RelativeDirection.circleCounterclockwise:
              localization.relativeDirectionCircleCounterclockwise,
          RelativeDirection.elevator: localization.relativeDirectionElevator,
          RelativeDirection.uturnLeft: localization.relativeDirectionUturnLeft,
          RelativeDirection.uturnRight:
              localization.relativeDirectionUturnRight,
          RelativeDirection.enterStation:
              localization.relativeDirectionEnterStation,
          RelativeDirection.exitStation:
              localization.relativeDirectionExitStation,
          RelativeDirection.followSigns:
              localization.relativeDirectionFollowSigns,
        }[this] ??
        'errorType';
  }

  String get name => names[this] ?? 'CONTINUE';
  IconData get icon => icons[this] ?? Icons.help_outline;
}
