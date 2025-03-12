import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:stadtnavi_core/base/models/enums/plan_info_box.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/services/online_request_plan/online_graphql_repository.dart';

import 'package:trufi_core/base/models/trufi_place.dart';

part 'map_route_state.dart';

class MapRouteCubit extends Cubit<MapRouteState> {
  static const String path = "state_home_page";
  late Box _box;

  final OnlineGraphQLRepository _requestManager;

  CancelableOperation<PlanEntity?>? currentFetchPlanOperation;

  MapRouteCubit(String otpEndpoint)
      : _requestManager = OnlineGraphQLRepository(graphQLEndPoint: otpEndpoint),
        super(const MapRouteState()) {
    _load();
  }

  Future<void> _load() async {
    _box = Hive.box(path);
    final jsonString = _box.get(path);
    if (jsonString != null && jsonString.isNotEmpty) {
      emit(
        MapRouteState.fromJson(jsonDecode(jsonString) as Map<String, dynamic>),
      );
    }
  }

  Future<void> reset() async {
    await updateMapRouteState(const MapRouteState());
  }

  Future<void> swapLocations() async {
    await updateMapRouteState(
      state.copyWith(
        fromPlace: state.toPlace,
        toPlace: state.fromPlace,
      ),
    );
  }

  Future<void> setPlace(TrufiLocation place) async {
    if (state.fromPlace == null) {
      setFromPlace(place);
    } else if (state.toPlace == null) {
      setToPlace(place);
    }
  }

  Future<void> setFromPlace(TrufiLocation fromPlace) async {
    await updateMapRouteState(state.copyWith(fromPlace: fromPlace));
  }

  Future<void> setToPlace(TrufiLocation toPlace) async {
    await updateMapRouteState(state.copyWith(toPlace: toPlace));
  }

  Future<void> resetFromPlace() async {
    await updateMapRouteState(
        state.copyWithNullable(fromPlace: const Optional.value(null)));
  }

  Future<void> resetFromPlaceKeepingToPlace() async {
    await updateMapRouteState(MapRouteState(toPlace: state.toPlace));
  }

  Future<void> resetToPlace() async {
    await updateMapRouteState(
        state.copyWithNullable(toPlace: const Optional.value(null)));
  }

  Future<void> resetToPlaceKeepingFromPlace() async {
    await updateMapRouteState(MapRouteState(fromPlace: state.fromPlace));
  }

  Future<void> removeInfoBox() async {
    await updateMapRouteState(
      state.copyWith(
        plan: state.plan?.copyWith(
          planInfoBox: PlanInfoBox.undefined,
        ),
      ),
    );
  }

  Future<void> updateMapRouteState(MapRouteState newState) async {
    await _box.put(path, jsonEncode(newState.toJson()));
    emit(newState);
  }

  Future<void> fetchPlan({
    required SettingFetchState advancedOptions,
    required String localeName,
  }) async {
    if (state.toPlace != null && state.fromPlace != null) {
      await updateMapRouteState(state.copyWithNullable(
        plan: const Optional.value(null),
        selectedItinerary: const Optional.value(null),
      ));
      await cancelCurrentFetchIfExist();
      // try {
      currentFetchPlanOperation = CancelableOperation.fromFuture(
        () {
          return _requestManager.fetchAdvancedPlan(
            from: state.fromPlace!,
            to: state.toPlace!,
            advancedOptions: advancedOptions,
            localeName: localeName,
          );
        }(),
      );
      PlanEntity? plan = await currentFetchPlanOperation?.valueOrCancellation();
      if (plan?.itineraries != null && plan!.itineraries!.isNotEmpty) {
        await updateMapRouteState(state.copyWith(
          plan: plan,
          selectedItinerary: plan.itineraries![0],
        ));
      } else {
        await updateMapRouteState(state.copyWith(
          plan: plan,
        ));
      }
      // } catch (e) {
      //   if (e.runtimeType != FetchCancelPlanException) rethrow;
      // }
    }
  }

  Future<void> fetchMoreDeparturePlan({
    required List<PlanItinerary> itineraries,
    required SettingFetchState advancedOptions,
    required String localeName,
    bool isFetchEarlier = true,
  }) async {
    emit(state.copyWith(
      isFetchEarlier: isFetchEarlier,
      isFetchLater: !isFetchEarlier,
    ));

    DateTime newDateTime;
    if (isFetchEarlier) {
      final newItinerary = itineraries.reduce((value, element) {
        if (element.startTime.isBefore(value.startTime)) {
          return element;
        }
        return value;
      });
      newDateTime = newItinerary.endTime
          .subtract(const Duration(minutes: 1))
          .copyWith(second: 0);
    } else {
      final newItinerary = itineraries.reduce((value, element) {
        if (element.startTime.isAfter(value.startTime)) {
          return element;
        }
        return value;
      });
      newDateTime = newItinerary.startTime
          .add(const Duration(minutes: 1))
          .copyWith(second: 0);
    }

    final PlanEntity? planEntity = await _fetchPlanPart(
      advancedOptions:
          advancedOptions.copyWith(date: newDateTime, arriveBy: isFetchEarlier),
      localeName: localeName,
    ).catchError((error) async {
      emit(state.copyWith(
        isFetchEarlier: false,
        isFetchLater: false,
      ));
      throw error;
    });

    List<PlanItinerary> tempItinerarires;
    if (isFetchEarlier) {
      tempItinerarires = [
        ...planEntity?.itineraries?.reversed ?? [],
        ...state.plan?.itineraries ?? [],
      ];
    } else {
      tempItinerarires = [
        ...state.plan?.itineraries ?? [],
        ...planEntity?.itineraries ?? [],
      ];
    }

    await updateMapRouteState(state.copyWith(
      plan: state.plan?.copyWith(
        itineraries: tempItinerarires,
        planInfoBox: planEntity?.planInfoBox ?? PlanInfoBox.undefined,
      ),
    ));

    await Future.delayed(const Duration(milliseconds: 200));
    emit(state.copyWith(
      isFetchEarlier: false,
      isFetchLater: false,
    ));
  }

  Future<void> fetchMoreArrivalPlan({
    required List<PlanItinerary> itineraries,
    required SettingFetchState advancedOptions,
    required String localeName,
    bool isFetchEarlier = true,
  }) async {
    emit(state.copyWith(
      isFetchEarlier: isFetchEarlier,
      isFetchLater: !isFetchEarlier,
    ));

    DateTime newDateTime;
    if (isFetchEarlier) {
      final newItinerary = itineraries.reduce((value, element) {
        if (element.startTime.isAfter(value.startTime)) {
          return element;
        }
        return value;
      });
      newDateTime =
          newItinerary.startTime.add(const Duration(minutes: 1)).copyWith(
                second: 0,
              );
    } else {
      final newItinerary = itineraries.reduce((value, element) {
        if (element.startTime.isBefore(value.startTime)) {
          return element;
        }
        return value;
      });
      newDateTime =
          newItinerary.endTime.subtract(const Duration(minutes: 1)).copyWith(
                second: 0,
              );
    }

    final PlanEntity? planEntity = await _fetchPlanPart(
      advancedOptions: advancedOptions.copyWith(
        date: newDateTime,
        arriveBy: !isFetchEarlier,
      ),
      localeName: localeName,
    ).catchError((error) async {
      emit(state.copyWith(
        isFetchEarlier: false,
        isFetchLater: false,
      ));
      throw error;
    });

    List<PlanItinerary> tempItinerarires;
    if (isFetchEarlier) {
      tempItinerarires = [
        ...planEntity?.itineraries?.reversed ?? [],
        ...state.plan?.itineraries ?? [],
      ];
    } else {
      tempItinerarires = [
        ...state.plan?.itineraries ?? [],
        ...planEntity?.itineraries ?? [],
      ];
    }

    await updateMapRouteState(state.copyWith(
      plan: state.plan?.copyWith(
        itineraries: tempItinerarires,
        planInfoBox: planEntity?.planInfoBox ?? PlanInfoBox.undefined,
      ),
    ));

    await Future.delayed(const Duration(milliseconds: 200));
    emit(state.copyWith(
      isFetchEarlier: false,
      isFetchLater: false,
    ));
  }

  Future<PlanEntity?> _fetchPlanPart({
    required SettingFetchState advancedOptions,
    required String localeName,
  }) async {
    await cancelCurrentFetchIfExist();
    currentFetchPlanOperation = CancelableOperation.fromFuture(
      () {
        return _requestManager.fetchMoreItineraries(
          from: state.fromPlace!,
          to: state.toPlace!,
          advancedOptions: advancedOptions,
          localeName: localeName,
        );
      }(),
    );
    PlanEntity? plan = await currentFetchPlanOperation?.valueOrCancellation();
    return plan;
  }

  Future<void> cancelCurrentFetchIfExist() async {
    await currentFetchPlanOperation?.cancel();
    currentFetchPlanOperation = null;
  }

  Future<void> showAllItineraries() async {
    await updateMapRouteState(state.copyWith(
      showAllItineraries: true,
    ));
  }

  Future<void> selectItinerary(
    PlanItinerary selectedItinerary, {
    bool showAllItineraries = true,
  }) async {
    await updateMapRouteState(state.copyWith(
      selectedItinerary: selectedItinerary,
      showAllItineraries: showAllItineraries,
    ));
  }
}
