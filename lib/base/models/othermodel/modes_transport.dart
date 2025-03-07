import 'package:stadtnavi_core/base/models/othermodel/enums/mode.dart';
import 'package:stadtnavi_core/base/models/othermodel/plan.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';

class ModesTransport {
  final Plan? walkPlan;
  final Plan? bikePlan;
  final Plan? bikeAndPublicPlan;
  final Plan? bikeParkPlan;
  final Plan? carPlan;
  final Plan? carParkPlan;
  final Plan? parkRidePlan;
  final Plan? onDemandTaxiPlan;

  ModesTransport({
    this.walkPlan,
    this.bikePlan,
    this.bikeAndPublicPlan,
    this.bikeParkPlan,
    this.carPlan,
    this.carParkPlan,
    this.parkRidePlan,
    this.onDemandTaxiPlan,
  });

  factory ModesTransport.fromJson(Map<String, dynamic> json) => ModesTransport(
        walkPlan: json["walkPlan"] != null
            ? Plan.fromMap(json["walkPlan"] as Map<String, dynamic>)
            : null,
        bikePlan: json["bikePlan"] != null
            ? Plan.fromMap(json["bikePlan"] as Map<String, dynamic>)
            : null,
        bikeAndPublicPlan: json["bikeAndPublicPlan"] != null
            ? Plan.fromMap(json["bikeAndPublicPlan"] as Map<String, dynamic>)
            : null,
        bikeParkPlan: json["bikeParkPlan"] != null
            ? Plan.fromMap(json["bikeParkPlan"] as Map<String, dynamic>)
            : null,
        carPlan: json["carPlan"] != null
            ? Plan.fromMap(json["carPlan"] as Map<String, dynamic>)
            : null,
        carParkPlan: json["carParkPlan"] != null
            ? Plan.fromMap(json["carParkPlan"] as Map<String, dynamic>)
            : null,
        parkRidePlan: json["parkRidePlan"] != null
            ? Plan.fromMap(json["parkRidePlan"] as Map<String, dynamic>)
            : null,
        onDemandTaxiPlan: json["onDemandTaxiPlan"] != null
            ? Plan.fromMap(json["onDemandTaxiPlan"] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'walkPlan': walkPlan?.toMap(),
        'bikePlan': bikePlan?.toMap(),
        'bikeAndPublicPlan': bikeAndPublicPlan?.toMap(),
        'bikeParkPlan': bikeParkPlan?.toMap(),
        'carPlan': carPlan?.toMap(),
        'carParkPlan': carParkPlan?.toMap(),
        'parkRidePlan': parkRidePlan?.toMap(),
        'onDemandTaxiPlan': onDemandTaxiPlan?.toMap(),
      };

  ModesTransport copyWith({
    Plan? walkPlan,
    Plan? bikePlan,
    Plan? bikeAndPublicPlan,
    Plan? bikeParkPlan,
    Plan? carPlan,
    Plan? carParkPlan,
    Plan? parkRidePlan,
    Plan? onDemandTaxiPlan,
  }) {
    return ModesTransport(
      walkPlan: walkPlan ?? this.walkPlan,
      bikePlan: bikePlan ?? this.bikePlan,
      bikeAndPublicPlan: bikeAndPublicPlan ?? this.bikeAndPublicPlan,
      bikeParkPlan: bikeParkPlan ?? this.bikeParkPlan,
      carPlan: carPlan ?? this.carPlan,
      carParkPlan: carParkPlan ?? this.carParkPlan,
      parkRidePlan: parkRidePlan ?? this.parkRidePlan,
      onDemandTaxiPlan: onDemandTaxiPlan ?? this.onDemandTaxiPlan,
    );
  }

  ModesTransportEntity toModesTransport() {
    return ModesTransportEntity(
      walkPlan: walkPlan?.toPlan().copyWith(type: 'walkPlan'),
      bikePlan: bikePlan?.toPlan().copyWith(type: 'bikePlan'),
      bikeAndPublicPlan:
          bikeAndPublicPlan?.toPlan().copyWith(type: 'bikeAndPublicPlan'),
      bikeParkPlan: bikeParkPlan?.toPlan().copyWith(type: 'bikeParkPlan'),
      carPlan: carPlan?.toPlan().copyWith(type: 'carPlan'),
      carParkPlan: carParkPlan?.toPlan().copyWith(type: 'carParkPlan'),
      parkRidePlan: parkRidePlan?.toPlan().copyWith(type: 'parkRidePlan'),
      onDemandTaxiPlan: onDemandTaxiPlan
          ?.toPlan()
          .copyWith(
            itineraries: onDemandTaxiPlan!.itineraries
                ?.where((itinerary) => !(itinerary.legs ?? [])
                    .every((leg) => leg.mode == Mode.walk))
                .map((e) => e.toPlanItinerary())
                .toList(),
          )
          .copyWith(type: 'onDemandTaxiPlan'),
    );
  }
}
