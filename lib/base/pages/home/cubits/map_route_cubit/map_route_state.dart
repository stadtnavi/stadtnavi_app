part of 'map_route_cubit.dart';

@immutable
class MapRouteState extends Equatable {
  static const String _fromPlace = "fromPlace";
  static const String _toPlace = "toPlace";
  static const String _plan = "plan";
  // static const String _modesTransport = "modesTransport";
  static const String _itinerary = "itinerary";

  const MapRouteState({
    this.fromPlace,
    this.toPlace,
    this.plan,
    // this.modesTransport,
    this.selectedItinerary,
    this.showAllItineraries = true,
    this.isFetchingModes = false,
    this.isFetchLater = false,
    this.isFetchEarlier = false,
  });

  final TrufiLocation? fromPlace;
  final TrufiLocation? toPlace;
  final PlanEntity? plan;
  // final ModesTransportEntity? modesTransport;
  final PlanItinerary? selectedItinerary;
  final bool showAllItineraries;
  final bool isFetchingModes;
  final bool isFetchLater;
  final bool isFetchEarlier;

  MapRouteState copyWith({
    TrufiLocation? fromPlace,
    TrufiLocation? toPlace,
    PlanEntity? plan,
    // ModesTransportEntity? modesTransport,
    PlanItinerary? selectedItinerary,
    bool? showAllItineraries,
    bool? isFetchingModes,
    bool? isFetchLater,
    bool? isFetchEarlier,
  }) {
    return MapRouteState(
      fromPlace: fromPlace ?? this.fromPlace,
      toPlace: toPlace ?? this.toPlace,
      plan: plan ?? this.plan,
      // modesTransport: modesTransport ?? this.modesTransport,
      selectedItinerary: selectedItinerary ?? this.selectedItinerary,
      showAllItineraries: showAllItineraries ?? this.showAllItineraries,
      isFetchingModes: isFetchingModes ?? this.isFetchingModes,
      isFetchLater: isFetchLater ?? this.isFetchLater,
      isFetchEarlier: isFetchEarlier ?? this.isFetchEarlier,
    );
  }

  MapRouteState copyWithNullable({
    Optional<TrufiLocation?>? fromPlace = const Optional(),
    Optional<TrufiLocation?>? toPlace = const Optional(),
    Optional<PlanEntity>? plan = const Optional(),
    // Optional<ModesTransportEntity>? modesTransport = const Optional(),
    Optional<PlanItinerary>? selectedItinerary = const Optional(),
    bool? showAllItineraries,
    bool? isFetchingModes,
    bool? isFetchLater,
    bool? isFetchEarlier,
  }) {
    return MapRouteState(
      fromPlace: fromPlace!.isValid ? fromPlace.value : this.fromPlace,
      toPlace: toPlace!.isValid ? toPlace.value : this.toPlace,
      plan: plan!.isValid ? plan.value : this.plan,
      // modesTransport:
      //     modesTransport!.isValid ? modesTransport.value : this.modesTransport,
      selectedItinerary: selectedItinerary!.isValid
          ? selectedItinerary.value
          : this.selectedItinerary,
      showAllItineraries: showAllItineraries ?? this.showAllItineraries,
      isFetchingModes: isFetchingModes ?? this.isFetchingModes,
      isFetchLater: isFetchLater ?? this.isFetchLater,
      isFetchEarlier: isFetchEarlier ?? this.isFetchEarlier,
    );
  }

  factory MapRouteState.fromJson(Map<String, dynamic> json) {
    return MapRouteState(
      fromPlace: json[_fromPlace] != null
          ? TrufiLocation.fromJson(json[_fromPlace] as Map<String, dynamic>)
          : null,
      toPlace: json[_toPlace] != null
          ? TrufiLocation.fromJson(json[_toPlace] as Map<String, dynamic>)
          : null,
      plan: json[_plan] != null
          ? PlanEntity.fromJson(json[_plan] as Map<String, dynamic>)
          : null,
      // modesTransport: json[_modesTransport] != null
      //     ? ModesTransportEntity.fromJson(
      //         json[_modesTransport] as Map<String, dynamic>)
      //     : null,
      selectedItinerary: json[_itinerary] != null
          ? PlanItinerary.fromJson(json[_itinerary] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _fromPlace: fromPlace?.toJson(),
      _toPlace: toPlace?.toJson(),
      _plan: plan?.toJson(),
      // _modesTransport: modesTransport?.toJson(),
      _itinerary: selectedItinerary?.toJson(),
    };
  }

  bool get isPlacesDefined => fromPlace != null && toPlace != null;

  // bool get hasTransportModes =>
  //     modesTransport?.availableModesTransport ?? false;

  @override
  String toString() {
    return "{ "
        "fromPlace ${fromPlace?.description}, "
        "toPlace ${toPlace?.description}, "
        "plan ${plan != null} }"
        // "modesTransport ${modesTransport != null} "
        "showAllItineraries $showAllItineraries, "
        "isFetchingModes $isFetchingModes, "
        "isFetchLater $isFetchLater, "
        "isFetchEarlier $isFetchEarlier, "
        "}";
  }

  @override
  List<Object?> get props => [
        fromPlace,
        toPlace,
        plan,
        // modesTransport,
        selectedItinerary,
        showAllItineraries,
        isFetchingModes,
        isFetchLater,
        isFetchEarlier,
      ];
}

class Optional<T> {
  final bool isValid;
  final T? _value;

  T? get value => _value;

  const Optional()
      : isValid = false,
        _value = null;

  const Optional.value(this._value) : isValid = true;
}
