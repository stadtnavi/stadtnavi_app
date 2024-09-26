import 'stadtnavi_base_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class StadtnaviBaseLocalizationEn extends StadtnaviBaseLocalization {
  StadtnaviBaseLocalizationEn([String locale = 'en']) : super(locale);

  @override
  String get itineraryTicketsTitle => 'Required tickets';

  @override
  String get itineraryTicketTitle => 'Required ticket';

  @override
  String get itineraryBuyTicket => 'Buy tickets';

  @override
  String get itineraryMissingPrice => 'No price information';

  @override
  String get itineraryPriceOnlyPublicTransport => 'Price only valid for public transport part of the journey.';

  @override
  String get copyrightsPriceProvider => 'Fare information provided by Nahverkehrsgesellschaft Baden-Württemberg mbH (NVBW). No liability for the correctness of the information.';

  @override
  String get fareTicketName => 'Adult';

  @override
  String get settingPanelWalkingSpeed => 'Walking speed';

  @override
  String get settingPanelAvoidWalking => 'Avoid walking';

  @override
  String get settingPanelTransportModes => 'Transport modes';

  @override
  String get instructionVehicleSharing => 'Sharing';

  @override
  String get commonCitybikes => 'Rental bikes and scooters';

  @override
  String get instructionVehicleSharingRegioRad => 'RegioRad';

  @override
  String get instructionVehicleSharingTaxi => 'Taxi';

  @override
  String get instructionVehicleSharingCarSharing => 'Car sharing';

  @override
  String get settingPanelAvoidTransfers => 'Avoid transfers';

  @override
  String get settingPanelMyModesTransport => 'My modes of transport';

  @override
  String get settingPanelBikingSpeed => 'Biking speed';

  @override
  String get settingPanelMyModesTransportParkRide => 'Park & Ride';

  @override
  String get settingPanelAccessibility => 'Accessibility';

  @override
  String get settingPanelAccessibilityDetails => 'Due to a lack of data on accessibility, we are unfortunately unable to provide any barrier-free routes at the moment.';

  @override
  String get settingPanelWheelchair => 'Wheelchair';

  @override
  String get settingPanelMyModesTransportBike => 'Bike';

  @override
  String get typeSpeedAverage => 'Normal';

  @override
  String get typeSpeedFast => 'Fast';

  @override
  String get typeSpeedSlow => 'Slow';

  @override
  String get commonLeavingNow => 'Leaving now';

  @override
  String get commonArrival => 'Arrival';

  @override
  String get commonDeparture => 'Departure';

  @override
  String get infoMessageDestinationOutsideService => 'No route suggestions were found because the destination is outside the service area.';

  @override
  String get infoMessageNoRouteMsg => 'Unfortunately, no route suggestions were found.';

  @override
  String get infoMessageNoRouteMsgWithChanges => 'Unfortunately, no route suggestions were found. Please check your search settings or try changing the origin or destination.';

  @override
  String get infoMessageNoRouteOriginNearDestination => 'No route suggestions were found because the origin and destination are the same.';

  @override
  String get infoMessageNoRouteOriginSameAsDestination => 'No route suggestions were found because the origin and destination are very close to each other.';

  @override
  String get infoMessageNoRouteShowingAlternativeOptions => 'No route suggestions were found with your settings. However, we found the following route options:';

  @override
  String get infoMessageOnlyCyclingRoutes => 'Your search returned only cycling routes.';

  @override
  String get infoMessageOnlyWalkingCyclingRoutes => 'Your search returned only walking and cycling routes.';

  @override
  String get infoMessageOnlyWalkingRoutes => 'Your search returned only walking routes.';

  @override
  String get infoMessageOriginOutsideService => 'No route suggestions were found because the origin is outside the service area.';

  @override
  String get infoMessageUseNationalServicePrefix => 'We recommend you try the national journey planner,';

  @override
  String get bikeRentalBikeStation => 'Bike station';

  @override
  String get commonDetails => 'Details';

  @override
  String get commonMoreInformartion => 'More informartion';

  @override
  String get commonCall => 'Call';

  @override
  String get commonOnDemandTaxi => 'Book a trip';

  @override
  String get carParkCloseCapacityMessage => 'This car park is close to capacity. Please allow additional time for you journey.';

  @override
  String get carParkExcludeFull => 'Exclude full car parks';

  @override
  String get bikeRentalNetworkFreeFloating => 'Destination is not a designated drop-off area. Rental cannot be completed here. Please check terms & conditions for additional fees.';

  @override
  String get fetchMoreItinerariesLaterDeparturesTitle => 'Later departures';

  @override
  String get fetchMoreItinerariesEarlierDepartures => 'Earlier departures';

  @override
  String get settingPanelMyModesTransportBikeRide => 'Bike & Ride';

  @override
  String get instructionVehicleTaxi => 'Taxi';

  @override
  String get mapLegendBicycleParking => 'bicycle parking';

  @override
  String get mapLegendCoveredBicycleParking => 'covered bicycle parking';

  @override
  String get mapLegendLockableBicycleParking => 'lockable bicycle parking';

  @override
  String get mapLegendBicycleRepairFacility => 'bicycle repair facility';

  @override
  String get mapLegendBikeLane => 'bike lane';

  @override
  String get mapLegendMajorCyclingRoute => 'major cycling route';

  @override
  String get mapLegendLocalCyclingRoute => 'local cycling route';

  @override
  String get notShowAgain => 'Do not show again';

  @override
  String get mapTypeLabel => 'Map Type';

  @override
  String get commonMapSettings => 'Map Settings';

  @override
  String get commonShowMap => 'Show on map';

  @override
  String get bikePark => 'Park & Ride for bikes';

  @override
  String get itinerarySummaryBikeParkTitle => 'Leave your bike at a Park & Ride';

  @override
  String get itinerarySummaryBikeAndPublicRailSubwayTitle => 'Take your bike with you on the train or to metro';

  @override
  String departureBikeStation(Object departureStop, Object departureTime) {
    return 'Departure at $departureTime from $departureStop bike station';
  }

  @override
  String get commonTotalDistance => 'Total distance';

  @override
  String get commonSettings => 'Settings';

  @override
  String get mapLegend => 'map legend';

  @override
  String selectStop(Object sizeStops) {
    return 'Select Stop ($sizeStops)';
  }

  @override
  String get bicycleParking => 'Bicycle parking';

  @override
  String get instructionVehicleRackRailway => 'Rack railway';

  @override
  String get commonTrack => 'Track';

  @override
  String get commonPlatform => 'Platform';

  @override
  String get weekdayMO => 'Monday';

  @override
  String get weekdayTU => 'Tuesday';

  @override
  String get weekdayWE => 'Wednesday';

  @override
  String get weekdayTH => 'Thursday';

  @override
  String get weekdayFR => 'Friday';

  @override
  String get weekdaySA => 'Saturday';

  @override
  String get weekdaySU => 'Sunday';

  @override
  String get weekdayPH => 'Public holiday';

  @override
  String get commonNow => 'Now';

  @override
  String get commonClosed => 'Closed';

  @override
  String get commonOpen => 'Open';

  @override
  String get commonOpenAlways => 'Open 24/7';
}
