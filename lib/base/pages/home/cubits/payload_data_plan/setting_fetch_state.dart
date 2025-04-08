part of 'setting_fetch_cubit.dart';

final initPayloadDataPlanState = SettingFetchState(
  walkSpeed: WalkingSpeed.average,
  avoidWalking: false,
  transportModes: defaultTransportModes,
  bikeRentalNetworks: defaultBikeRentalNetworks,
  triangleFactor: TriangleFactor.unknown,
  avoidTransfers: false,
  includeBikeSuggestions: true,
  bicycleParkingFilter: BicycleParkingFilter.all,
  bikeSpeed: BikingSpeed.average,
  showBikeAndParkItineraries: true,
  includeParkAndRideSuggestions: true,
  includeCarSuggestions: false,
  wheelchair: false,
  arriveBy: false,
  date: null,
  allowedVehicleRentalNetworks:
      CityBikeUtils.getDefaultNetworks(ConfigDefault.value),
);

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

  static const String _typeWalkingSpeed = "typeWalkingSpeed";
  static const String _avoidWalking = "avoidWalking";
  static const String _transportModes = "transportModes";
  static const String _bikeRentalNetworks = "bikeRentalNetworks";
  static const String _triangleFactor = "triangleFactor";
  static const String _avoidTransfers = "avoidTransfers";
  static const String _includeBikeSuggestions = "includeBikeSuggestions";
  static const String _bicycleParkingFilter = "bicycleParkingFilter";
  static const String _typeBikingSpeed = "typeBikingSpeed";
  static const String _showBikeAndParkItineraries =
      "showBikeAndParkItineraries";
  static const String _includeParkAndRideSuggestions =
      "includeParkAndRideSuggestions";
  static const String _includeCarSuggestions = "includeCarSuggestions";
  static const String _wheelchair = "wheelchair";
  static const String _date = "date";
  static const String _allowedVehicleRentalFormFactors =
      "allowedVehicleRentalFormFactors";
  static const String _allowedVehicleRentalNetworks =
      "allowedVehicleRentalNetworks";
  static const String _arriveBy = "arriveBy";

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
    this.isFreeParkToParkRide = false,
    this.isFreeParkToCarPark = false,
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
  final bool isFreeParkToParkRide;
  final bool isFreeParkToCarPark;
  final Set<String> allowedVehicleRentalFormFactors;
  final List<String> allowedVehicleRentalNetworks;

  SettingFetchState copyWith({
    WalkingSpeed? typeWalkingSpeed,
    List<TransportMode>? transportModes,
    List<BikeRentalNetwork>? bikeRentalNetworks,
    TriangleFactor? triangleFactor,
    bool? avoidTransfers,
    bool? avoidWalking,
    bool? includeBikeSuggestions,
    BicycleParkingFilter? bicycleParkingFilter,
    BikingSpeed? bikeSpeed,
    bool? showBikeAndParkItineraries,
    bool? includeParkAndRideSuggestions,
    bool? includeCarSuggestions,
    bool? wheelchair,
    bool? arriveBy,
    DateTime? date,
    bool? isFreeParkToParkRide,
    bool? isFreeParkToCarPark,
    Set<String>? allowedVehicleRentalFormFactors,
    List<String>? allowedVehicleRentalNetworks,
  }) {
    return SettingFetchState(
      walkSpeed: typeWalkingSpeed ?? this.walkSpeed,
      transportModes: transportModes ?? this.transportModes,
      bikeRentalNetworks: bikeRentalNetworks ?? this.bikeRentalNetworks,
      triangleFactor: triangleFactor ?? this.triangleFactor,
      avoidTransfers: avoidTransfers ?? this.avoidTransfers,
      avoidWalking: avoidWalking ?? this.avoidWalking,
      includeBikeSuggestions:
          includeBikeSuggestions ?? this.includeBikeSuggestions,
      bicycleParkingFilter: bicycleParkingFilter ?? this.bicycleParkingFilter,
      bikeSpeed: bikeSpeed ?? this.bikeSpeed,
      showBikeAndParkItineraries:
          showBikeAndParkItineraries ?? this.showBikeAndParkItineraries,
      includeParkAndRideSuggestions:
          includeParkAndRideSuggestions ?? this.includeParkAndRideSuggestions,
      includeCarSuggestions:
          includeCarSuggestions ?? this.includeCarSuggestions,
      wheelchair: wheelchair ?? this.wheelchair,
      arriveBy: arriveBy ?? this.arriveBy,
      date: date ?? this.date,
      isFreeParkToParkRide: isFreeParkToParkRide ?? this.isFreeParkToParkRide,
      isFreeParkToCarPark: isFreeParkToCarPark ?? this.isFreeParkToCarPark,
      allowedVehicleRentalFormFactors: allowedVehicleRentalFormFactors ??
          this.allowedVehicleRentalFormFactors,
      allowedVehicleRentalNetworks:
          allowedVehicleRentalNetworks ?? this.allowedVehicleRentalNetworks,
    );
  }

  SettingFetchState copyWithDateNull({
    bool? arriveBy,
    DateTime? date,
  }) {
    return SettingFetchState(
      walkSpeed: walkSpeed,
      transportModes: transportModes,
      bikeRentalNetworks: bikeRentalNetworks,
      triangleFactor: triangleFactor,
      avoidTransfers: avoidTransfers,
      avoidWalking: avoidWalking,
      includeBikeSuggestions: includeBikeSuggestions,
      bicycleParkingFilter: bicycleParkingFilter,
      bikeSpeed: bikeSpeed,
      showBikeAndParkItineraries: showBikeAndParkItineraries,
      includeParkAndRideSuggestions: includeParkAndRideSuggestions,
      includeCarSuggestions: includeCarSuggestions,
      wheelchair: wheelchair,
      arriveBy: arriveBy ?? this.arriveBy,
      date: date,
      allowedVehicleRentalFormFactors: allowedVehicleRentalFormFactors,
      allowedVehicleRentalNetworks: allowedVehicleRentalNetworks,
    );
  }

  factory SettingFetchState.fromJson(Map<String, dynamic> json) {
    return SettingFetchState(
      walkSpeed: getWalkingSpeed(json[_typeWalkingSpeed] as String),
      transportModes: json[_transportModes]
          .map<TransportMode>(
            (key) => getTransportMode(mode: key as String),
          )
          .toList() as List<TransportMode>,
      bikeRentalNetworks: json[_bikeRentalNetworks]
          .map<BikeRentalNetwork>(
            (key) => getBikeRentalNetwork(key as String),
          )
          .toList() as List<BikeRentalNetwork>,
      triangleFactor:
          getTriangleFactorByString(json[_triangleFactor] as String),
      avoidTransfers: json[_avoidTransfers] as bool,
      avoidWalking: json[_avoidWalking] as bool,
      includeBikeSuggestions: json[_includeBikeSuggestions] as bool,
      bicycleParkingFilter:
          getBicycleParkingFilter(json[_bicycleParkingFilter] as String),
      bikeSpeed: getBikingSpeed(json[_typeBikingSpeed] as String),
      showBikeAndParkItineraries: json[_showBikeAndParkItineraries],
      includeParkAndRideSuggestions:
          json[_includeParkAndRideSuggestions] as bool,
      includeCarSuggestions: json[_includeCarSuggestions] as bool,
      wheelchair: json[_wheelchair] as bool,
      arriveBy: json[_arriveBy] as bool,
      date: json[_date] != null ? DateTime.parse(json[_date] as String) : null,
      allowedVehicleRentalFormFactors:
          (json[_allowedVehicleRentalFormFactors] as List<dynamic>?)
                  ?.map((item) => item as String)
                  .toList()
                  .toSet() ??
              <String>{},
      allowedVehicleRentalNetworks:
          (json[_allowedVehicleRentalNetworks] as List<dynamic>?)
                  ?.map((item) => item as String)
                  .toList() ??
              <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _typeWalkingSpeed: walkSpeed.name,
      _avoidWalking: avoidWalking,
      _transportModes:
          transportModes.map((transportMode) => transportMode.name).toList(),
      _bikeRentalNetworks: bikeRentalNetworks
          .map((bikeRentalNetwork) => bikeRentalNetwork.name)
          .toList(),
      _triangleFactor: triangleFactor.name,
      _avoidTransfers: avoidTransfers,
      _includeBikeSuggestions: includeBikeSuggestions,
      _bicycleParkingFilter: bicycleParkingFilter.name,
      _typeBikingSpeed: bikeSpeed.name,
      _showBikeAndParkItineraries: showBikeAndParkItineraries,
      _includeParkAndRideSuggestions: includeParkAndRideSuggestions,
      _includeCarSuggestions: includeCarSuggestions,
      _wheelchair: wheelchair,
      _arriveBy: arriveBy,
      _date: date?.toIso8601String(),
      _allowedVehicleRentalFormFactors:
          allowedVehicleRentalFormFactors.toList(),
      _allowedVehicleRentalNetworks: allowedVehicleRentalNetworks,
    };
  }

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
        isFreeParkToParkRide,
        isFreeParkToCarPark,
        allowedVehicleRentalFormFactors,
        allowedVehicleRentalNetworks,
      ];
}
