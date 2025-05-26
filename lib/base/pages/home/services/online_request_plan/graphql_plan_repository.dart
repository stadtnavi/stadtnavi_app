import 'dart:async';
import 'package:latlong2/latlong.dart';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:stadtnavi_core/base/models/utils/mode_utils.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/city_bike_utils.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/default_settings.dart';
import 'package:stadtnavi_core/configuration/config_default/config_utils.dart';
import 'package:stadtnavi_core/configuration/graphql_client.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/utils/graphql_client/graphql_utils.dart';

import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/othermodel/modes_transport.dart';
import 'package:stadtnavi_core/base/models/othermodel/plan.dart';
import 'package:stadtnavi_core/base/models/utils/geo_utils.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';

import 'graphql_operation/fragments/plan_fragment.dart' as plan_fragment;
import 'graphql_operation/queries/modes_plan_queries.dart'
    as modes_plan_queries;
import 'graphql_operation/queries/plan_queries.dart' as plan_queries;
import 'graphql_operation/query_utils.dart';

class GraphQLPlanRepository {
  final String endpoint;
  GraphQLClient client;

  GraphQLPlanRepository({required this.endpoint})
      : client = getClient(
          endpoint,
        );
  static const maxRetries = 5;

  Future<Plan> fetchPlanAdvanced({
    required TrufiLocation fromLocation,
    required TrufiLocation toLocation,
    required SettingFetchState advancedOptions,
    int numItineraries = 5,
    String? locale,
    bool useDefaultModes = false,
  }) async {
    client = updateClient(
      graphQLClient: client,
      endpoint: endpoint,
      langugeEncode: locale,
    );

    final QueryOptions planAdvancedQuery = QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: addFragments(parseString(plan_queries.planQuery), [
        plan_fragment.itineraryPageViewer,
        plan_fragment.itineraryPageServiceTimeRange,
        // level 1
        plan_fragment.itineraryListContainerPlan,
        plan_fragment.itineraryDetailsPlan,
        plan_fragment.itineraryDetailsItinerary,
        plan_fragment.itineraryListContainerItineraries,
        plan_fragment.itineraryLineLegs,
        plan_fragment.routeLinePattern,
        // level 2
        plan_fragment.itineraryLineLegs,
        plan_fragment.routeLinePattern,
        plan_fragment.legAgencyInfoLeg,
        plan_fragment.itineraryListItineraries,
        // level 3
        plan_fragment.stopCardHeaderContainerStop,
      ]),
      variables: filterMapByKeys(
        originalMap: _prepareQueryParams(
          fromLocation: fromLocation,
          toLocation: toLocation,
          advancedOptions: advancedOptions,
          numItineraries: numItineraries,
          locale: locale,
          useDefaultModes: useDefaultModes,
        ),
        allowedKeys: [
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
        ],
      ),
    );

    int attempt = 0;
    QueryResult<Object?>? planAdvancedData;
    while (attempt < maxRetries) {
      try {
        planAdvancedData = await client.query(planAdvancedQuery);
        if (!(planAdvancedData.hasException && planAdvancedData.data == null)) {
          break;
        } else {
          // print("Request failed (status ${response.statusCode}), retrying...");
        }
      } catch (e) {
        // print("Error fetching image (attempt ${attempt + 1}): $e");
      }

      attempt++;
      if (attempt < maxRetries) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    if (planAdvancedData == null) {
      throw Exception("Failed to load intineraries");
    }
    if (planAdvancedData.hasException && planAdvancedData.data == null) {
      throw planAdvancedData.exception!.graphqlErrors.isNotEmpty
          ? Exception("Bad request")
          : Exception("Error connection");
    }

    if (planAdvancedData.source?.isEager ?? false) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    final planData = Plan.fromMap(
        planAdvancedData.data!['viewer']['plan'] as Map<String, dynamic>);
    return planData;
  }

  Future<ModesTransport> fetchWalkBikePlanQuery({
    required TrufiLocation fromLocation,
    required TrufiLocation toLocation,
    required SettingFetchState advancedOptions,
    required String locale,
  }) async {
    client = updateClient(
      graphQLClient: client,
      endpoint: endpoint,
      langugeEncode: locale,
    );
    final QueryOptions walkBikePlanQuery = QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: addFragments(parseString(modes_plan_queries.walkAndBikeQuery), [
        plan_fragment.itineraryListContainerPlan,
        plan_fragment.itineraryDetailsPlan,
        plan_fragment.itineraryDetailsItinerary,
        plan_fragment.itineraryListContainerItineraries,
        plan_fragment.itineraryLineLegs,
        plan_fragment.routeLinePattern,
        plan_fragment.itineraryListItineraries,
        // level 2
        plan_fragment.legAgencyInfoLeg,
        // level 3
        plan_fragment.stopCardHeaderContainerStop,
      ]),
      variables: filterMapByKeys(
        originalMap: _prepareQueryParams(
          fromLocation: fromLocation,
          toLocation: toLocation,
          advancedOptions: advancedOptions,
          locale: locale,
        ),
        allowedKeys: [
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
          'triangle', // Only for modes
          'itineraryFiltering',
          'unpreferred',
          'locale',
          'shouldMakeWalkQuery', // Only for modes
          'shouldMakeBikeQuery', // Only for modes
          'shouldMakeCarQuery', // Only for modes
          'shouldMakeParkRideQuery', // Only for modes
          'shouldMakeOnDemandTaxiQuery', // Only for modes
          'showBikeAndPublicItineraries', // Only for modes
          'showBikeRentAndPublicItineraries', // Only for modes
          'showBikeAndParkItineraries', // Only for modes
          'shouldMakeScooterQuery', // Only for modes
          'bikeAndPublicModes', // Only for modes
          'bikeRentAndPublicModes', // Only for modes
          'scooterRentAndPublicModes', // Only for modes
          'onDemandTaxiModes', // Only for modes
          'bikeParkModes', // Only for modes
          'carParkModes', // Only for modes
          'carRentalModes', // Only for modes
          'parkRideModes', // Only for modes
          'allowedVehicleRentalNetworks',
        ],
      ),
      // TODO review for delete
      // variables: <String, dynamic>{
      //   'fromPlace': parsePlace(fromLocation),
      //   'toPlace': parsePlace(toLocation),
      //   'intermediatePlaces': const [],
      //   'date': parseDateFormat(date),
      //   'time': parseTime(date),
      //   'walkReluctance': advancedOptions.avoidWalking ? 5 : 2,
      //   'walkBoardCost': advancedOptions.avoidTransfers
      //       ? WalkBoardCostEnum.walkBoardCostHigh.value
      //       : WalkBoardCostEnum.defaultCost.value,
      //   'minTransferTime': 120,
      //   'walkSpeed': advancedOptions.walkSpeed.value,
      //   'wheelchair': advancedOptions.wheelchair,
      //   'ticketTypes': null,
      //   'disableRemainingWeightHeuristic': advancedOptions.transportModes
      //       .map((e) => '${e.name}_${e.qualifier ?? ''}')
      //       .contains('BICYCLE_RENT'),
      //   'arriveBy': advancedOptions.arriveBy,
      //   'transferPenalty': 0,
      //   'bikeSpeed': advancedOptions.bikeSpeed.value,
      //   'optimize': advancedOptions.includeBikeSuggestions
      //       ? OptimizeType.triangle.name
      //       : OptimizeType.greenWays.name,
      //   'triangle': {...OptimizeType.triangle.value!},
      //   'itineraryFiltering': 1.5,
      //   'unpreferred': const {'useUnpreferredRoutesPenalty': 1200},
      //   'locale': locale,
      //   'bikeAndPublicMaxWalkDistance':
      //       SettingFetchState.bikeAndPublicMaxWalkDistance,
      //   'bikeAndPublicModes':
      //       parseBikeAndPublicModes(advancedOptions.transportModes),
      //   'bikeParkModes': parsebikeParkModes(advancedOptions.transportModes),
      //   'carMode': parseCarMode(toLocation.latLng),
      //   'bikeandPublicDisableRemainingWeightHeuristic': false,
      //   // Always show the walk plan to the user,
      //   'shouldMakeWalkQuery': shouldMakeAllQuery &&
      //       !advancedOptions.wheelchair &&
      //       // linearDistance < SettingFetchState.maxWalkDistance,
      //       true,
      //   'shouldMakeBikeQuery': shouldMakeAllQuery &&
      //       !advancedOptions.wheelchair &&
      //       linearDistance < SettingFetchState.suggestBikeMaxDistance &&
      //       advancedOptions.includeBikeSuggestions,
      //   'shouldMakeCarQuery':
      //       (advancedOptions.isFreeParkToCarPark || shouldMakeAllQuery) &&
      //           advancedOptions.includeCarSuggestions &&
      //           linearDistance > SettingFetchState.suggestCarMinDistance,
      //   'shouldMakeParkRideQuery':
      //       (advancedOptions.isFreeParkToParkRide || shouldMakeAllQuery) &&
      //           advancedOptions.includeParkAndRideSuggestions &&
      //           linearDistance > SettingFetchState.suggestCarMinDistance,
      //   'shouldMakeOnDemandTaxiQuery': shouldMakeAllQuery && date.hour > 21 ||
      //       (date.hour == 21 && date.minute == 0) ||
      //       date.hour < 5 ||
      //       (date.hour == 5 && date.minute == 0),
      //   'showBikeAndParkItineraries': shouldMakeAllQuery &&
      //       !advancedOptions.wheelchair &&
      //       advancedOptions.includeBikeSuggestions,
      //   'showBikeAndPublicItineraries': shouldMakeAllQuery &&
      //       !advancedOptions.wheelchair &&
      //       advancedOptions.includeBikeSuggestions,
      //   'useVehicleParkingAvailabilityInformation':
      //       date.difference(dateNow).inMinutes <= 15,
      //   'bannedVehicleParkingTags': shouldMakeAllQuery
      //       ? SettingFetchState.parkAndRideBannedVehicleParkingTags
      //       : [
      //           'state:few',
      //  2         ...SettingFetchState.parkAndRideBannedVehicleParkingTags
      //         ],
      // },
    );

    int attempt = 0;
    QueryResult<Object?>? walkBikePlanData;
    while (attempt < maxRetries) {
      try {
        walkBikePlanData = await client.query(walkBikePlanQuery);
        if (!(walkBikePlanData.hasException && walkBikePlanData.data == null)) {
          break;
        } else {
          // print("Request failed (status ${response.statusCode}), retrying...");
        }
      } catch (e) {
        // print("Error fetching image (attempt ${attempt + 1}): $e");
      }

      attempt++;
      if (attempt < maxRetries) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    if (walkBikePlanData == null) {
      throw Exception("Failed to load intinerary-modes");
    }
    if (walkBikePlanData.hasException && walkBikePlanData.data == null) {
      throw walkBikePlanData.exception!.graphqlErrors.isNotEmpty
          ? Exception("Bad request")
          : Exception("Error connection");
    }
    final modesTransportData = ModesTransport.fromJson(walkBikePlanData.data!);

    return modesTransportData;
  }

  Map<String, dynamic> _prepareQueryParams({
    required TrufiLocation fromLocation,
    required TrufiLocation toLocation,
    required SettingFetchState advancedOptions,
    int numItineraries = 5,
    String? locale,
    bool useDefaultModes = false,
  }) {
    final config = ConfigDefault.value;
    final shouldMakeAllQuery = !advancedOptions.isFreeParkToCarPark &&
        !advancedOptions.isFreeParkToParkRide;
    final defaultSettings = ConfigDefault.value.defaultSettings;
    final settings = getSettings(advancedOptions: advancedOptions);
    final intermediatePlaces = <LatLng>[];
    final modesOrDefault = useDefaultModes
        ? ModeUtils.getDefaultModes(ConfigDefault.value)
            .map((mode) => ModeUtils.getOTPMode(ConfigDefault.value, mode))
            .whereType<String>()
            .toList()
        : ModeUtils.filterModes(
            ConfigDefault.value,
            ModeUtils.getModes(
              config,
              advancedOptions.transportModes.map((e) => e.name).toList(),
              advancedOptions.allowedVehicleRentalNetworks,
            ),
            LatLng(fromLocation.latitude, fromLocation.longitude),
            LatLng(fromLocation.latitude, fromLocation.longitude),
            intermediatePlaces,
          ).whereType<String>().toList();

    // const defaultSettings = { ...getDefaultSettings(config) };
    final availableVehicleRentalNetworks =
        CityBikeUtils.getDefaultNetworks(ConfigDefault.value);

    final allowedVehicleRentalNetworks =
        settings['allowedVehicleRentalNetworks'] as List<String>;
    final lowerCasedAllowedVehicleRentalNetworks =
        allowedVehicleRentalNetworks.map(
      (network) => network.toLowerCase(),
    );

    // legacy settings used to set network name in uppercase in localstorage
    // Note: Both `settings.allowedVehicleRentalNetworks` and `availableVehicleRentalNetworks` might contain arbitrarily cased network "IDs"; We prefer the "most exact" match.
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

    final modesWithoutBikeRent = modesOrDefault
        .where((mode) => mode != "BICYCLE_RENT")
        .whereType<String>()
        .toList();

    final linearDistance =
        estimateDistance(fromLocation.latLng, toLocation.latLng);

    final includeBikeRentSuggestions =
        (settings['allowedVehicleRentalFormFactors'] as Set<String>).contains(
      'bicycle',
    );

    final walkReluctance = useDefaultModes
        ? defaultSettings.walkReluctance
        : settings['walkReluctance'] as double;

    final walkBoardCost = useDefaultModes
        ? defaultSettings.walkBoardCost
        : settings['walkBoardCost'] as int;

    final formattedModes = ModeUtils.modesAsOTPModes(modesWithoutBikeRent);

    final includeBikeSuggestions =
        (settings['includeBikeSuggestions'] as bool?) ??
            defaultSettings.includeBikeSuggestions;
    return <String, dynamic>{
      'fromPlace': parsePlace(fromLocation),
      'toPlace': parsePlace(toLocation),
      // TODO: Ask the web developers when intermediatePlaces is set with this data.
      'intermediatePlaces': const [],
      'numItineraries': numItineraries,
      // 'modes': parseTransportModes(transportsMode),
      'modes': formattedModes,
      "date": parseDateFormat(advancedOptions.date),
      'time': parseTime(advancedOptions.date),
      'walkReluctance': walkReluctance,
      'walkBoardCost': walkBoardCost,
      'minTransferTime': config.minTransferTime,
      'walkSpeed': settings['walkSpeed'],
      // review delete maxWalkDistance
      // 'maxWalkDistance': 15000,
      'wheelchair': advancedOptions.wheelchair,
      // review ticketTypes is always null for stadtnavi
      'ticketTypes': null,
      // review delete disableRemainingWeightHeuristic
      // 'disableRemainingWeightHeuristic':
      //     transportsMode.map((e) => e.name).contains('BICYCLE'),
      'arriveBy': advancedOptions.arriveBy,
      'transferPenalty': config.transferPenalty,
      'bikeSpeed': settings['bikeSpeed'],
      'optimize': settings['includeBikeSuggestions']
          ? config.defaultSettings.optimize
          : config.optimize,
      'triangle': {
        'safetyFactor': config.defaultSettings.safetyFactor,
        'slopeFactor': config.defaultSettings.slopeFactor,
        'timeFactor': config.defaultSettings.timeFactor,
      },
      'itineraryFiltering': config.itineraryFiltering,
      'unpreferred': null,
      // 'allowedVehicleRentalNetworks':
      //     parseBikeRentalNetworks(advancedOptions.bikeRentalNetworks),
      'allowedVehicleRentalNetworks': allowedVehicleRentalNetworksMapped,
      'locale': locale ?? 'en',
      'modeWeight': null,
      // Extra params for modes
      'shouldMakeWalkQuery': !advancedOptions.wheelchair &&
          linearDistance < config.suggestWalkMaxDistance,
      'shouldMakeBikeQuery': !advancedOptions.wheelchair &&
          linearDistance < config.suggestBikeMaxDistance &&
          includeBikeSuggestions,
      'shouldMakeScooterQuery': !advancedOptions.wheelchair &&
          ((settings['allowedVehicleRentalFormFactors'] as Set<String>)
              .contains('scooter')),
      'shouldMakeCarQuery': getShouldMakeCarQuery(
        linearDistance: linearDistance,
        config: config,
        settings: settings,
        defaultSettings: defaultSettings,
        shouldMakeAllQuery: shouldMakeAllQuery,
        isFreeParkToCarPark: advancedOptions.isFreeParkToCarPark,
      ),
      // shouldMakeCarRentalQuery not used in any query
      'shouldMakeCarRentalQuery': getShouldMakeCarRentalQuery(
        linearDistance,
        config,
        settings,
      ),
      'shouldMakeParkRideQuery': getShouldMakeParkRideQuery(
        linearDistance,
        config,
        settings,
        defaultSettings,
      ),
      // TODO shouldMakeXYZQuery and showXYZItineraries have same intend, harmonize
      // In bbnavi, we include Flex routing in the "default" public routing mode.
      'shouldMakeOnDemandTaxiQuery': false,
      'showBikeAndPublicItineraries': !advancedOptions.wheelchair &&
          linearDistance >= config.suggestBikeAndPublicMinDistance &&
          modesOrDefault.length > 1 &&
          includeBikeSuggestions,
      'showBikeRentAndPublicItineraries': !advancedOptions.wheelchair &&
          linearDistance >= config.suggestBikeAndParkMinDistance &&
          modesOrDefault.length > 1 &&
          includeBikeRentSuggestions,
      'showBikeAndParkItineraries': !advancedOptions.wheelchair &&
          config.showBikeAndParkItineraries &&
          linearDistance >= config.suggestBikeAndParkMinDistance &&
          modesOrDefault.length > 1 &&
          includeBikeSuggestions,
      //TODO review remove, Unused in all queries
      // 'bikeAndPublicMaxWalkDistance': config.suggestBikeAndPublicMaxDistance,
      'bikeAndPublicModes': [
        // with CONFIG=bbnavi, we get FLEX+ACCESS even though that doesn't make sense.
        // does BICYCLE override BUS(with FLEX+ACCESS/EGRESS) in this case?
        // does the VBB data specify if travelling with a bike is allowed?
        {'mode': 'BICYCLE'},
        ...ModeUtils.modesAsOTPModes(
          ModeUtils.getBicycleCompatibleModes(config, modesOrDefault),
        ),
      ],
      'bikeRentAndPublicModes': [
        // Apparently, including *both* `{mode: 'BICYCLE'}` and `{mode: 'BICYCLE', qualifier: 'RENT'}`
        // causes OTP to *exclude* connections that *don't* contain any `BICYCLE` leg.
        // When sending just `{mode: 'BICYCLE', qualifier: 'RENT'}`, it work as intended:
        // - include itineraries with non-rented `BICYCLE` legs
        // - include itineraries with rented `BICYCLE` legs
        // - include itineraries without any `BICYCLE` legs whatsoever
        {'mode': 'BICYCLE', 'qualifier': 'RENT'},
        ...ModeUtils.modesAsOTPModes(
          ModeUtils.getBicycleCompatibleModes(config, modesOrDefault),
        ),
      ],
      //TODO review remove, Unused in all queries
      // 'bannedBicycleParkingTags': null,
      // 'preferredBicycleParkingTags', null,
      // 'unpreferredBicycleParkingTagPenalty':
      //     config.unpreferredBicycleParkingTagPenalty,
      'onDemandTaxiModes': [
        // `filterModes` removes `FLEX_*`, so we include it manually.
        {'mode': 'FLEX', 'qualifier': 'DIRECT'},
        {'mode': 'FLEX', 'qualifier': 'ACCESS'},
        {'mode': 'FLEX', 'qualifier': 'EGRESS'},
        ...ModeUtils.modesAsOTPModes(
          ModeUtils.filterModes(
            config,
            ['RAIL', 'BUS', 'WALK'],
            fromLocation.latLng,
            toLocation.latLng,
            intermediatePlaces,
          ),
        ),
      ],
      'bikeParkModes': [
        {'mode': 'BICYCLE', 'qualifier': 'PARK'},
        ...formattedModes
      ],
      'scooterRentAndPublicModes': [
        {'mode': 'SCOOTER', 'qualifier': 'RENT'},
        ...ModeUtils.modesAsOTPModes(
            ModeUtils.getBicycleCompatibleModes(config, modesOrDefault)),
      ],
      'carParkModes': [parseCarMode(toLocation.latLng)],
      'carRentalModes': [
        {'mode': 'CAR', 'qualifier': 'RENT'}
      ],
      'parkRideModes': [
        {'mode': 'CAR', 'qualifier': 'PARK'},
        ...ModeUtils.modesAsOTPModes(
          ModeUtils.filterModes(
            config,
            ['BUS', 'RAIL', 'SUBWAY'],
            fromLocation.latLng,
            toLocation.latLng,
            intermediatePlaces,
          ),
        ),
      ],
    };
  }

  Map<String, dynamic> getSettings({
    required SettingFetchState advancedOptions,
  }) {
    final defaultSettings = ConfigDefault.value.defaultSettings;
    final defaultOptions = ConfigDefault.value.defaultOptions;
    final settings = <String, dynamic>{
      'walkSpeed': ConfigUtils.findNearestOption(
        advancedOptions.walkSpeed.value,
        defaultOptions.walkSpeed,
      ),
      'walkReluctance': advancedOptions.avoidWalking
          ? defaultOptions.walkReluctance.least
          : defaultSettings.walkReluctance,
      'walkBoardCost': advancedOptions.avoidTransfers
          ? ConfigDefault.value.walkBoardCostHigh
          : defaultSettings.walkBoardCost,
      'modes': null,
      'accessibilityOption': advancedOptions.wheelchair,
      // TODO: Not configured in the web version. This is a new feature for mobile, currently set to null for all versions.
      'ticketTypes': null,
      'bikeSpeed': ConfigUtils.findNearestOption(
        advancedOptions.bikeSpeed.value,
        defaultOptions.bikeSpeed,
      ),
      // this is for Your rental modes and operators
      'allowedVehicleRentalNetworks':
          advancedOptions.allowedVehicleRentalNetworks,
      'allowedVehicleRentalFormFactors':
          advancedOptions.allowedVehicleRentalFormFactors,
      'includeBikeSuggestions': advancedOptions.includeBikeSuggestions,
      'includeCarSuggestions': advancedOptions.includeCarSuggestions,
      'includeParkAndRideSuggestions':
          advancedOptions.includeParkAndRideSuggestions,
      // Not Used
      // 'useVehicleParkingAvailabilityInformation':advancedOptions.useVehicleParkingAvailabilityInformation,
      'bicycleParkingFilter': advancedOptions.bicycleParkingFilter,
      'showBikeAndParkItineraries': advancedOptions.showBikeAndParkItineraries,
    };
    return settings;
  }

  bool getShouldMakeCarQuery({
    required double linearDistance,
    required ConfigData config,
    required Map<String, dynamic> settings,
    required DefaultSettings defaultSettings,
    required bool shouldMakeAllQuery,
    required bool isFreeParkToCarPark,
  }) {
    return (isFreeParkToCarPark || shouldMakeAllQuery) &&
        linearDistance > config.suggestCarMinDistance &&
        (settings['includeCarSuggestions'] ??
            defaultSettings.includeCarSuggestions);
  }

  bool getShouldMakeCarRentalQuery(
    double linearDistance,
    ConfigData config,
    Map<String, dynamic> settings,
  ) {
    return (linearDistance > config.suggestCarMinDistance &&
        (settings['allowedVehicleRentalFormFactors'] as Set<String>)
            .contains('car'));
  }

  bool getShouldMakeParkRideQuery(
    double linearDistance,
    ConfigData config,
    Map<String, dynamic> settings,
    DefaultSettings defaultSettings,
  ) {
    return linearDistance > config.suggestCarMinDistance &&
        (settings['includeParkAndRideSuggestions'] ??
            defaultSettings.includeParkAndRideSuggestions);
  }

  Map<String, dynamic> filterMapByKeys({
    required Map<String, dynamic> originalMap,
    required List<String> allowedKeys,
  }) {
    return Map.fromEntries(
        originalMap.entries.where((entry) => allowedKeys.contains(entry.key)));
  }
}
