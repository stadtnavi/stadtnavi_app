import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/hb_layers_data.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:vector_tile/vector_tile.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/static_layer.dart';
import 'poi_feature_model.dart';
import 'poi_marker_modal.dart';

class PoisLayer extends CustomLayer {
  final Map<String, PoiFeature> _pbfMarkers = {};

  Map<String, PoiFeature> get data => _pbfMarkers;

  final PoiCategoryEnum poiCategoryEnum;

  PoisLayer(this.poiCategoryEnum, String weight)
      : super(poiCategoryEnum.toSelfCode(), weight);

  void addMarker(PoiFeature pointFeature) {
    if (_pbfMarkers[pointFeature.id] == null) {
      _pbfMarkers[pointFeature.id] = pointFeature;
      refresh();
    }
  }

  @override
  List<Marker>? buildLayerMarkersPriority(int? zoom) {
    double? markerSize;
    switch (zoom) {
      case 15:
        markerSize = null;
        break;
      case 16:
        markerSize = null;
        break;
      case 17:
        markerSize = 25;
        break;
      case 18:
        markerSize = 30;
        break;
      default:
        markerSize = zoom != null && zoom > 18 ? 35 : null;
    }
    final markersList = _pbfMarkers.values.toList();
    // avoid vertical wrong overlapping
    markersList.sort(
      (b, a) => a.position.latitude.compareTo(b.position.latitude),
    );

    return markerSize != null
        ? markersList.map((element) {
            final subCategoryData =
                HBLayerData.subCategoriesList[element.category3];
            return Marker(
              key: Key("$id:${element.id}"),
              height: markerSize! * .7,
              width: markerSize * .7,
              point: element.position,
              alignment: Alignment.center,
              child: Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    final panelCubit = context.read<PanelCubit>();
                    panelCubit.setPanel(
                      CustomMarkerPanel(
                        panel: (
                          context,
                          onFetchPlan, {
                          isOnlyDestination,
                        }) =>
                            PoiMarkerModal(
                          element: element,
                          onFetchPlan: onFetchPlan,
                        ),
                        positon: element.position,
                        minSize: 50,
                      ),
                    );
                  },
                   child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color:subCategoryData != null? fromStringToColor( subCategoryData.backgroundColor):null,
                          borderRadius: BorderRadius.circular(50)),
                      child: subCategoryData != null &&
                              subCategoryData.icon.isNotEmpty
                          ? SvgPicture.string(subCategoryData.icon,color:fromStringToColor( subCategoryData.color),)
                          : const Icon(Icons.error),
                    ),
                );
              }),
            );
          }).toList()
        : [];
  }

  @override
  Widget buildLayerOptions(int? zoom) {
    double? markerSize;
    switch (zoom) {
      case 15:
        markerSize = null;
        break;
      case 16:
        markerSize = 20;
        break;
      case 17:
        markerSize = 25;
        break;
      case 18:
        markerSize = 30;
        break;
      default:
        markerSize = zoom != null && zoom > 18 ? 35 : null;
    }
    final markersList = _pbfMarkers.values.toList();
    // avoid vertical wrong overlapping
    markersList.sort(
      (b, a) => a.position.latitude.compareTo(b.position.latitude),
    );
    return MarkerLayer(
      markers: markerSize != null
          ? markersList.map((element) {
              final subCategoryData =
                  HBLayerData.subCategoriesList[element.category3];
              return Marker(
                height: markerSize! * .7,
                width: markerSize * .7,
                point: element.position,
                alignment: Alignment.center,
                child: Builder(builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      final panelCubit = context.read<PanelCubit>();
                      panelCubit.setPanel(
                        CustomMarkerPanel(
                          panel: (
                            context,
                            onFetchPlan, {
                            isOnlyDestination,
                          }) =>
                              PoiMarkerModal(
                            element: element,
                            onFetchPlan: onFetchPlan,
                          ),
                          positon: element.position,
                          minSize: 50,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        
                          color:subCategoryData != null? fromStringToColor( subCategoryData.backgroundColor):null,
                          borderRadius: BorderRadius.circular(50)),
                      child: subCategoryData != null &&
                              subCategoryData.icon.isNotEmpty
                          ? SvgPicture.string(subCategoryData.icon,color:fromStringToColor( subCategoryData.color),)
                          : const Icon(Icons.error),
                    ),
                  );
                }),
              );
            }).toList()
          : zoom != null && zoom > 11
              ? markersList
                  .map(
                    (element) {
              final subCategoryData =
                  HBLayerData.subCategoriesList[element.category3];
                      return Marker(
                      height: 5,
                      width: 5,
                      point: element.position,
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color:subCategoryData != null ? fromStringToColor( subCategoryData.backgroundColor):Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                    },
                  )
                  .toList()
              : [],
    );
  }
static Color? fromStringToColor(String colorString) {
  try {
    String hexColor = colorString.replaceAll("#", "");
    if (hexColor.length == 6) hexColor = "FF$hexColor";
    if (hexColor.length != 8) return Colors.black;
    return Color(int.parse(hexColor, radix: 16));
  } catch (e) {
    return Colors.black;
  }
}
  @override
  Widget? buildLayerOptionsPriority(int zoom) {
    return null;
  }

  @override
  Widget? buildLayerOptionsBackground(int? zoom) {
    return null;
  }

  static Future<void> fetchPBF(int z, int x, int y) async {
    final uri = Uri(
      scheme: "https",
      host: "features.stadtnavi.eu",
      path: "/public.pois/$z/$x/$y.pbf",
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        "Server Error on fetchPBF $uri with ${response.statusCode}",
      );
    }
    final bodyByte = response.bodyBytes;
    final tile = VectorTile.fromBytes(bytes: bodyByte);

    for (final VectorTileLayer layer in tile.layers) {
      for (final VectorTileFeature feature in layer.features) {
        feature.decodeGeometry();

        if (feature.geometryType == GeometryType.Point) {
          final geojson = feature.toGeoJson<GeoJsonPoint>(x: x, y: y, z: z);
          final PoiFeature? pointFeature = PoiFeature.fromGeoJsonPoint(geojson);
          if (pointFeature != null) {
            final pbfLayer = StaticTileLayers.poisLayers[pointFeature.poiEnum];
            pbfLayer?.addMarker(pointFeature);
          }
        } else {
          throw Exception("Should never happened, Feature is not a point");
        }
      }
    }
  }

  @override
  String name(BuildContext context) {
    final localeName = TrufiBaseLocalization.of(context).localeName;

    final subCategoryData =
        HBLayerData.subCategoriesList[poiCategoryEnum.selfCode];
    if (subCategoryData == null) return poiCategoryEnum.selfCode;
    return localeName == "en" ? subCategoryData.en : subCategoryData.de;
  }

  String? _getIcon() {
    final subCategoryData =
        HBLayerData.subCategoriesList[poiCategoryEnum.selfCode];
    // if (subCategoryData == null) {
    //   return Icon(
    //     Icons.error,
    //   );
    // }
    if (subCategoryData != null && subCategoryData.icon.isNotEmpty) {
      return subCategoryData.icon;
    } else {
      for (final code in poiCategoryEnum.codes) {
        final internalSubCategoryData = HBLayerData.subCategoriesList[code];
        if (internalSubCategoryData != null &&
            internalSubCategoryData.icon.isNotEmpty) {
          return internalSubCategoryData.icon;
        }
      }
    }
  }

  @override
  Widget icon(BuildContext context) {
    final icon = _getIcon();

    if (icon != null) return SvgPicture.string(icon);
    return Icon(
      Icons.error,
      color: Colors.red,
    );
  }
}
