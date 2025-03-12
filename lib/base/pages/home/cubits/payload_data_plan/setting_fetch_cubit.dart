import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/city_bike_utils.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/default_settings.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';

import 'package:stadtnavi_core/base/models/enums/enums_plan/enums_plan.dart';
part 'setting_fetch_state.dart';

class SettingFetchCubit extends Cubit<SettingFetchState> {
  static const String path = "state_setting_panel";
  late Box _box;

  final bool isDateReset;

  SettingFetchCubit({
    this.isDateReset = false,
  }) : super(initPayloadDataPlanState) {
    _load();
  }

  Future<void> _load() async {
    _box = Hive.box(path);
    final jsonString = _box.get(path);
    if (jsonString != null && jsonString.isNotEmpty) {
      final payloadDataPlanState = SettingFetchState.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>);
      if (isDateReset) {
        emit(payloadDataPlanState.copyWithDateNull(arriveBy: false));
      }
    }
  }

  Future<void> resetDataDate() async {
    await updateMapRouteState(state.copyWithDateNull(arriveBy: false));
  }

  Future<void> updateMapRouteState(SettingFetchState newState) async {
    await _box.put(path, jsonEncode(newState.toJson()));
    emit(newState);
  }

  Future<void> setTransportMode(TransportMode transportMode) async {
    final newList = [...state.transportModes];
    if (newList.contains(transportMode)) {
      newList.remove(transportMode);
    } else {
      newList.add(transportMode);
    }
    await updateMapRouteState(state.copyWith(transportModes: newList));
  }

  Future<void> setBikeRentalNetwork(BikeRentalNetwork bikeRentalNetwork) async {
    final newList = [...state.bikeRentalNetworks];
    if (newList.contains(bikeRentalNetwork)) {
      newList.remove(bikeRentalNetwork);
    } else {
      newList.add(bikeRentalNetwork);
    }
    await updateMapRouteState(state.copyWith(bikeRentalNetworks: newList));
  }

  Future<void> setTriangleFactor(TriangleFactor triangleFactor) async {
    await updateMapRouteState(state.copyWith(triangleFactor: triangleFactor));
  }

  Future<void> setWalkingSpeed(WalkingSpeed walkingSpeed) async {
    await updateMapRouteState(state.copyWith(typeWalkingSpeed: walkingSpeed));
  }

  Future<void> setAvoidWalking({
    required bool avoidWalking,
  }) async {
    await updateMapRouteState(state.copyWith(avoidWalking: avoidWalking));
  }

  Future<void> setAvoidTransfers({
    required bool avoidTransfers,
  }) async {
    await updateMapRouteState(state.copyWith(avoidTransfers: avoidTransfers));
  }

  Future<void> setIncludeBikeSuggestions({
    required bool includeBikeSuggestions,
  }) async {
    await updateMapRouteState(
        state.copyWith(includeBikeSuggestions: includeBikeSuggestions));
  }

  Future<void> setShowBikeAndParkItineraries({
    required bool showBikeAndParkItineraries,
  }) async {
    await updateMapRouteState(
        state.copyWith(showBikeAndParkItineraries: showBikeAndParkItineraries));
  }

  Future<void> setParkRide({
    required bool parkRide,
  }) async {
    await updateMapRouteState(
        state.copyWith(includeParkAndRideSuggestions: parkRide));
  }

  Future<void> setBicycleParkingFilter(BicycleParkingFilter bicycleParkingFilter) async {
    await updateMapRouteState(state.copyWith(bicycleParkingFilter: bicycleParkingFilter));
  }

  Future<void> setBikingSpeed(BikingSpeed bikingSpeed) async {
    await updateMapRouteState(state.copyWith(bikeSpeed: bikingSpeed));
  }

  Future<void> setIncludeCarSuggestions({
    required bool includeCarSuggestions,
  }) async {
    await updateMapRouteState(
        state.copyWith(includeCarSuggestions: includeCarSuggestions));
  }

  Future<void> setWheelChair({
    required bool wheelchair,
  }) async {
    await updateMapRouteState(state.copyWith(wheelchair: wheelchair));
  }

  Future<void> setDataDate({
    DateTime? date,
    bool? arriveBy,
  }) async {
    await updateMapRouteState(
        state.copyWithDateNull(date: date, arriveBy: arriveBy));
  }

  Future<void> setAllowedVehicleRentalFormFactors({
    required String rentalFormFactorsId,
    bool isDelete = false,
  }) async {
    final allowedVehicleRentalFormFactorsTemp = <String>{
      ...state.allowedVehicleRentalFormFactors
    };
    if (isDelete) {
      allowedVehicleRentalFormFactorsTemp.remove(rentalFormFactorsId);
    } else {
      allowedVehicleRentalFormFactorsTemp.add(rentalFormFactorsId);
    }

    await updateMapRouteState(state.copyWith(
      allowedVehicleRentalFormFactors: allowedVehicleRentalFormFactorsTemp,
    ));
  }

  Future<void> setAllowedVehicleRentalNetworks({
    required List<String> rentalNetworkIds,
    bool isDelete = false,
  }) async {
    final allowedVehicleRentalNetworksTemp = <String>[
      ...state.allowedVehicleRentalNetworks
    ];
    if (isDelete) {
      allowedVehicleRentalNetworksTemp
          .removeWhere((e) => rentalNetworkIds.contains(e));
    } else {
      allowedVehicleRentalNetworksTemp.addAll(rentalNetworkIds
          .where((e) => !allowedVehicleRentalNetworksTemp.contains(e)));
    }
    await updateMapRouteState(state.copyWith(
      allowedVehicleRentalNetworks: allowedVehicleRentalNetworksTemp,
    ));
  }
}
