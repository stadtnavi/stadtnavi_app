part of 'parking_information_cubit.dart';

@immutable
class ParkingInformationState extends Equatable {
  final List<ParkingFeature> parkings;
  final bool isLoading;
  final String error;

  const ParkingInformationState({
    this.parkings = const [],
    this.isLoading = false,
    this.error = '',
  });

  ParkingInformationState copyWith({
    List<ParkingFeature>? parkings,
    bool? isLoading,
    String? error,
  }) {
    return ParkingInformationState(
      parkings: parkings ?? this.parkings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        parkings,
        isLoading,
        error,
      ];

  @override
  String toString() {
    return 'ParkingInformationState: {transports:$parkings, '
        'isLoading:$isLoading, error:$error';
  }
}
