import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:async/async.dart';
import 'package:equatable/equatable.dart';

import 'package:stadtnavi_core/base/models/enums/plan_info_box.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/otp/providers/stadtnavi_routing_provider.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

part 'map_modes_state.dart';

class MapModesCubit extends Cubit<MapModesState> {
  static const String path = "map_modes_state";
  late Box _box;

  final IStadtnaviRoutingProvider _provider;

  CancelableOperation<PlanEntity?>? currentFetchPlanOperation;
  CancelableOperation<ModesTransportEntity>? currentFetchPlanModesOperation;

  MapModesCubit(IStadtnaviRoutingProvider provider)
      : _provider = provider,
        super(const MapModesState()) {
    _load();
  }

  Future<void> _load() async {
    _box = Hive.box(path);
    final jsonString = _box.get(path);
    if (jsonString != null && jsonString.isNotEmpty) {
      emit(
        MapModesState.fromJson(jsonDecode(jsonString) as Map<String, dynamic>),
      );
    }
  }

  Future<void> reset() async {
    await updateMapRouteState(const MapModesState());
  }

  Future<void> updateMapRouteState(MapModesState newState) async {
    await _box.put(path, jsonEncode(newState.toJson()));
    emit(newState);
  }

  Future<void> fetchModesPlans({
    required TrufiLocation from,
    required TrufiLocation to,
    required String localeName,
    DateTime? dateTime,
    bool arriveBy = false,
  }) async {
    emit(state.copyWithNullable(
      isFetchingModes: false,
      modesTransport: const Optional.value(null),
    ));
    final modesTransportEntity = await _fetchPlanModesState(
      from: from,
      to: to,
      localeName: localeName,
      dateTime: dateTime,
      arriveBy: arriveBy,
    ).catchError((error) {
      emit(state.copyWith(isFetchingModes: false));
      throw error;
    });
    if (modesTransportEntity == null) return;
    PlanInfoBox auxPlanInfoBox;
    if (modesTransportEntity.existWalkPlan ||
        modesTransportEntity.existBikePlan) {
      if (modesTransportEntity.existWalkPlan &&
          !modesTransportEntity.existBikePlan) {
        auxPlanInfoBox = PlanInfoBox.onlyWalkingRoutes;
      } else if (!modesTransportEntity.existWalkPlan &&
          modesTransportEntity.existBikePlan) {
        auxPlanInfoBox = PlanInfoBox.onlyCyclingRoutes;
      } else {
        auxPlanInfoBox = PlanInfoBox.onlyWalkingCyclingRoutes;
      }
    } else {
      auxPlanInfoBox = PlanInfoBox.noRouteMsg;
    }

    await updateMapRouteState(
      state.copyWith(
        plan: state.plan?.isOnlyWalk == true
            ? state.plan?.copyWith(planInfoBox: auxPlanInfoBox)
            : null,
        modesTransport: modesTransportEntity,
        isFetchingModes: false,
      ),
    );
  }

  Future<void> updateIsFetchingModes(bool isFetchingModes) async {
    emit(state.copyWith(
      isFetchingModes: isFetchingModes,
    ));
  }

  Future<MapModesState> fetchPlanModeRidePark({
    required TrufiLocation from,
    required TrufiLocation to,
    required String localeName,
    DateTime? dateTime,
    bool arriveBy = false,
  }) async {
    final modesTransportEntity = await _fetchPlanModesState(
      from: from,
      to: to,
      localeName: localeName,
      dateTime: dateTime,
      arriveBy: arriveBy,
      isFreeParkToParkRide: true,
      isFreeParkToCarPark: true,
    ).catchError((error) async {
      throw error;
    });
    await updateMapRouteState(state.copyWith(
      modesTransport: state.modesTransport?.copyWith(
        parkRidePlan: modesTransportEntity?.parkRidePlan,
        carParkPlan: modesTransportEntity?.carParkPlan,
      ),
    ));
    return state;
  }

  void setValuesMap({
    required PlanEntity plan,
  }) {
    emit(state.copyWith(
      plan: plan,
      selectedItinerary: plan.itineraries![0],
    ));
  }

  Future<ModesTransportEntity?> _fetchPlanModesState({
    required TrufiLocation from,
    required TrufiLocation to,
    required String localeName,
    DateTime? dateTime,
    bool arriveBy = false,
    bool isFreeParkToParkRide = false,
    bool isFreeParkToCarPark = false,
  }) async {
    await currentFetchPlanModesOperation?.cancel();
    currentFetchPlanModesOperation = CancelableOperation.fromFuture(
      () {
        return _provider.fetchTransportModePlan(
          from: from,
          to: to,
          locale: localeName,
          dateTime: dateTime ?? DateTime.now(),
          arriveBy: arriveBy,
          isFreeParkToParkRide: isFreeParkToParkRide,
          isFreeParkToCarPark: isFreeParkToCarPark,
        );
      }(),
    );
    final ModesTransportEntity? plan =
        await currentFetchPlanModesOperation?.valueOrCancellation(
      null,
    );
    return plan;
  }

  Future<void> cancelCurrentFetchIfExist() async {
    await currentFetchPlanOperation?.cancel();
    currentFetchPlanOperation = null;
  }

  void showAllItineraries() async {
    emit(state.copyWith(
      showAllItineraries: true,
    ));
  }

  void selectItinerary(
    PlanItinerary selectedItinerary, {
    bool showAllItineraries = true,
  }) {
    emit(state.copyWith(
      selectedItinerary: selectedItinerary,
      showAllItineraries: showAllItineraries,
    ));
  }
}
