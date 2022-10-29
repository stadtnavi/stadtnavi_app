import 'package:latlong2/latlong.dart';

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_data_fetch.dart';
import 'package:vector_tile/vector_tile.dart';
import 'citybikes_enum.dart';

class CityBikeFeature {
  final GeoJsonPoint? geoJsonPoint;
  final String id;
  final CityBikeLayerIds? type;
  final CityBikeDataFetch? extraInfo;
  final LatLng position;
  CityBikeFeature({
    required this.geoJsonPoint,
    required this.id,
    required this.type,
    required this.position,
    this.extraInfo,
  });
  // ignore: prefer_constructors_over_static_methods
  static CityBikeFeature? fromGeoJsonPoint(GeoJsonPoint? geoJsonPoint) {
    if (geoJsonPoint?.properties == null) return null;
    final properties = geoJsonPoint?.properties ?? <String, VectorTileValue>{};
    String? id = properties['id']?.dartStringValue;
    String? networks = properties['networks']?.dartStringValue;
    if (networks == null) {
      return null;
    }
    CityBikeLayerIds? type = properties['networks'] != null
        ? cityBikeLayerIdStringToEnum(
            networks,
          )
        : null;

    return CityBikeFeature(
      geoJsonPoint: geoJsonPoint,
      id: id ?? '',
      type: type,
      position: LatLng(
        geoJsonPoint!.geometry!.coordinates[1],
        geoJsonPoint.geometry!.coordinates[0],
      ),
    );
  }

  CityBikeFeature copyWithExtraInfo(CityBikeDataFetch extraInfo) {
    return CityBikeFeature(
      geoJsonPoint: geoJsonPoint,
      id: id,
      type: type,
      position: position,
      extraInfo: extraInfo,
    );
  }
}
