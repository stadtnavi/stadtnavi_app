import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stadtnavi_core/base/otp/providers/stadtnavi_otp/stadtnavi_otp_preferences.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/default_settings.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';

import 'package:stadtnavi_core/base/otp/enums/enums_plan/enums_plan.dart';
part 'setting_fetch_state.dart';

/// Cubit that manages trip-level state (date/arriveBy) and delegates
/// all routing preferences to [StadtnaviOtpPreferences].
///
/// Widgets that use `context.watch<SettingFetchCubit>()` continue to work —
/// the cubit listens to preference changes and re-emits state.
class SettingFetchCubit extends Cubit<SettingFetchState> {
  /// Hive box path — still used by [StadtnaviOtpPreferences] for persistence.
  static const String path = "state_setting_panel";

  final StadtnaviOtpPreferences _preferences;

  SettingFetchCubit({
    required StadtnaviOtpPreferences preferences,
  })  : _preferences = preferences,
        super(_buildState(preferences, null, false)) {
    _preferences.addListener(_onPreferencesChanged);
  }

  DateTime? _date;
  bool _arriveBy = false;

  void _onPreferencesChanged() {
    emit(_buildState(_preferences, _date, _arriveBy));
  }

  static SettingFetchState _buildState(
    StadtnaviOtpPreferences prefs,
    DateTime? date,
    bool arriveBy,
  ) {
    return SettingFetchState(
      walkSpeed: prefs.walkSpeed,
      avoidWalking: prefs.avoidWalking,
      transportModes: prefs.transportModes,
      bikeRentalNetworks: prefs.bikeRentalNetworks,
      triangleFactor: prefs.triangleFactor,
      avoidTransfers: prefs.avoidTransfers,
      includeBikeSuggestions: prefs.includeBikeSuggestions,
      bicycleParkingFilter: prefs.bicycleParkingFilter,
      bikeSpeed: prefs.bikeSpeed,
      showBikeAndParkItineraries: prefs.showBikeAndParkItineraries,
      includeParkAndRideSuggestions: prefs.includeParkAndRideSuggestions,
      includeCarSuggestions: prefs.includeCarSuggestions,
      wheelchair: prefs.wheelchair,
      arriveBy: arriveBy,
      date: date,
      allowedVehicleRentalFormFactors: prefs.allowedVehicleRentalFormFactors,
      allowedVehicleRentalNetworks: prefs.allowedVehicleRentalNetworks,
    );
  }

  // Trip-level setters

  Future<void> setDataDate({
    DateTime? date,
    bool? arriveBy,
  }) async {
    _date = date;
    _arriveBy = arriveBy ?? _arriveBy;
    emit(_buildState(_preferences, _date, _arriveBy));
  }

  Future<void> resetDataDate() async {
    _date = null;
    _arriveBy = false;
    emit(_buildState(_preferences, _date, _arriveBy));
  }

  // Preference setters (delegate to StadtnaviOtpPreferences)

  Future<void> setTransportMode(TransportMode transportMode) async {
    _preferences.toggleTransportMode(transportMode);
  }

  Future<void> setBikeRentalNetwork(
      BikeRentalNetwork bikeRentalNetwork) async {
    _preferences.toggleBikeRentalNetwork(bikeRentalNetwork);
  }

  Future<void> setTriangleFactor(TriangleFactor triangleFactor) async {
    _preferences.setTriangleFactor(triangleFactor);
  }

  Future<void> setWalkingSpeed(WalkingSpeed walkingSpeed) async {
    _preferences.setWalkingSpeed(walkingSpeed);
  }

  Future<void> setAvoidWalking({required bool avoidWalking}) async {
    _preferences.setAvoidWalking(avoidWalking);
  }

  Future<void> setAvoidTransfers({required bool avoidTransfers}) async {
    _preferences.setAvoidTransfers(avoidTransfers);
  }

  Future<void> setIncludeBikeSuggestions(
      {required bool includeBikeSuggestions}) async {
    _preferences.setIncludeBikeSuggestions(includeBikeSuggestions);
  }

  Future<void> setShowBikeAndParkItineraries(
      {required bool showBikeAndParkItineraries}) async {
    _preferences.setShowBikeAndParkItineraries(showBikeAndParkItineraries);
  }

  Future<void> setParkRide({required bool parkRide}) async {
    _preferences.setIncludeParkAndRideSuggestions(parkRide);
  }

  Future<void> setBicycleParkingFilter(
      BicycleParkingFilter bicycleParkingFilter) async {
    _preferences.setBicycleParkingFilter(bicycleParkingFilter);
  }

  Future<void> setBikingSpeed(BikingSpeed bikingSpeed) async {
    _preferences.setBikingSpeed(bikingSpeed);
  }

  Future<void> setIncludeCarSuggestions(
      {required bool includeCarSuggestions}) async {
    _preferences.setIncludeCarSuggestions(includeCarSuggestions);
  }

  Future<void> setWheelChair({required bool wheelchair}) async {
    _preferences.setWheelchair(wheelchair);
  }

  Future<void> setAllowedVehicleRentalFormFactors({
    required String rentalFormFactorsId,
    bool isDelete = false,
  }) async {
    if (isDelete) {
      _preferences.removeVehicleRentalFormFactor(rentalFormFactorsId);
    } else {
      _preferences.addVehicleRentalFormFactor(rentalFormFactorsId);
    }
  }

  Future<void> setAllowedVehicleRentalNetworks({
    required List<String> rentalNetworkIds,
    bool isDelete = false,
  }) async {
    if (isDelete) {
      _preferences.removeVehicleRentalNetworks(rentalNetworkIds);
    } else {
      _preferences.addVehicleRentalNetworks(rentalNetworkIds);
    }
  }

  @override
  Future<void> close() {
    _preferences.removeListener(_onPreferencesChanged);
    return super.close();
  }
}
