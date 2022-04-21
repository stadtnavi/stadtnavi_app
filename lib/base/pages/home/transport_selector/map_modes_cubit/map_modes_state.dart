part of 'map_modes_cubit.dart';

@immutable
class MapModesState extends Equatable {
  static const String _modesTransport = "modesTransport";

  const MapModesState({
    this.plan,
    this.modesTransport,
    this.selectedItinerary,
    this.showAllItineraries = true,
    this.isFetchingModes = false,
  });

  final ModesTransportEntity? modesTransport;
  final PlanEntity? plan;
  final PlanItinerary? selectedItinerary;
  final bool showAllItineraries;
  final bool isFetchingModes;

  MapModesState copyWith({
    TrufiLocation? fromPlace,
    TrufiLocation? toPlace,
    PlanEntity? plan,
    ModesTransportEntity? modesTransport,
    PlanItinerary? selectedItinerary,
    bool? showAllItineraries,
    bool? isFetchingModes,
    bool? isFetchLater,
    bool? isFetchEarlier,
  }) {
    return MapModesState(
      plan: plan ?? this.plan,
      modesTransport: modesTransport ?? this.modesTransport,
      selectedItinerary: selectedItinerary ?? this.selectedItinerary,
      showAllItineraries: showAllItineraries ?? this.showAllItineraries,
      isFetchingModes: isFetchingModes ?? this.isFetchingModes,
    );
  }

  MapModesState copyWithNullable({
    Optional<TrufiLocation?>? fromPlace = const Optional(),
    Optional<TrufiLocation?>? toPlace = const Optional(),
    Optional<PlanEntity>? plan = const Optional(),
    Optional<ModesTransportEntity>? modesTransport = const Optional(),
    Optional<PlanItinerary>? selectedItinerary = const Optional(),
    bool? showAllItineraries,
    bool? isFetchingModes,
    bool? isFetchLater,
    bool? isFetchEarlier,
  }) {
    return MapModesState(
      plan: plan!.isValid ? plan.value : this.plan,
      modesTransport:
          modesTransport!.isValid ? modesTransport.value : this.modesTransport,
      selectedItinerary: selectedItinerary!.isValid
          ? selectedItinerary.value
          : this.selectedItinerary,
      showAllItineraries: showAllItineraries ?? this.showAllItineraries,
      isFetchingModes: isFetchingModes ?? this.isFetchingModes,
    );
  }

  factory MapModesState.fromJson(Map<String, dynamic> json) {
    return MapModesState(
      modesTransport: json[_modesTransport] != null
          ? ModesTransportEntity.fromJson(
              json[_modesTransport] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _modesTransport: modesTransport?.toJson(),
    };
  }

  bool get hasTransportModes =>
      modesTransport?.availableModesTransport ?? false;

  @override
  String toString() {
    return "{ "
        "plan ${plan != null} }"
        "modesTransport ${modesTransport != null} "
        "showAllItineraries $showAllItineraries, "
        "isFetchingModes $isFetchingModes, "
        "}";
  }

  @override
  List<Object?> get props => [
        plan,
        modesTransport,
        selectedItinerary,
        showAllItineraries,
        isFetchingModes,
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
