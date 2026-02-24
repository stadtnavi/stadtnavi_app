import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:stadtnavi_core/base/otp/enums/plan_info_box.dart';
import 'package:stadtnavi_core/base/otp/entities/plan_entity.dart';
import 'package:stadtnavi_core/base/otp/providers/stadtnavi_routing_provider.dart';
import 'package:stadtnavi_core/base/otp/utils/graphql_utils.dart';
import 'package:stadtnavi_core/configuration/graphql_client.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

import 'stadtnavi_otp_fragments.dart' as fragments;
import 'stadtnavi_otp_preferences.dart';
import 'stadtnavi_otp_query_builder.dart';
import 'stadtnavi_otp_queries.dart' as queries;
import 'stadtnavi_otp_response_parser.dart';

/// OTP GraphQL provider for stadtnavi.
///
/// Implements [IStadtnaviRoutingProvider] using the same GraphQL endpoint
/// and query structure as the legacy `OnlineGraphQLRepository` +
/// `GraphQLPlanRepository`, but with clean separation of concerns.
class StadtnaviOtpProvider extends IStadtnaviRoutingProvider {
  StadtnaviOtpProvider({
    required this.otpEndpoint,
    required this.preferences,
  });

  final String otpEndpoint;
  final StadtnaviOtpPreferences preferences;

  GraphQLClient? _client;
  bool _initialized = false;
  static const _maxRetries = 5;

  @override
  String get id => 'stadtnavi_otp';

  @override
  String get name => 'Stadtnavi OTP';

  @override
  bool get requiresInternet => true;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _client = getClient(otpEndpoint);
    await preferences.initialize();
    _initialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) await initialize();
  }

  @override
  Future<PlanEntity> fetchPlan({
    required TrufiLocation from,
    required TrufiLocation to,
    required String locale,
    required DateTime dateTime,
    bool arriveBy = false,
    int numItineraries = 5,
  }) async {
    await _ensureInitialized();
    _updateClientLocale(locale);

    // First attempt with user-selected modes
    var planEntity = await _fetchAndParsePlan(
      from: from,
      to: to,
      locale: locale,
      dateTime: dateTime,
      arriveBy: arriveBy,
      numItineraries: numItineraries,
      useDefaultModes: false,
      useStrictParams: false,
    );

    final mainFetchIsEmpty = planEntity.itineraries?.isEmpty ?? true;

    // Fallback to default modes if no results
    if (mainFetchIsEmpty) {
      planEntity = await _fetchAndParsePlan(
        from: from,
        to: to,
        locale: locale,
        dateTime: dateTime,
        arriveBy: arriveBy,
        numItineraries: numItineraries,
        useDefaultModes: true,
        useStrictParams: false,
      );
    }

    // Remove walk-only itineraries unless that's all we have
    if (!planEntity.isOnlyWalk) {
      planEntity = planEntity.copyWith(
        itineraries: planEntity.itineraries
            ?.where((itinerary) => !itinerary.legs.every(
                  (leg) => leg.transportMode == TransportMode.walk,
                ))
            .toList(),
      );
    }

    return planEntity.copyWith(
      planInfoBox: planEntity.isOnlyWalk
          ? PlanInfoBox.noRouteMsg
          : (mainFetchIsEmpty
              ? PlanInfoBox.usingDefaultTransports
              : PlanInfoBox.undefined),
    );
  }

  @override
  Future<PlanEntity> fetchMoreItineraries({
    required TrufiLocation from,
    required TrufiLocation to,
    required String locale,
    required DateTime dateTime,
    bool arriveBy = false,
    int numItineraries = 5,
  }) async {
    await _ensureInitialized();
    _updateClientLocale(locale);

    var planEntity = await _fetchAndParsePlan(
      from: from,
      to: to,
      locale: locale,
      dateTime: dateTime,
      arriveBy: arriveBy,
      numItineraries: numItineraries,
      useDefaultModes: false,
      useStrictParams: true,
    );

    // Filter walk-only itineraries
    planEntity = planEntity.copyWith(
      itineraries: planEntity.itineraries
          ?.where((itinerary) => !itinerary.legs.every(
                (leg) => leg.transportMode == TransportMode.walk,
              ))
          .toList(),
    );

    final isEmpty = planEntity.itineraries?.isEmpty ?? true;

    return planEntity.copyWith(
      planInfoBox: planEntity.isOnlyWalk
          ? PlanInfoBox.noRouteMsg
          : (isEmpty
              ? PlanInfoBox.noRouteMsgWithChanges
              : PlanInfoBox.undefined),
    );
  }

  @override
  Future<ModesTransportEntity> fetchTransportModePlan({
    required TrufiLocation from,
    required TrufiLocation to,
    required String locale,
    required DateTime dateTime,
    bool arriveBy = false,
    bool isFreeParkToParkRide = false,
    bool isFreeParkToCarPark = false,
  }) async {
    await _ensureInitialized();
    _updateClientLocale(locale);

    final variables = StadtnaviOtpQueryBuilder.buildModesTransportVariables(
      from: from,
      to: to,
      preferences: preferences,
      dateTime: dateTime,
      arriveBy: arriveBy,
      locale: locale,
    );

    final queryOptions = QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: addFragments(
        parseString(queries.walkAndBikeQuery),
        [
          fragments.itineraryListContainerPlan,
          fragments.itineraryDetailsPlan,
          fragments.itineraryDetailsItinerary,
          fragments.itineraryListContainerItineraries,
          fragments.itineraryLineLegs,
          fragments.routeLinePattern,
          fragments.itineraryListItineraries,
          fragments.legAgencyInfoLeg,
          fragments.stopCardHeaderContainerStop,
        ],
      ),
      variables: variables,
    );

    final data = await _executeWithRetry(queryOptions, locale);

    var modesTransport = StadtnaviOtpResponseParser.parseModesTransport(data);

    // Filter park-ride itineraries to only include those with transit legs
    modesTransport = modesTransport.copyWith(
      parkRidePlan: modesTransport.parkRidePlan?.copyWith(
        itineraries: modesTransport.parkRidePlan?.itineraries
            ?.where((itinerary) =>
                itinerary.legs.any((leg) => leg.transitLeg))
            .toList(),
      ),
    );

    return modesTransport;
  }

  @override
  Widget? buildPreferencesUI(BuildContext context) => null;

  @override
  void resetPreferences() => preferences.reset();

  // Private helpers

  void _updateClientLocale(String locale) {
    _client = updateClient(
      graphQLClient: _client!,
      endpoint: otpEndpoint,
      languageEncode: locale,
    );
  }

  Future<PlanEntity> _fetchAndParsePlan({
    required TrufiLocation from,
    required TrufiLocation to,
    required String locale,
    required DateTime dateTime,
    required bool arriveBy,
    required int numItineraries,
    required bool useDefaultModes,
    required bool useStrictParams,
  }) async {
    final variables = StadtnaviOtpQueryBuilder.buildPlanVariables(
      from: from,
      to: to,
      preferences: preferences,
      dateTime: dateTime,
      arriveBy: arriveBy,
      numItineraries: numItineraries,
      locale: locale,
      useDefaultModes: useDefaultModes,
      useStrictParams: useStrictParams,
    );

    final queryOptions = QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: addFragments(
        parseString(queries.planQuery),
        [
          fragments.itineraryPageViewer,
          fragments.itineraryPageServiceTimeRange,
          fragments.itineraryListContainerPlan,
          fragments.itineraryDetailsPlan,
          fragments.itineraryDetailsItinerary,
          fragments.itineraryListContainerItineraries,
          fragments.itineraryLineLegs,
          fragments.routeLinePattern,
          fragments.legAgencyInfoLeg,
          fragments.itineraryListItineraries,
          fragments.stopCardHeaderContainerStop,
        ],
      ),
      variables: variables,
    );

    final data = await _executeWithRetry(queryOptions, locale);
    final planJson =
        data['viewer']?['plan'] as Map<String, dynamic>?;

    return StadtnaviOtpResponseParser.parsePlan(planJson);
  }

  /// Execute a GraphQL query with retry logic (up to [_maxRetries] attempts).
  Future<Map<String, dynamic>> _executeWithRetry(
    QueryOptions queryOptions,
    String locale,
  ) async {
    int attempt = 0;
    QueryResult<Object?>? result;

    while (attempt < _maxRetries) {
      try {
        result = await _client!.query(queryOptions);
        if (!(result.hasException && result.data == null)) {
          break;
        }
      } catch (_) {
        // Retry on exception
      }

      attempt++;
      if (attempt < _maxRetries) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    if (result == null) {
      throw Exception('Failed to load itineraries');
    }

    if (result.hasException && result.data == null) {
      final errorMessage = locale == 'en'
          ? 'Trip information is temporarily unavailable. Please try again later.'
          : 'Wir können deine Reisedaten im Moment nicht abrufen. Bitte versuche es später noch einmal.';
      throw Exception(errorMessage);
    }

    if (result.source?.isEager ?? false) {
      await Future.delayed(const Duration(milliseconds: 200));
    }

    return result.data!;
  }
}
