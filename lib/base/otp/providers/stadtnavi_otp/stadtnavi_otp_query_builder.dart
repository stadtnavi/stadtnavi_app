import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/otp/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/otp/utils/mode_utils.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/city_bike_utils.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/default_settings.dart';
import 'package:stadtnavi_core/configuration/config_default/config_utils.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

import 'package:stadtnavi_core/base/otp/services/plan/graphql_operation/query_utils.dart';
import 'package:stadtnavi_core/base/otp/utils/geo_utils.dart';

import 'stadtnavi_otp_preferences.dart';

/// Builds GraphQL query variables from [StadtnaviOtpPreferences].
///
/// Extracted from the former `GraphQLPlanRepository._prepareQueryParams()`.
/// All methods are static and pure – no side effects.
class StadtnaviOtpQueryBuilder {
  StadtnaviOtpQueryBuilder._();

  /// Keys allowed for the strict (fetchMoreItineraries) plan query.
  static const strictAllowedKeys = [
    'fromPlace',
    'toPlace',
    'intermediatePlaces',
    'numItineraries',
    'modes',
    'date',
    'time',
    'walkReluctance',
    'walkBoardCost',
    'minTransferTime',
    'walkSpeed',
    'wheelchair',
    'ticketTypes',
    'arriveBy',
    'transferPenalty',
    'bikeSpeed',
    'optimize',
    'itineraryFiltering',
    'unpreferred',
    'locale',
    'searchWindow',
  ];

  /// Keys allowed for the normal plan query.
  static const planAllowedKeys = [
    'fromPlace',
    'toPlace',
    'intermediatePlaces',
    'numItineraries',
    'modes',
    'date',
    'time',
    'walkReluctance',
    'walkBoardCost',
    'minTransferTime',
    'walkSpeed',
    'wheelchair',
    'ticketTypes',
    'arriveBy',
    'transferPenalty',
    'bikeSpeed',
    'optimize',
    'itineraryFiltering',
    'unpreferred',
    'allowedVehicleRentalNetworks',
    'locale',
    'modeWeight',
  ];

  /// Keys allowed for the modes transport (walk/bike/car) query.
  static const modesTransportAllowedKeys = [
    'fromPlace',
    'toPlace',
    'intermediatePlaces',
    'date',
    'time',
    'walkReluctance',
    'walkBoardCost',
    'minTransferTime',
    'walkSpeed',
    'wheelchair',
    'ticketTypes',
    'arriveBy',
    'transferPenalty',
    'bikeSpeed',
    'optimize',
    'triangle',
    'itineraryFiltering',
    'unpreferred',
    'locale',
    'shouldMakeWalkQuery',
    'shouldMakeBikeQuery',
    'shouldMakeCarQuery',
    'shouldMakeParkRideQuery',
    'shouldMakeOnDemandTaxiQuery',
    'showBikeAndPublicItineraries',
    'showBikeRentAndPublicItineraries',
    'showBikeAndParkItineraries',
    'shouldMakeScooterQuery',
    'bikeAndPublicModes',
    'bikeRentAndPublicModes',
    'scooterRentAndPublicModes',
    'onDemandTaxiModes',
    'bikeParkModes',
    'carParkModes',
    'carRentalModes',
    'parkRideModes',
    'allowedVehicleRentalNetworks',
  ];

  /// Build variables for the plan query.
  static Map<String, dynamic> buildPlanVariables({
    required TrufiLocation from,
    required TrufiLocation to,
    required StadtnaviOtpPreferences preferences,
    required DateTime? dateTime,
    required bool arriveBy,
    int numItineraries = 5,
    String? locale,
    bool useDefaultModes = false,
    bool useStrictParams = false,
  }) {
    final allParams = _buildAllParams(
      from: from,
      to: to,
      preferences: preferences,
      dateTime: dateTime,
      arriveBy: arriveBy,
      numItineraries: numItineraries,
      locale: locale,
      useDefaultModes: useDefaultModes,
    );
    return filterMapByKeys(
      originalMap: allParams,
      allowedKeys: useStrictParams ? strictAllowedKeys : planAllowedKeys,
    );
  }

  /// Build variables for the modes transport (walk/bike/car) query.
  static Map<String, dynamic> buildModesTransportVariables({
    required TrufiLocation from,
    required TrufiLocation to,
    required StadtnaviOtpPreferences preferences,
    required DateTime? dateTime,
    required bool arriveBy,
    String? locale,
  }) {
    final allParams = _buildAllParams(
      from: from,
      to: to,
      preferences: preferences,
      dateTime: dateTime,
      arriveBy: arriveBy,
      locale: locale,
    );
    return filterMapByKeys(
      originalMap: allParams,
      allowedKeys: modesTransportAllowedKeys,
    );
  }

  /// Core method – builds ALL possible query parameters.
  ///
  /// Callers filter this map down to only the keys their query needs.
  static Map<String, dynamic> _buildAllParams({
    required TrufiLocation from,
    required TrufiLocation to,
    required StadtnaviOtpPreferences preferences,
    required DateTime? dateTime,
    required bool arriveBy,
    int numItineraries = 5,
    String? locale,
    bool useDefaultModes = false,
  }) {
    final config = ConfigDefault.value;
    final defaultSettings = config.defaultSettings;
    final settings = _getSettings(preferences: preferences);
    final intermediatePlaces = <LatLng>[];

    final modesOrDefault =
        useDefaultModes
            ? ModeUtils.getDefaultModes(config)
                .map((mode) => ModeUtils.getOTPMode(config, mode))
                .whereType<String>()
                .toList()
            : ModeUtils.filterModes(
              config,
              ModeUtils.getModes(
                config,
                preferences.transportModes.map((e) => e.name).toList(),
                preferences.allowedVehicleRentalNetworks,
              ),
              LatLng(from.latitude, from.longitude),
              LatLng(from.latitude, from.longitude),
              intermediatePlaces,
            ).whereType<String>().toList();

    final availableVehicleRentalNetworks = CityBikeUtils.getDefaultNetworks(
      config,
    );

    final allowedVehicleRentalNetworks =
        settings['allowedVehicleRentalNetworks'] as List<String>;
    final lowerCasedAllowedVehicleRentalNetworks =
        allowedVehicleRentalNetworks.map((network) => network.toLowerCase());

    final allowedVehicleRentalNetworksMapped =
        allowedVehicleRentalNetworks.isNotEmpty
            ? availableVehicleRentalNetworks
                .where(
                  (network) =>
                      allowedVehicleRentalNetworks.contains(network) ||
                      lowerCasedAllowedVehicleRentalNetworks.contains(
                        network.toLowerCase(),
                      ),
                )
                .toList()
            : (config.transportModes['citybike']?.defaultValue ?? false)
            ? CityBikeUtils.getDefaultNetworks(config)
            : <String>[];

    final modesWithoutBikeRent =
        modesOrDefault
            .where((mode) => mode != "BICYCLE_RENT")
            .whereType<String>()
            .toList();

    final linearDistance = estimateDistance(from.latLng, to.latLng);

    final includeBikeRentSuggestions =
        (settings['allowedVehicleRentalFormFactors'] as Set<String>).contains(
          'bicycle',
        );

    final walkReluctance =
        useDefaultModes
            ? defaultSettings.walkReluctance
            : settings['walkReluctance'] as double;

    final walkBoardCost =
        useDefaultModes
            ? defaultSettings.walkBoardCost
            : settings['walkBoardCost'] as int;

    final formattedModes = ModeUtils.modesAsOTPModes(modesWithoutBikeRent);

    final includeBikeSuggestions =
        (settings['includeBikeSuggestions'] as bool?) ??
        defaultSettings.includeBikeSuggestions;

    return <String, dynamic>{
      'fromPlace': parsePlace(from),
      'toPlace': parsePlace(to),
      'intermediatePlaces': const [],
      'numItineraries': numItineraries,
      'modes': formattedModes,
      'date': parseDateFormat(dateTime),
      'time': parseTime(dateTime),
      'walkReluctance': walkReluctance,
      'walkBoardCost': walkBoardCost,
      'minTransferTime': config.minTransferTime,
      'walkSpeed': settings['walkSpeed'],
      'wheelchair': preferences.wheelchair,
      'ticketTypes': null,
      'arriveBy': arriveBy,
      'transferPenalty': config.transferPenalty,
      'bikeSpeed': settings['bikeSpeed'],
      'optimize':
          settings['includeBikeSuggestions']
              ? config.defaultSettings.optimize
              : config.optimize,
      'triangle': {
        'safetyFactor': config.defaultSettings.safetyFactor,
        'slopeFactor': config.defaultSettings.slopeFactor,
        'timeFactor': config.defaultSettings.timeFactor,
      },
      'itineraryFiltering': config.itineraryFiltering,
      'unpreferred': null,
      'allowedVehicleRentalNetworks': allowedVehicleRentalNetworksMapped,
      'locale': locale ?? 'en',
      'modeWeight': null,
      'searchWindow': 21600,
      // Extra params for modes transport query
      'shouldMakeWalkQuery':
          !preferences.wheelchair &&
          linearDistance < config.suggestWalkMaxDistance,
      'shouldMakeBikeQuery':
          !preferences.wheelchair &&
          linearDistance < config.suggestBikeMaxDistance &&
          includeBikeSuggestions,
      'shouldMakeScooterQuery':
          !preferences.wheelchair &&
          (settings['allowedVehicleRentalFormFactors'] as Set<String>)
              .contains('scooter'),
      'shouldMakeCarQuery': _getShouldMakeCarQuery(
        linearDistance: linearDistance,
        config: config,
        settings: settings,
        defaultSettings: defaultSettings,
      ),
      'shouldMakeCarRentalQuery': _getShouldMakeCarRentalQuery(
        linearDistance,
        config,
        settings,
      ),
      'shouldMakeParkRideQuery': _getShouldMakeParkRideQuery(
        linearDistance,
        config,
        settings,
        defaultSettings,
      ),
      'shouldMakeOnDemandTaxiQuery': false,
      'showBikeAndPublicItineraries':
          !preferences.wheelchair &&
          linearDistance >= config.suggestBikeAndPublicMinDistance &&
          modesOrDefault.length > 1 &&
          includeBikeSuggestions,
      'showBikeRentAndPublicItineraries':
          !preferences.wheelchair &&
          linearDistance >= config.suggestBikeAndParkMinDistance &&
          modesOrDefault.length > 1 &&
          includeBikeRentSuggestions,
      'showBikeAndParkItineraries':
          !preferences.wheelchair &&
          config.showBikeAndParkItineraries &&
          linearDistance >= config.suggestBikeAndParkMinDistance &&
          modesOrDefault.length > 1 &&
          includeBikeSuggestions,
      'bikeAndPublicModes': [
        {'mode': 'BICYCLE'},
        ...ModeUtils.modesAsOTPModes(
          ModeUtils.getBicycleCompatibleModes(config, modesOrDefault),
        ),
      ],
      'bikeRentAndPublicModes': [
        {'mode': 'BICYCLE', 'qualifier': 'RENT'},
        ...ModeUtils.modesAsOTPModes(
          ModeUtils.getBicycleCompatibleModes(config, modesOrDefault),
        ),
      ],
      'onDemandTaxiModes': [
        {'mode': 'FLEX', 'qualifier': 'DIRECT'},
        {'mode': 'FLEX', 'qualifier': 'ACCESS'},
        {'mode': 'FLEX', 'qualifier': 'EGRESS'},
        ...ModeUtils.modesAsOTPModes(
          ModeUtils.filterModes(
            config,
            ['RAIL', 'BUS', 'WALK'],
            from.latLng,
            to.latLng,
            intermediatePlaces,
          ),
        ),
      ],
      'bikeParkModes': [
        {'mode': 'BICYCLE', 'qualifier': 'PARK'},
        ...formattedModes,
      ],
      'scooterRentAndPublicModes': [
        {'mode': 'SCOOTER', 'qualifier': 'RENT'},
        ...ModeUtils.modesAsOTPModes(
          ModeUtils.getBicycleCompatibleModes(config, modesOrDefault),
        ),
      ],
      'carParkModes': [parseCarMode(to.latLng)],
      'carRentalModes': [
        {'mode': 'CAR', 'qualifier': 'RENT'},
      ],
      'parkRideModes': [
        {'mode': 'CAR', 'qualifier': 'PARK'},
        ...ModeUtils.modesAsOTPModes(
          ModeUtils.filterModes(
            config,
            ['BUS', 'RAIL', 'SUBWAY'],
            from.latLng,
            to.latLng,
            intermediatePlaces,
          ),
        ),
      ],
    };
  }

  /// Convert [StadtnaviOtpPreferences] into a settings map
  /// (same format as the former `GraphQLPlanRepository.getSettings()`).
  static Map<String, dynamic> _getSettings({
    required StadtnaviOtpPreferences preferences,
  }) {
    final defaultSettings = ConfigDefault.value.defaultSettings;
    final defaultOptions = ConfigDefault.value.defaultOptions;
    return <String, dynamic>{
      'walkSpeed': ConfigUtils.findNearestOption(
        preferences.walkSpeed.value,
        defaultOptions.walkSpeed,
      ),
      'walkReluctance':
          preferences.avoidWalking
              ? defaultOptions.walkReluctance.least
              : defaultSettings.walkReluctance,
      'walkBoardCost':
          preferences.avoidTransfers
              ? ConfigDefault.value.walkBoardCostHigh
              : defaultSettings.walkBoardCost,
      'modes': null,
      'accessibilityOption': preferences.wheelchair,
      'ticketTypes': null,
      'bikeSpeed': ConfigUtils.findNearestOption(
        preferences.bikeSpeed.value,
        defaultOptions.bikeSpeed,
      ),
      'allowedVehicleRentalNetworks':
          preferences.allowedVehicleRentalNetworks,
      'allowedVehicleRentalFormFactors':
          preferences.allowedVehicleRentalFormFactors,
      'includeBikeSuggestions': preferences.includeBikeSuggestions,
      'includeCarSuggestions': preferences.includeCarSuggestions,
      'includeParkAndRideSuggestions':
          preferences.includeParkAndRideSuggestions,
      'bicycleParkingFilter': preferences.bicycleParkingFilter,
      'showBikeAndParkItineraries': preferences.showBikeAndParkItineraries,
    };
  }

  static bool _getShouldMakeCarQuery({
    required double linearDistance,
    required ConfigData config,
    required Map<String, dynamic> settings,
    required DefaultSettings defaultSettings,
  }) {
    // Note: isFreeParkToCarPark/shouldMakeAllQuery logic was previously
    // driven by SettingFetchState. Since the provider always uses the
    // "all query" path, we simplify to shouldMakeAllQuery = true.
    return linearDistance > config.suggestCarMinDistance &&
        (settings['includeCarSuggestions'] ??
            defaultSettings.includeCarSuggestions);
  }

  static bool _getShouldMakeCarRentalQuery(
    double linearDistance,
    ConfigData config,
    Map<String, dynamic> settings,
  ) {
    return linearDistance > config.suggestCarMinDistance &&
        (settings['allowedVehicleRentalFormFactors'] as Set<String>).contains(
          'car',
        );
  }

  static bool _getShouldMakeParkRideQuery(
    double linearDistance,
    ConfigData config,
    Map<String, dynamic> settings,
    DefaultSettings defaultSettings,
  ) {
    return linearDistance > config.suggestCarMinDistance &&
        (settings['includeParkAndRideSuggestions'] ??
            defaultSettings.includeParkAndRideSuggestions);
  }

  /// Filter a map to only include entries whose keys are in [allowedKeys].
  static Map<String, dynamic> filterMapByKeys({
    required Map<String, dynamic> originalMap,
    required List<String> allowedKeys,
  }) {
    return Map.fromEntries(
      originalMap.entries.where((entry) => allowedKeys.contains(entry.key)),
    );
  }
}
