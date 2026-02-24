import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

enum PlanInfoBox {
  originOutsideService,
  destinationOutsideService,
  noRouteOriginSameAsDestination,
  noRouteOriginNearDestination,
  onlyWalkingRoutes,
  onlyCyclingRoutes,
  onlyWalkingCyclingRoutes,
  noRouteMsgWithChanges,
  noRouteMsg,
  usingDefaultTransports,
  undefined,
}

PlanInfoBox getPlanInfoBoxByKey(String key) {
  return PlanInfoBoxExtension.names.keys.firstWhere(
    (keyE) => keyE.name == key,
    orElse: () => PlanInfoBox.undefined,
  );
}

extension PlanInfoBoxExtension on PlanInfoBox {
  static const names = <PlanInfoBox, String>{
    PlanInfoBox.originOutsideService: 'ORIGIN_OUTSIDE_SERVICE',
    PlanInfoBox.destinationOutsideService: 'DESTINATION_OUTSIDE_SERVICE',
    PlanInfoBox.noRouteOriginSameAsDestination:
        'NO_ROUTE_ORIGIN_SAME_AS_DESTINATION',
    PlanInfoBox.noRouteOriginNearDestination:
        'NO_ROUTE_ORIGIN_NEAR_DESTINATION',
    PlanInfoBox.onlyWalkingRoutes: 'WALK_BIKE_ITINERARY1',
    PlanInfoBox.onlyCyclingRoutes: 'WALK_BIKE_ITINERARY2',
    PlanInfoBox.onlyWalkingCyclingRoutes: 'WALK_BIKE_ITINERARY3',
    PlanInfoBox.noRouteMsgWithChanges: 'NO_ROUTE_MSG_WITH_CHANGES',
    PlanInfoBox.noRouteMsg: 'NO_ROUTE_MSG',
    PlanInfoBox.usingDefaultTransports: 'USING_DEFAULT_TRANSPORTS',
    PlanInfoBox.undefined: 'UNDEFINED',
  };

  String get name => names[this]!;

  String translateValue(
    StadtnaviBaseLocalization localization,
  ) {
    switch (this) {
      case PlanInfoBox.originOutsideService:
        return localization.infoMessageOriginOutsideService;
      case PlanInfoBox.destinationOutsideService:
        return localization.infoMessageDestinationOutsideService;
      case PlanInfoBox.noRouteOriginSameAsDestination:
        return localization.infoMessageNoRouteOriginSameAsDestination;
      case PlanInfoBox.noRouteOriginNearDestination:
        return localization.infoMessageNoRouteOriginNearDestination;
      case PlanInfoBox.onlyWalkingRoutes:
        return localization.infoMessageOnlyWalkingRoutes;
      case PlanInfoBox.onlyCyclingRoutes:
        return localization.infoMessageOnlyCyclingRoutes;
      case PlanInfoBox.onlyWalkingCyclingRoutes:
        return localization.infoMessageOnlyWalkingCyclingRoutes;
      case PlanInfoBox.noRouteMsgWithChanges:
        return localization.infoMessageNoRouteMsgWithChanges;
      case PlanInfoBox.noRouteMsg:
        return localization.infoMessageNoRouteMsg;
      case PlanInfoBox.usingDefaultTransports:
        return localization.infoMessageNoRouteShowingAlternativeOptions;
      default:
        return 'typeError';
    }
  }
}
