import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';

class ParkingZonePoligonModel {
  final List<LatLng> coordinates;
  final Color borderColor;
  final Color backgroundcolor;
  final double weight;
  final String? dashArray;

  const ParkingZonePoligonModel({
    required this.coordinates,
    required this.borderColor,
    required this.backgroundcolor,
    required this.weight,
    this.dashArray,
  });

  ParkingZonePoligonModel copyWith({
    List<LatLng>? coordinates,
    Color? borderColor,
    Color? backgroundcolor,
    double? weight,
    String? dashArray,
  }) {
    return ParkingZonePoligonModel(
      coordinates: coordinates ?? this.coordinates,
      borderColor: borderColor ?? this.borderColor,
      backgroundcolor: backgroundcolor ?? this.backgroundcolor,
      weight: weight ?? this.weight,
      dashArray: dashArray ?? this.dashArray,
    );
  }

  factory ParkingZonePoligonModel.fromJson(Map<String, dynamic> map) {
    final codeColor = map['style']?['color']?.replaceAll('#', '0x');
    return ParkingZonePoligonModel(
      coordinates: List<LatLng>.from((map['geometry']?['coordinates']?[0] ?? [])
          .map((x) => LatLng(x[1], x[0]))),
      borderColor: Color(
        int.tryParse(codeColor) ?? 0xffffffff,
      ).withOpacity(
        map['style']?['opacity']?.toDouble() ?? 1.0,
      ),
      backgroundcolor: Color(
        int.tryParse(codeColor) ?? 0xffffffff,
      ).withOpacity(
        map['style']?['fillOpacity']?.toDouble() ?? 0.2,
      ),
      weight: map['style']?['weight']?.toDouble() ?? 1.0,
      dashArray: map['style']?['dashArray'],
    );
  }
}

class ParkingZoneMarkerModel {
  final LatLng coordinates;
  final Widget icon;
  final String popupContent;

  const ParkingZoneMarkerModel({
    required this.coordinates,
    required this.icon,
    required this.popupContent,
  });

  ParkingZoneMarkerModel copyWith({
    LatLng? coordinates,
    SvgPicture? icon,
    String? popupContent,
  }) {
    return ParkingZoneMarkerModel(
      coordinates: coordinates ?? this.coordinates,
      icon: icon ?? this.icon,
      popupContent: popupContent ?? this.popupContent,
    );
  }

  factory ParkingZoneMarkerModel.fromJson(Map<String, dynamic> map) {
    final iconCode = map['properties']?['icon']?['svg']?[0] ?? '';
    final popupContent =
        ((map['properties']?['popupContent'] as String?) ?? '').split('<br/>');
    final texttrimed = popupContent
        .map((x) => Bidi.stripHtmlIfNeeded(x).trim())
        .toList()
        .join('\n');
    return ParkingZoneMarkerModel(
      coordinates: LatLng(map['geometry']?['coordinates']?[1] ?? 0,
          map['geometry']?['coordinates']?[0] ?? 0),
      icon: SizedBox(
        child: SvgPicture.string(iconCode),
      ),
      popupContent: texttrimed,
    );
  }
}
  // Color get backgroundColor {
  //   return route?.color != null
  //       ? Color(int.tryParse('0xFF${route?.color}')!)
  //       : transportMode.backgroundColor;
  // }

    // {
    //   "geometry": {
    //     "coordinates": [9.19020404992358, 48.891242988387376],
    //     "type": "Point"
    //   },
    //   "properties": {
    //     "icon": {
    //       "id": "icon-Zone2",
    //       "svg": [
    //         "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 36 36'><path d='M36 18A18 18 0 1118 0a18 18 0 0118 18' fill='#3A8C3B' fill-rule='evenodd'/><g aria-label=\"2\"><path d=\"m 24.631423,26.055777 v -3.22137 h -8.876664 c 0.310206,-1.288548 1.455582,-2.410062 4.41447,-3.770196 2.839578,-1.31241 4.29516,-2.481648 4.29516,-5.178054 0,-3.197508 -2.243028,-4.7962621 -6.20412,-4.7962621 -2.648682,0 -5.011019,0.9783421 -6.776807,2.7679921 l 2.14758,2.50551 c 1.169238,-1.121514 2.767991,-2.004408 4.748537,-2.004408 2.004408,0 2.74413,0.83517 2.74413,1.694202 0,0.71586 -0.453378,1.383996 -1.885098,2.004408 -4.080402,1.78965 -7.588115,4.271298 -7.683563,9.998178 z\" fill=\"#fff\" /></g></svg>"
    //       ]
    //     },
    //     "popupContent": "<b>Zone 2</b><br/>Erste Stunde: 1,20 \u20ac<br/>Tagessatz: 2,40 \u20ac (max. 2 h)<br/>Zeiten: Mo - Sa 8 - 19 Uhr Sonntag frei<br/><small>(Stand: Oktober 2021)</small>"
    //   },
    //   "type": "Feature"
    // },