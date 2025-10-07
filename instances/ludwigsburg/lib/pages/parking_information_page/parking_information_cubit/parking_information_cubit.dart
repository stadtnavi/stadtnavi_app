import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import '../services/parking_information_services.dart';

part 'parking_information_state.dart';

class ParkingInformationCubit extends Cubit<ParkingInformationState> {
  final ParkingInformationServices routeTransportsRepository;

  ParkingInformationCubit(String otpEndpoint)
      : routeTransportsRepository =
            ParkingInformationServices(otpEndpoint: otpEndpoint),
        super(const ParkingInformationState()) {
    loadData().catchError((error) {});
  }

  Future<void> loadData({String? locale}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final parkings = await routeTransportsRepository.fetchParkings(locale);
      parkings.sort((a, b) {
        int res = -1;
        final aShortName = int.tryParse(a.name ?? '');
        final bShortName = int.tryParse(b.name ?? '');
        if (aShortName != null && bShortName != null) {
          res = aShortName.compareTo(bShortName);
        } else if (aShortName == null && bShortName == null) {
          res = a.name?.compareTo(b.name ?? '') ?? 1;
        } else if (aShortName != null) {
          res = 1;
        }
        return res;
      });
      emit(state.copyWith(parkings: parkings, isLoading: false, error: ''));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      rethrow;
    }
  }

  Future<void> refresh({String? locale}) async {
    try {
      if (state.parkings.isEmpty) {
        loadData();
        return;
      }
      final parkings = await routeTransportsRepository.fetchParkingsByIds(
          state.parkings, locale);
      parkings.sort((a, b) {
        int res = -1;
        final aShortName = int.tryParse(a.name ?? '');
        final bShortName = int.tryParse(b.name ?? '');
        if (aShortName != null && bShortName != null) {
          res = aShortName.compareTo(bShortName);
        } else if (aShortName == null && bShortName == null) {
          res = a.name?.compareTo(b.name ?? '') ?? 1;
        } else if (aShortName != null) {
          res = 1;
        }
        return res;
      });
      emit(state.copyWith(parkings: parkings, isLoading: false, error: ''));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      rethrow;
    }
  }
}
