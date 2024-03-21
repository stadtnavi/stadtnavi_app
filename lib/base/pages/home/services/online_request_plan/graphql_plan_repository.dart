import 'dart:async';

import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/utils/graphql_client/graphql_client.dart';
import 'package:trufi_core/base/utils/graphql_client/graphql_utils.dart';

import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
import 'package:stadtnavi_core/base/models/othermodel/modes_transport.dart';
import 'package:stadtnavi_core/base/models/othermodel/plan.dart';
import 'package:stadtnavi_core/base/models/utils/geo_utils.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';

import 'graphql_operation/fragments2/plan_fragment.dart' as plan_fragment;
import 'graphql_operation/queries2/modes_plan_queries.dart'
    as modes_plan_queries;
import 'graphql_operation/queries2/plan_queries.dart' as plan_queries;
import 'graphql_operation/query_utils.dart';

class GraphQLPlanRepository {
  final GraphQLClient client;

  GraphQLPlanRepository(String endpoint) : client = getClient(endpoint);

  Future<Plan> fetchPlanAdvanced({
    required TrufiLocation fromLocation,
    required TrufiLocation toLocation,
    required SettingFetchState advancedOptions,
    int numItineraries = 10,
    String? locale,
    bool defaultFecth = false,
  }) async {
    final transportsMode =
        defaultFecth ? defaultTransportModes : advancedOptions.transportModes;
    final QueryOptions planAdvancedQuery = QueryOptions(
      document: addFragments(parseString(plan_queries.advancedPlanQuery), [
        plan_fragment.planFragment,
      ]),
      variables: <String, dynamic>{
        'fromPlace': parsePlace(fromLocation),
        'toPlace': parsePlace(toLocation),
        'intermediatePlaces': const [],
        'numItineraries': numItineraries,
        'transportModes': parseTransportModes(transportsMode),
        "date": parseDateFormat(advancedOptions.date),
        'time': parseTime(advancedOptions.date),
        'walkReluctance': advancedOptions.avoidWalking ? 5 : 2,
        'walkBoardCost': advancedOptions.avoidTransfers
            ? WalkBoardCost.walkBoardCostHigh.value
            : WalkBoardCost.defaultCost.value,
        'minTransferTime': 120,
        'walkSpeed': advancedOptions.typeWalkingSpeed.value,
        'maxWalkDistance': 15000,
        'wheelchair': advancedOptions.wheelchair,
        'ticketTypes': null,
        'disableRemainingWeightHeuristic':
            transportsMode.map((e) => e.name).contains('BICYCLE'),
        'arriveBy': advancedOptions.arriveBy,
        'transferPenalty': 0,
        'bikeSpeed': advancedOptions.typeBikingSpeed.value,
        'optimize': advancedOptions.includeBikeSuggestions
            ? OptimizeType.triangle.name
            : OptimizeType.quick.name,
        'triangle': advancedOptions.includeBikeSuggestions
            ? OptimizeType.triangle.value
            : OptimizeType.quick.value,
        'itineraryFiltering': 1.5,
        'unpreferred': const {'useUnpreferredRoutesPenalty': 1200},
        'allowedVehicleRentalNetworks':
            parseBikeRentalNetworks(advancedOptions.bikeRentalNetworks),
        'locale': locale ?? 'de',
      },
    );
    final planAdvancedData = await client.query(planAdvancedQuery);
    if (planAdvancedData.hasException && planAdvancedData.data == null) {
      throw planAdvancedData.exception!.graphqlErrors.isNotEmpty
          ? Exception("Bad request")
          : Exception("Internet no connection");
    }
    if (planAdvancedData.source?.isEager ?? false) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    final planData = Plan.fromMap(
        planAdvancedData.data!['viewer']['plan'] as Map<String, dynamic>);
    return planData;
  }

// GraphQLError (GraphQLError(message: Validation error of type UndefinedFragment: Undefined fragment serviceTimeRangeFragment @ 'serviceTimeRange', locations: [ErrorLocation(line: 8, column: 5)], path: null, extensions: {classification: ValidationError}))
  Future<ModesTransport> fetchWalkBikePlanQuery({
    required TrufiLocation fromLocation,
    required TrufiLocation toLocation,
    required SettingFetchState advancedOptions,
    String? locale,
  }) async {
    final linearDistance =
        estimateDistance(fromLocation.latLng, toLocation.latLng);
    final dateNow = DateTime.now();
    final date = advancedOptions.date ?? dateNow;
    final shouldMakeAllQuery = !advancedOptions.isFreeParkToCarPark &&
        !advancedOptions.isFreeParkToParkRide;

    final QueryOptions walkBikePlanQuery = QueryOptions(
        document: addFragments(
          parseString(modes_plan_queries.summaryModesPlanQuery),
          [plan_fragment.planFragment],
        ),
        variables: <String, dynamic>{
          'fromPlace': parsePlace(fromLocation),
          'toPlace': parsePlace(toLocation),
          'intermediatePlaces': const [],
          'date': parseDateFormat(date),
          'time': parseTime(date),
          'walkReluctance': advancedOptions.avoidWalking ? 5 : 2,
          'walkBoardCost': advancedOptions.avoidTransfers
              ? WalkBoardCost.walkBoardCostHigh.value
              : WalkBoardCost.defaultCost.value,
          'minTransferTime': 120,
          'walkSpeed': advancedOptions.typeWalkingSpeed.value,
          'wheelchair': advancedOptions.wheelchair,
          'ticketTypes': null,
          'disableRemainingWeightHeuristic': advancedOptions.transportModes
              .map((e) => '${e.name}_${e.qualifier ?? ''}')
              .contains('BICYCLE_RENT'),
          'arriveBy': advancedOptions.arriveBy,
          'transferPenalty': 0,
          'bikeSpeed': advancedOptions.typeBikingSpeed.value,
          'optimize': advancedOptions.includeBikeSuggestions
              ? OptimizeType.triangle.name
              : OptimizeType.greenWays.name,
          'triangle': {...OptimizeType.triangle.value!},
          'itineraryFiltering': 1.5,
          'unpreferred': const {'useUnpreferredRoutesPenalty': 1200},
          'locale': locale ?? 'de',
          'bikeAndPublicMaxWalkDistance':
              SettingFetchState.bikeAndPublicMaxWalkDistance,
          'bikeAndPublicModes':
              parseBikeAndPublicModes(advancedOptions.transportModes),
          'bikeParkModes': parsebikeParkModes(advancedOptions.transportModes),
          'carMode': parseCarMode(toLocation.latLng),
          'bikeandPublicDisableRemainingWeightHeuristic': false,
          // Always show the walk plan to the user,
          'shouldMakeWalkQuery': shouldMakeAllQuery &&
              !advancedOptions.wheelchair &&
              // linearDistance < SettingFetchState.maxWalkDistance,
              true,
          'shouldMakeBikeQuery': shouldMakeAllQuery &&
              !advancedOptions.wheelchair &&
              linearDistance < SettingFetchState.suggestBikeMaxDistance &&
              advancedOptions.includeBikeSuggestions,
          'shouldMakeCarQuery':
              (advancedOptions.isFreeParkToCarPark || shouldMakeAllQuery) &&
                  advancedOptions.includeCarSuggestions &&
                  linearDistance > SettingFetchState.suggestCarMinDistance,
          'shouldMakeParkRideQuery':
              (advancedOptions.isFreeParkToParkRide || shouldMakeAllQuery) &&
                  advancedOptions.includeParkAndRideSuggestions &&
                  linearDistance > SettingFetchState.suggestCarMinDistance,
          'shouldMakeOnDemandTaxiQuery': shouldMakeAllQuery && date.hour > 21 ||
              (date.hour == 21 && date.minute == 0) ||
              date.hour < 5 ||
              (date.hour == 5 && date.minute == 0),
          'showBikeAndParkItineraries': shouldMakeAllQuery &&
              !advancedOptions.wheelchair &&
              advancedOptions.includeBikeSuggestions,
          'showBikeAndPublicItineraries': shouldMakeAllQuery &&
              !advancedOptions.wheelchair &&
              advancedOptions.includeBikeSuggestions,
          'useVehicleParkingAvailabilityInformation':
              date.difference(dateNow).inMinutes <= 15,
          'bannedVehicleParkingTags': shouldMakeAllQuery
              ? SettingFetchState.parkAndRideBannedVehicleParkingTags
              : [
                  'state:few',
                  ...SettingFetchState.parkAndRideBannedVehicleParkingTags
                ],
        });
    final walkBikePlanData = await client.query(walkBikePlanQuery);
    if (walkBikePlanData.hasException && walkBikePlanData.data == null) {
      throw walkBikePlanData.exception!.graphqlErrors.isNotEmpty
          ? Exception("Bad request")
          : Exception("Internet no connection");
    }
    final modesTransportData = ModesTransport.fromJson(walkBikePlanData.data!);

    return modesTransportData;
  }
}
