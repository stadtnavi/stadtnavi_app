import 'package:latlong2/latlong.dart';

class CustomMarker {
  final String? id;
  final LatLng position;
  final String image;
  final String? name;
  final String? nameEn;
  final String? nameDe;
  final String? popupContent;
  final String? popupContentEn;
  final String? popupContentDe;

  CustomMarker({
    required this.id,
    required this.position,
    required this.image,
    required this.name,
    required this.nameEn,
    required this.nameDe,
    required this.popupContent,
    required this.popupContentEn,
    required this.popupContentDe,
  });
}
