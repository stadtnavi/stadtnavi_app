part of 'plan_entity.dart';

class PlanItinerary extends Equatable {
  static const String _legs = "legs";
  static const String _startTime = "startTime";
  static const String _endTime = "endTime";
  static const String _walkTime = "walkTime";
  static const String _durationTrip = "duration";
  static const String _walkDistance = "walkDistance";
  static const String _arrivedAtDestinationWithRentedBicycle =
      "arrivedAtDestinationWithRentedBicycle";

  static int _distanceForLegs(List<PlanItineraryLeg> legs) =>
      legs.fold<int>(0, (distance, leg) => distance += leg.distance.ceil());

  PlanItinerary({
    this.legs = const [],
    required this.startTime,
    required this.endTime,
    required this.walkTime,
    required this.duration,
    required this.walkDistance,
    required this.arrivedAtDestinationWithRentedBicycle,
    this.isOnlyShowItinerary = false,
  })  : distance = _distanceForLegs(legs);

  final List<PlanItineraryLeg> legs;
  final DateTime startTime;
  final DateTime endTime;
  final Duration walkTime;
  final Duration duration;
  final double walkDistance;
  final bool arrivedAtDestinationWithRentedBicycle;
  final bool isOnlyShowItinerary;

  final int distance;

  factory PlanItinerary.fromJson(Map<String, dynamic> json) {
    return PlanItinerary(
      legs: json[_legs].map<PlanItineraryLeg>((dynamic json) {
        return PlanItineraryLeg.fromJson(json as Map<String, dynamic>);
      }).toList() as List<PlanItineraryLeg>,
      startTime: DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(json[_startTime].toString()) ?? 0),
      endTime: DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(json[_endTime].toString()) ?? 0),
      walkTime: Duration(seconds: (json[_walkTime] ?? 0) as int),
      duration: Duration(seconds: (json[_durationTrip] ?? 0) as int),
      walkDistance: double.tryParse(json[_walkDistance].toString()) ?? 0,
      arrivedAtDestinationWithRentedBicycle:
          json[_arrivedAtDestinationWithRentedBicycle] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _legs: legs.map((itinerary) => itinerary.toJson()).toList(),
      _startTime: startTime.millisecondsSinceEpoch,
      _endTime: endTime.millisecondsSinceEpoch,
      _walkTime: walkTime.inSeconds,
      _durationTrip: duration.inSeconds,
      _walkDistance: walkDistance,
      _arrivedAtDestinationWithRentedBicycle:
          arrivedAtDestinationWithRentedBicycle
    };
  }

  PlanItinerary copyWith({
    List<PlanItineraryLeg>? legs,
    DateTime? startTime,
    DateTime? endTime,
    Duration? walkTime,
    Duration? durationTrip,
    double? walkDistance,
    bool? arrivedAtDestinationWithRentedBicycle,
    bool? isOnlyShowItinerary,
  }) {
    return PlanItinerary(
      legs: legs ?? this.legs,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      walkTime: walkTime ?? this.walkTime,
      duration: durationTrip ?? duration,
      walkDistance: walkDistance ?? this.walkDistance,
      arrivedAtDestinationWithRentedBicycle:
          arrivedAtDestinationWithRentedBicycle ??
              this.arrivedAtDestinationWithRentedBicycle,
      isOnlyShowItinerary: isOnlyShowItinerary ?? this.isOnlyShowItinerary,
    );
  }

  List<PlanItineraryLeg> get compressLegs {
    final usingOwnBicycle = legs.any(
      (leg) =>
          getLegModeByKey(leg.transportMode.name) == LegMode.bicycle &&
          leg.rentedBike == false,
    );
    final compressedLegs = <PlanItineraryLeg>[];
    PlanItineraryLeg? compressedLeg;
    for (final PlanItineraryLeg currentLeg in legs) {
      if (compressedLeg == null) {
        compressedLeg = currentLeg.copyWith();
        continue;
      }
      if (currentLeg.intermediatePlaces != null) {
        compressedLegs.add(compressedLeg);
        compressedLeg = currentLeg.copyWith();
        continue;
      }

      if (usingOwnBicycle && continueWithBicycle(compressedLeg, currentLeg)) {
        final newBikePark = compressedLeg.toPlace?.bikeParkEntity ??
            currentLeg.toPlace?.bikeParkEntity;
        compressedLeg = compressedLeg.copyWith(
          duration: compressedLeg.duration + currentLeg.duration,
          distance: compressedLeg.distance + currentLeg.distance,
          toPlace: currentLeg.toPlace?.copyWith(bikeParkEntity: newBikePark),
          endTime: currentLeg.endTime,
          mode: TransportMode.bicycle.name,
          accumulatedPoints: [
            ...compressedLeg.accumulatedPoints,
            ...currentLeg.accumulatedPoints,
          ],
        );
        continue;
      }

      if (currentLeg.rentedBike != null &&
          continueWithRentedBicycle(compressedLeg, currentLeg) &&
          !bikingEnded(currentLeg)) {
        compressedLeg = compressedLeg.copyWith(
          duration: compressedLeg.duration + currentLeg.duration,
          distance: compressedLeg.distance + currentLeg.distance,
          toPlace: currentLeg.toPlace,
          endTime: currentLeg.endTime,
          mode: LegMode.bicycle.name,
          accumulatedPoints: [
            ...compressedLeg.accumulatedPoints,
            ...currentLeg.accumulatedPoints
          ],
        );
        continue;
      }

      if (usingOwnBicycle &&
          getLegModeByKey(compressedLeg.mode) == LegMode.walk) {
        compressedLeg = compressedLeg.copyWith(
          mode: LegMode.bicycleWalk.name,
        );
      }

      compressedLegs.add(compressedLeg);
      compressedLeg = currentLeg.copyWith();

      if (usingOwnBicycle && getLegModeByKey(currentLeg.mode) == LegMode.walk) {
        compressedLeg = compressedLeg.copyWith(
          mode: LegMode.bicycleWalk.name,
        );
      }
    }
    if (compressedLeg != null) {
      compressedLegs.add(compressedLeg);
    }

    return compressedLegs;
  }

  String startDateText(TrufiBaseLocalization localization) {
    final tempDate = DateTime.now();
    final nowDate = DateTime(tempDate.year, tempDate.month, tempDate.day);
    if (nowDate.difference(startTime).inDays == 0) {
      return '';
    }
    if (nowDate.difference(startTime).inDays == 1) {
      return localization.commonTomorrow;
    }
    return DateFormat('E dd.MM.', localization.localeName).format(startTime);
  }

  String get startTimeHHmm => durationToHHmm(startTime);

  String get endTimeHHmm => durationToHHmm(endTime);

  String durationFormat(TrufiBaseLocalization localization) =>
      durationFormatString(localization, duration);

  String getDistanceString(TrufiBaseLocalization localization) =>
      displayDistanceWithLocale(localization, distance.toDouble());

  // String durationTripString(StadtnaviBaseLocalization localization) =>
  //     durationToString(localization, durationTrip);

  String getWalkDistanceString(TrufiBaseLocalization localization) =>
      displayDistanceWithLocale(localization, walkDistance.toDouble());

  double get totalDistance => sumDistances(legs);

  double get totalWalkingDistance => getTotalWalkingDistance(compressLegs);

  double get totalBikingDistance => getTotalBikingDistance(compressLegs);

  Duration get totalWalkingDuration =>
      Duration(seconds: getTotalWalkingDuration(compressLegs).toInt());

  Duration get totalBikingDuration =>
      Duration(seconds: getTotalBikingDuration(compressLegs).toInt());

  String firstLegStartTime(
    TrufiBaseLocalization localizationBase,
    StadtnaviBaseLocalization localization,
  ) {
    final firstDeparture = compressLegs.firstWhereOrNull(
      (element) => element.transitLeg,
    );
    String legStartTime = '';
    if (firstDeparture != null) {
      if (firstDeparture.rentedBike ?? false) {
        legStartTime = localization.departureBikeStation(
          firstDeparture.startTimeString,
          firstDeparture.fromPlace?.name ?? '',
        );
        if (firstDeparture.fromPlace?.bikeRentalStation?.bikesAvailable !=
            null) {
          legStartTime =
              '$legStartTime ${firstDeparture.fromPlace?.bikeRentalStation?.bikesAvailable} ${"localization.commonBikesAvailable"}';
        }
      } else {
        final String firstDepartureStopType =
            firstDeparture.transportMode == TransportMode.rail ||
                    firstDeparture.transportMode == TransportMode.subway
                ? localizationBase.commonFromStation
                : localizationBase.commonFromStop;
        final String firstDeparturePlatform =
            firstDeparture.fromPlace?.stopEntity?.platformCode != null
                ? (firstDeparture.transportMode == TransportMode.rail
                        ? ', ${localization.commonTrack} '
                        : ', ${localization.commonPlatform} ') +
                    (firstDeparture.fromPlace?.stopEntity?.platformCode ?? '')
                : '';
        legStartTime =
            "${localizationBase.commonLeavesAt} ${firstDeparture.startTimeString} $firstDepartureStopType ${firstDeparture.fromPlace?.name} $firstDeparturePlatform";
      }
    } else {
      legStartTime = localizationBase.commonItineraryNoTransitLegs;
    }

    return legStartTime;
  }

  int get totalDurationItinerary {
    return endTime.difference(startTime).inSeconds;
  }

  bool get usingOwnBicycle => legs.any((leg) =>
      leg.transportMode == TransportMode.bicycle && (leg.rentedBike ?? false));

  int getNumberIcons(double renderBarThreshold) {
    final routeShorts = compressLegs.where((leg) {
      final legLength = (leg.durationIntLeg / totalDurationItinerary) * 10;
      if (!(legLength < renderBarThreshold && leg.isLegOnFoot) &&
          leg.toPlace?.bikeParkEntity != null) {
        return true;
      } else if (leg.transportMode == TransportMode.car &&
          leg.toPlace?.carParkEntity != null) {
        return true;
      } else if (leg.transportMode == TransportMode.bicycle &&
          leg.toPlace?.bikeParkEntity != null &&
          !(legLength < renderBarThreshold && leg.isLegOnFoot)) {
        return true;
      }
      return false;
    }).toList();
    return routeShorts.length;
  }

  int getNumberLegHide(double renderBarThreshold) {
    return compressLegs
        .where((leg) {
          final legLength = (leg.durationIntLeg / totalDurationItinerary) * 10;
          return legLength < renderBarThreshold &&
              leg.transportMode != TransportMode.walk;
        })
        .toList()
        .length;
  }

  int getNumberLegTime(double renderBarThreshold) {
    return compressLegs.fold(0, (previousValue, element) {
      final legLength = (element.durationIntLeg / totalDurationItinerary) * 10;
      return legLength < renderBarThreshold
          ? previousValue + element.durationIntLeg
          : previousValue;
    });
  }

  PlanItineraryLeg? firstDeparture() {
    final firstDeparture = compressLegs.firstWhereOrNull(
      (element) => element.transitLeg,
    );
    return firstDeparture;
  }

  @override
  List<Object?> get props => [
        legs,
        startTime,
        endTime,
        walkTime,
        duration,
        walkDistance,
        arrivedAtDestinationWithRentedBicycle,
      ];
}
