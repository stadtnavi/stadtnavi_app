import 'package:stadtnavi_core/base/models/enums/enums_plan/absolute_direction.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/relative_direction.dart';
import 'package:stadtnavi_core/base/models/othermodel/elevation_profile_component.dart';
import 'package:stadtnavi_core/base/models/utils/geo_utils.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class StepEntity {
  final double? distance;
  final double? lon;
  final double? lat;
  final List<ElevationProfileComponent>? elevationProfile;
  final RelativeDirection? relativeDirection;
  final AbsoluteDirection? absoluteDirection;
  final String? streetName;
  final String? exit;
  final bool? stayOn;
  final bool? area;
  final bool? bogusName;
  final bool? walkingBike;

  const StepEntity({
    this.distance,
    this.lon,
    this.lat,
    this.elevationProfile,
    this.relativeDirection,
    this.absoluteDirection,
    this.streetName,
    this.exit,
    this.stayOn,
    this.area,
    this.bogusName,
    this.walkingBike,
  });

  factory StepEntity.fromJson(Map<String, dynamic> json) => StepEntity(
        distance: double.tryParse(json['distance'].toString()) ?? 0,
        lon: double.tryParse(json['lon'].toString()) ?? 0,
        lat: double.tryParse(json['lat'].toString()) ?? 0,
        relativeDirection: json['relativeDirection'] != null
            ? getRelativeDirectionByString(json['relativeDirection'])
            : null,
        absoluteDirection: json['absoluteDirection'] != null
            ? getAbsoluteDirectionByString(json['absoluteDirection'])
            : null,
        streetName: json['streetName'],
        exit: json['exit'],
        stayOn: json['stayOn'],
        area: json['area'],
        bogusName: json['bogusName'],
        walkingBike: json['walkingBike'],
      );

  String distanceString(TrufiBaseLocalization localization) => distance != null
      ? displayDistanceWithLocale(
          localization,
          distance!,
        )
      : '';

  Map<String, dynamic> toMap() => {
        'distance': distance,
        'lon': lon,
        'lat': lat,
        'elevationProfile':
            List<dynamic>.from((elevationProfile ?? []).map((x) => x.toJson())),
        'relativeDirection': relativeDirection?.name,
        'absoluteDirection': absoluteDirection?.name,
        'streetName': streetName,
        'exit': exit,
        'stayOn': stayOn,
        'area': area,
        'bogusName': bogusName,
        'walkingBike': walkingBike,
      };
}
