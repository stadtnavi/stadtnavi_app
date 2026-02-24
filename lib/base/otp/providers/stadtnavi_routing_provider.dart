import 'package:flutter/widgets.dart';
import 'package:stadtnavi_core/base/otp/entities/plan_entity.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

/// Interface for stadtnavi routing providers.
///
/// Follows the same pattern as trufi_core's IRoutingProvider but adds
/// stadtnavi-specific capabilities (multi-modal transport plans, alerts,
/// more itineraries pagination).
///
/// Each provider reads its own internal preferences (transport modes,
/// walk speed, wheelchair, etc.) when building requests. The caller
/// only provides trip-level parameters.
abstract class IStadtnaviRoutingProvider {
  /// Unique identifier for this provider.
  String get id;

  /// Display name shown in UI selectors.
  String get name;

  /// Whether this provider requires internet connection.
  bool get requiresInternet;

  /// Initialize the provider.
  ///
  /// Called during app startup to prepare any resources needed.
  Future<void> initialize() async {}

  /// Fetches a trip plan from origin to destination.
  ///
  /// The provider reads its own internal preferences when building the
  /// request. Walk-only itineraries are filtered out and a fallback to
  /// default modes is attempted if no results are found.
  Future<PlanEntity> fetchPlan({
    required TrufiLocation from,
    required TrufiLocation to,
    required String locale,
    required DateTime dateTime,
    bool arriveBy = false,
    int numItineraries = 5,
  });

  /// Fetches additional itineraries for pagination (earlier/later departures).
  ///
  /// Uses strict query parameters and a search window for time-based
  /// pagination.
  Future<PlanEntity> fetchMoreItineraries({
    required TrufiLocation from,
    required TrufiLocation to,
    required String locale,
    required DateTime dateTime,
    bool arriveBy = false,
    int numItineraries = 5,
  });

  /// Fetches multi-modal transport options (walk, bike, car, park-ride, etc.).
  ///
  /// Returns plans for each mode type in a [ModesTransportEntity].
  Future<ModesTransportEntity> fetchTransportModePlan({
    required TrufiLocation from,
    required TrufiLocation to,
    required String locale,
    required DateTime dateTime,
    bool arriveBy = false,
    bool isFreeParkToParkRide = false,
    bool isFreeParkToCarPark = false,
  });

  /// Builds the preferences UI widget for this provider.
  ///
  /// Returns null if this provider has no configurable preferences.
  Widget? buildPreferencesUI(BuildContext context) => null;

  /// Resets all preferences to defaults.
  void resetPreferences() {}
}
