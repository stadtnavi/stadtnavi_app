part of 'setting_fetch_cubit.dart';

@immutable
class SettingFetchState extends Equatable {
  static const int maxWalkDistance = 3000;
  static const int suggestCarMinDistance = 2000;
  static const int suggestBikeMaxDistance = 30000;
  static const int suggestBikeAndPublicMaxDistance = 15000;
  static const int bikeAndPublicMaxWalkDistance = 15000;
  static const int minDistanceBetweenFromAndTo = 20;
  static const List<String> parkAndRideBannedVehicleParkingTags = [
    'lot_type:Parkplatz',
    'lot_type:Tiefgarage',
    'lot_type:Parkhaus'
  ];

  const SettingFetchState({
    required this.walkSpeed,
    required this.avoidWalking,
    required this.transportModes,
    required this.bikeRentalNetworks,
    required this.triangleFactor,
    required this.avoidTransfers,
    required this.includeBikeSuggestions,
    required this.bicycleParkingFilter,
    required this.bikeSpeed,
    required this.showBikeAndParkItineraries,
    required this.includeParkAndRideSuggestions,
    required this.includeCarSuggestions,
    required this.wheelchair,
    required this.arriveBy,
    required this.date,
    this.allowedVehicleRentalFormFactors = const <String>{},
    this.allowedVehicleRentalNetworks = const <String>[],
  });

  final WalkingSpeed walkSpeed;
  final bool avoidWalking;
  final List<TransportMode> transportModes;
  final List<BikeRentalNetwork> bikeRentalNetworks;
  final TriangleFactor triangleFactor;
  final bool avoidTransfers;
  final bool includeBikeSuggestions;
  final BicycleParkingFilter bicycleParkingFilter;
  final BikingSpeed bikeSpeed;
  final bool showBikeAndParkItineraries;
  final bool includeParkAndRideSuggestions;
  final bool includeCarSuggestions;
  final bool wheelchair;
  final bool arriveBy;
  final DateTime? date;
  final Set<String> allowedVehicleRentalFormFactors;
  final List<String> allowedVehicleRentalNetworks;

  @override
  List<Object?> get props => [
        walkSpeed,
        avoidWalking,
        transportModes,
        bikeRentalNetworks,
        triangleFactor,
        avoidTransfers,
        includeBikeSuggestions,
        bicycleParkingFilter,
        bikeSpeed,
        showBikeAndParkItineraries,
        includeParkAndRideSuggestions,
        includeCarSuggestions,
        wheelchair,
        date,
        arriveBy,
        allowedVehicleRentalFormFactors,
        allowedVehicleRentalNetworks,
      ];
}
