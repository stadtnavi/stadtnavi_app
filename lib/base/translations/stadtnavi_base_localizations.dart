import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'stadtnavi_base_localizations_de.dart';
import 'stadtnavi_base_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of StadtnaviBaseLocalization
/// returned by `StadtnaviBaseLocalization.of(context)`.
///
/// Applications need to include `StadtnaviBaseLocalization.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'translations/stadtnavi_base_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: StadtnaviBaseLocalization.localizationsDelegates,
///   supportedLocales: StadtnaviBaseLocalization.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the StadtnaviBaseLocalization.supportedLocales
/// property.
abstract class StadtnaviBaseLocalization {
  StadtnaviBaseLocalization(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static StadtnaviBaseLocalization of(BuildContext context) {
    return Localizations.of<StadtnaviBaseLocalization>(context, StadtnaviBaseLocalization)!;
  }

  static const LocalizationsDelegate<StadtnaviBaseLocalization> delegate = _StadtnaviBaseLocalizationDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// Itinerary Ticket Title label
  ///
  /// In en, this message translates to:
  /// **'Required tickets'**
  String get itineraryTicketsTitle;

  /// Itinerary Ticket Title label
  ///
  /// In en, this message translates to:
  /// **'Required ticket'**
  String get itineraryTicketTitle;

  /// Itinerary Buy tickets label
  ///
  /// In en, this message translates to:
  /// **'Buy tickets'**
  String get itineraryBuyTicket;

  /// Itinerary No price information label
  ///
  /// In en, this message translates to:
  /// **'No price information'**
  String get itineraryMissingPrice;

  /// Itinerary Price Only PublicTransport label
  ///
  /// In en, this message translates to:
  /// **'Price only valid for public transport part of the journey.'**
  String get itineraryPriceOnlyPublicTransport;

  /// copyrights Price Provider for cost
  ///
  /// In en, this message translates to:
  /// **'Fare information provided by Nahverkehrsgesellschaft Baden-Württemberg mbH (NVBW). No liability for the correctness of the information.'**
  String get copyrightsPriceProvider;

  /// The type ticket.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get fareTicketName;

  /// Walking Speed configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Walking speed'**
  String get settingPanelWalkingSpeed;

  /// Avoid Walking configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Avoid walking'**
  String get settingPanelAvoidWalking;

  /// Transport Modes configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Transport modes'**
  String get settingPanelTransportModes;

  /// Vehicle name (Sharing)
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get instructionVehicleSharing;

  /// General Rental bikes and scooters label
  ///
  /// In en, this message translates to:
  /// **'Rental bikes and scooters'**
  String get commonCitybikes;

  /// Vehicle name (RegioRad)
  ///
  /// In en, this message translates to:
  /// **'RegioRad'**
  String get instructionVehicleSharingRegioRad;

  /// Vehicle name (Taxi)
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get instructionVehicleSharingTaxi;

  /// Vehicle name (Car sharing)
  ///
  /// In en, this message translates to:
  /// **'Car sharing'**
  String get instructionVehicleSharingCarSharing;

  /// Avoid Transfers configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Avoid transfers'**
  String get settingPanelAvoidTransfers;

  /// My modes of transport configuration panel label
  ///
  /// In en, this message translates to:
  /// **'My modes of transport'**
  String get settingPanelMyModesTransport;

  /// Travel Speed configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Biking speed'**
  String get settingPanelBikingSpeed;

  /// Park and Ride configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Park & Ride'**
  String get settingPanelMyModesTransportParkRide;

  /// Accessibility configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingPanelAccessibility;

  /// Accessibility details configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Due to a lack of data on accessibility, we are unfortunately unable to provide any barrier-free routes at the moment.'**
  String get settingPanelAccessibilityDetails;

  /// Wheelchair configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Wheelchair'**
  String get settingPanelWheelchair;

  /// Bike configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get settingPanelMyModesTransportBike;

  /// Average speed type
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get typeSpeedAverage;

  /// Fast speed type
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get typeSpeedFast;

  /// Slow speed type
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get typeSpeedSlow;

  /// General Leaving now label
  ///
  /// In en, this message translates to:
  /// **'Leaving now'**
  String get commonLeavingNow;

  /// General Arrival label
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get commonArrival;

  /// General Departure label
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get commonDeparture;

  /// Text info message Destination outside for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'No route suggestions were found because the destination is outside the service area.'**
  String get infoMessageDestinationOutsideService;

  /// Text info message No Route Msg for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, no route suggestions were found.'**
  String get infoMessageNoRouteMsg;

  /// Text info message No Route Msg With Changes for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, no route suggestions were found. Please check your search settings or try changing the origin or destination.'**
  String get infoMessageNoRouteMsgWithChanges;

  /// Text info message no route origin same as a destination for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'No route suggestions were found because the origin and destination are the same.'**
  String get infoMessageNoRouteOriginNearDestination;

  /// Text info message No Route Origin Same As Destination for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'No route suggestions were found because the origin and destination are very close to each other.'**
  String get infoMessageNoRouteOriginSameAsDestination;

  /// Text info message No Route Showing Alternative Options for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'No route suggestions were found with your settings. However, we found the following route options:'**
  String get infoMessageNoRouteShowingAlternativeOptions;

  /// Text info message Only walking and cycling Routes for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'Your search returned only cycling routes.'**
  String get infoMessageOnlyCyclingRoutes;

  /// Text info message Only cycling Routes for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'Your search returned only walking and cycling routes.'**
  String get infoMessageOnlyWalkingCyclingRoutes;

  /// Text info message Only Walking Routes for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'Your search returned only walking routes.'**
  String get infoMessageOnlyWalkingRoutes;

  /// Text info message origin outside for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'No route suggestions were found because the origin is outside the service area.'**
  String get infoMessageOriginOutsideService;

  /// Text info message Use National Service Prefix for plan Fetch
  ///
  /// In en, this message translates to:
  /// **'We recommend you try the national journey planner,'**
  String get infoMessageUseNationalServicePrefix;

  /// Common Text Bike station
  ///
  /// In en, this message translates to:
  /// **'Bike station'**
  String get bikeRentalBikeStation;

  /// General details label
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get commonDetails;

  /// General More informartion label
  ///
  /// In en, this message translates to:
  /// **'More informartion'**
  String get commonMoreInformartion;

  /// General Call label
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get commonCall;

  /// General book a trip label
  ///
  /// In en, this message translates to:
  /// **'Book a trip'**
  String get commonOnDemandTaxi;

  /// This car park is close to capacity
  ///
  /// In en, this message translates to:
  /// **'This car park is close to capacity. Please allow additional time for you journey.'**
  String get carParkCloseCapacityMessage;

  /// Car Park Exclude Full parks label
  ///
  /// In en, this message translates to:
  /// **'Exclude full car parks'**
  String get carParkExcludeFull;

  /// Text Bike Rental Network message FreeFloating
  ///
  /// In en, this message translates to:
  /// **'Destination is not a designated drop-off area. Rental cannot be completed here. Please check terms & conditions for additional fees.'**
  String get bikeRentalNetworkFreeFloating;

  /// Text about extra fetch itineraries for later departure title
  ///
  /// In en, this message translates to:
  /// **'Later departures'**
  String get fetchMoreItinerariesLaterDeparturesTitle;

  /// Text about extra fetch itineraries for Earlier departure title
  ///
  /// In en, this message translates to:
  /// **'Earlier departures'**
  String get fetchMoreItinerariesEarlierDepartures;

  /// Bike and Ride configuration panel label
  ///
  /// In en, this message translates to:
  /// **'Bike & Ride'**
  String get settingPanelMyModesTransportBikeRide;

  /// Vehicle name (onCar)
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get instructionVehicleTaxi;

  /// No description provided for @mapLegendBicycleParking.
  ///
  /// In en, this message translates to:
  /// **'bicycle parking'**
  String get mapLegendBicycleParking;

  /// No description provided for @mapLegendCoveredBicycleParking.
  ///
  /// In en, this message translates to:
  /// **'covered bicycle parking'**
  String get mapLegendCoveredBicycleParking;

  /// No description provided for @mapLegendLockableBicycleParking.
  ///
  /// In en, this message translates to:
  /// **'lockable bicycle parking'**
  String get mapLegendLockableBicycleParking;

  /// No description provided for @mapLegendBicycleRepairFacility.
  ///
  /// In en, this message translates to:
  /// **'bicycle repair facility'**
  String get mapLegendBicycleRepairFacility;

  /// No description provided for @mapLegendBikeLane.
  ///
  /// In en, this message translates to:
  /// **'bike lane'**
  String get mapLegendBikeLane;

  /// No description provided for @mapLegendMajorCyclingRoute.
  ///
  /// In en, this message translates to:
  /// **'major cycling route'**
  String get mapLegendMajorCyclingRoute;

  /// No description provided for @mapLegendLocalCyclingRoute.
  ///
  /// In en, this message translates to:
  /// **'local cycling route'**
  String get mapLegendLocalCyclingRoute;

  /// No description provided for @notShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Do not show again'**
  String get notShowAgain;

  /// Label for the Map types
  ///
  /// In en, this message translates to:
  /// **'Map Type'**
  String get mapTypeLabel;

  /// General Map Settings label
  ///
  /// In en, this message translates to:
  /// **'Map Settings'**
  String get commonMapSettings;

  /// General Show on map tilers label
  ///
  /// In en, this message translates to:
  /// **'Show on map'**
  String get commonShowMap;

  ///
  ///
  /// In en, this message translates to:
  /// **'Park & Ride for bikes'**
  String get bikePark;

  /// Text title itinerary Summary Bike Park Title
  ///
  /// In en, this message translates to:
  /// **'Leave your bike at a Park & Ride'**
  String get itinerarySummaryBikeParkTitle;

  /// Text title itinerary Summary Bike And Public Rail Subway
  ///
  /// In en, this message translates to:
  /// **'Take your bike with you on the train or to metro'**
  String get itinerarySummaryBikeAndPublicRailSubwayTitle;

  /// Departure Bike Station detail Time and Stop
  ///
  /// In en, this message translates to:
  /// **'Departure at {departureTime} from {departureStop} bike station'**
  String departureBikeStation(Object departureStop, Object departureTime);

  /// No description provided for @commonTotalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total distance'**
  String get commonTotalDistance;

  /// General Settings label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @mapLegend.
  ///
  /// In en, this message translates to:
  /// **'map legend'**
  String get mapLegend;

  /// No description provided for @selectStop.
  ///
  /// In en, this message translates to:
  /// **'Select Stop ({sizeStops})'**
  String selectStop(Object sizeStops);

  /// No description provided for @bicycleParking.
  ///
  /// In en, this message translates to:
  /// **'Bicycle parking'**
  String get bicycleParking;

  /// No description provided for @instructionVehicleRackRailway.
  ///
  /// In en, this message translates to:
  /// **'Rack railway'**
  String get instructionVehicleRackRailway;

  /// General Track  label
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get commonTrack;

  /// General Platform  label
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get commonPlatform;

  /// No description provided for @weekdayMO.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMO;

  /// No description provided for @weekdayTU.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTU;

  /// No description provided for @weekdayWE.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWE;

  /// No description provided for @weekdayTH.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayTH;

  /// No description provided for @weekdayFR.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFR;

  /// No description provided for @weekdaySA.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySA;

  /// No description provided for @weekdaySU.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySU;

  /// No description provided for @weekdayPH.
  ///
  /// In en, this message translates to:
  /// **'Public holiday'**
  String get weekdayPH;

  /// No description provided for @commonNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get commonNow;

  /// No description provided for @commonClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get commonClosed;

  /// No description provided for @commonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// No description provided for @commonOpenAlways.
  ///
  /// In en, this message translates to:
  /// **'Open 24/7'**
  String get commonOpenAlways;
}

class _StadtnaviBaseLocalizationDelegate extends LocalizationsDelegate<StadtnaviBaseLocalization> {
  const _StadtnaviBaseLocalizationDelegate();

  @override
  Future<StadtnaviBaseLocalization> load(Locale locale) {
    return SynchronousFuture<StadtnaviBaseLocalization>(lookupStadtnaviBaseLocalization(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_StadtnaviBaseLocalizationDelegate old) => false;
}

StadtnaviBaseLocalization lookupStadtnaviBaseLocalization(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return StadtnaviBaseLocalizationDe();
    case 'en': return StadtnaviBaseLocalizationEn();
  }

  throw FlutterError(
    'StadtnaviBaseLocalization.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
