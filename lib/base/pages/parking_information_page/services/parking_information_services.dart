import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:stadtnavi_core/configuration/graphql_client.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import 'package:stadtnavi_core/base/models/othermodel/vehicle_parking.dart';
import 'package:stadtnavi_core/consts.dart';

import 'park_queries.dart' as pattern_query;

class ParkingInformationServices {
  final GraphQLClient client;

  ParkingInformationServices(String endpoint) : client = getClient(endpoint);

  Future<List<ParkingFeature>> fetchParkings() async {
    final dataHerrenberg = latLonToTileXY(48.5915, 8.8681, 14);
    final parkingsArea = await _fetchParkingsByArea(
        z: 14, x: dataHerrenberg[0], y: dataHerrenberg[1]);
    final parkingsArea1 = await _fetchParkingsByArea(
        z: 14, x: dataHerrenberg[0] + 1, y: dataHerrenberg[1]+1);
    final parkingsArea2 = await _fetchParkingsByArea(
        z: 14, x: dataHerrenberg[0] - 1, y: dataHerrenberg[1]);
    final listAll = [
      ...parkingsArea,
      ...parkingsArea1,
      ...parkingsArea2,
    ];
    var map2 = <String, ParkingFeature>{};
    for (ParkingFeature parking in listAll) {
      map2[parking.id] = parking;
    }
    return fetchParkingsByIds(map2.values.toList());
  }

  List<int> latLonToTileXY(double lat, double lon, int zoom) {
    final n = pow(2.0, zoom);
    final xtile = ((lon + 180.0) / 360.0 * n).floor();
    final ytile =
        ((1.0 - log(tan(lat * pi / 180.0) + 1.0 / cos(lat * pi / 180.0)) / pi) /
                2.0 *
                n)
            .floor();
    return [xtile, ytile];
  }

  Future<List<ParkingFeature>> _fetchParkingsByArea({
    required int z,
    required int x,
    required int y,
  }) async {
    final uri = Uri(
      scheme: "https",
      host: ApiConfig().baseDomain,
      path: "/otp/routers/default/vectorTiles/parking/$z/$x/$y.pbf",
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        "Server Error on fetchPBF $uri with ${response.statusCode}",
      );
    }
    final bodyByte = response.bodyBytes;
    final tile = VectorTile.fromBytes(bytes: bodyByte);
    final listParkings = <ParkingFeature>[];
    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final ParkingFeature? pointFeature =
              ParkingFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            listParkings.add(pointFeature);
          }
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
    return listParkings;
  }

  Future<List<ParkingFeature>> fetchParkingsByIds(
    List<ParkingFeature> listParking,
  ) async {
    if (listParking.isEmpty) {
      return [];
    }
    final WatchQueryOptions listPatterns = WatchQueryOptions(
      document: parseString(pattern_query.parkingByIds),
      variables: <String, dynamic>{
        'parkIds': listParking.map((e) => e.id).toList(),
      },
      fetchResults: true,
      fetchPolicy: FetchPolicy.networkOnly,
    );
    final dataListParkings = await client.query(listPatterns);
    if (dataListParkings.hasException && dataListParkings.data == null) {
      throw dataListParkings.exception!.graphqlErrors.isNotEmpty
          ? Exception("Bad request")
          : Exception("Error connection");
    }
    final parkings = dataListParkings.data!['vehicleParkings']
        ?.map<VehicleParking>((dynamic json) =>
            VehicleParking.fromMap(json as Map<String, dynamic>))
        ?.toList() as List<VehicleParking>;
    final dataMapParkings = {
      for (VehicleParking e in parkings) e.vehicleParkingId ?? '': e
    };
    final newList = <ParkingFeature>[];
    for (final element in listParking) {
      ParkingFeature? tempParking;
      if (element.carPlacesCapacity != null &&
          element.availabilityCarPlacesCapacity != null) {
        tempParking = element.copyWith(
          availabilityCarPlacesCapacity:
              dataMapParkings[element.id]?.availability?.carSpaces,
        );
      }
      if (element.totalDisabled != null && element.freeDisabled != null) {
        tempParking = (tempParking ?? element).copyWith(
          freeDisabled: dataMapParkings[element.id]
              ?.availability
              ?.wheelchairAccessibleCarSpaces,
        );
      }
      if (tempParking != null) {
        newList.add(tempParking);
      }
    }

    return newList;
  }
}
