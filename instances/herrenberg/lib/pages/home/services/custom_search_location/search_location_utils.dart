import 'dart:math';
import 'package:equatable/equatable.dart';

class SearchData extends Equatable {
  final List<Map<String, dynamic>> data;
  final String nameLabel;
  final String? layer;

  const SearchData({
    required this.data,
    required this.nameLabel,
    this.layer,
  });

  @override
  List<Object?> get props => [nameLabel, layer];
}

List<Map<String, dynamic>> uniqByLabel(List<Map<String, dynamic>> features) {
  Map<String, Map<String, dynamic>> dart = {};
  for (var element in features) {
    final key =
        "${getNameLabel(element["properties"]).join("")}${element["properties"]?["layer"]}";
    dart[key] = element;
  }

  return dart.values.toList();
}

String getLocality(Map<String, dynamic> suggestion) {
  String? address = suggestion["address"];
  return suggestion["localadmin"] ??
      suggestion["locality"] ??
      ((address != null && address.lastIndexOf(',') < address.length - 2)
          ? address.substring(address.lastIndexOf(',') + 2)
          : '');
}

String? getStopCode(Map<String, dynamic> suggestion) {
  final String? id = suggestion["id"];
  final String? code = suggestion["code"];
  if (code != null) return code;
  if (id == null) {
    return null;
  }
  return id.substring(id.indexOf('#') + 1);
}

List<String> getNameLabel(Map<String, dynamic> suggestion,
    {bool plain = false}) {
  List<String?> data = [];
  switch (suggestion["layer"]) {
    case 'currentPosition':
      data = [suggestion["labelId"], suggestion["address"]];
      break;
    case 'selectFromMap':
    case 'ownLocations':
    case 'back':
      data = [suggestion["labelId"]];
      break;
    case 'favouritePlace':
      data = [
        suggestion["name"] ?? (suggestion["address"]?.split(',')[0] ?? ''),
        suggestion["address"].replace(
          RegExp('${RegExp.escape(suggestion["name"])}\(,\)\?\( \)\?'),
          '',
        ),
      ];
      break;
    case 'favouriteBikeRentalStation':
    case 'bikeRentalStation':
      data = [suggestion["name"]];
      break;
    case 'favouriteRoute':
    case 'route-BUS':
    case 'route-TRAM':
    case 'route-RAIL':
    case 'route-SUBWAY':
    case 'route-FERRY':
    case 'route-AIRPLANE':
      data = !plain && suggestion["shortName"]
          ? [
              suggestion["gtfsId"],
              suggestion["mode"].toLowerCase(),
              suggestion["longName"],
            ]
          : [
              suggestion["shortName"],
              suggestion["longName"],
              suggestion["agency"] ? suggestion["agency"]["name"] : null,
            ];
      break;
    case 'venue':
    case 'address':
    case 'street':
      data = [
        suggestion["name"],
        suggestion["label"].replaceAll(
          RegExp('${RegExp.escape(suggestion["name"])}\(,\)\?\( \)\?'),
          '',
        ),
      ];
      break;
    case 'favouriteStop':
    case 'stop':
      data = plain
          ? [
              suggestion["name"] ??
                  suggestion["label"] ??
                  suggestion["address"]?.split(',')[0] ??
                  '',
              getLocality(suggestion),
            ]
          : [
              suggestion["name"],
              suggestion["id"],
              getStopCode(suggestion) ?? '',
              getLocality(suggestion),
            ];
      break;
    case 'favouriteStation':
    case 'station':
    default:
      data = [
        suggestion["name"] ??
            suggestion["label"] ??
            suggestion["address"]?.split(',')[0] ??
            '',
        getLocality(suggestion),
      ];
  }
  data.removeWhere((value) => value == null);
  return data.whereType<String>().toList();
}

// TODO need debounce = 300
// const debouncedSearch = debounce(getSearchResults, 300, {
//   leading: true,
// });
List<Map<String, dynamic>> sortSearchResults(
  RegExp lineRegexp,
  List<Map<String, dynamic>> results,
  String term,
) {
  String normalizedTerm = term.toLowerCase();
  bool isLineSearch = lineRegexp.hasMatch(normalizedTerm);
  results.sort((a, b) {
    String normalizeShortName = (a["properties"]["shortName"] ?? "").toString();
    if (!isLineSearch || !lineRegexp.hasMatch(normalizeShortName)) {
      return 0;
    }
    return normalizeShortName.indexOf(normalizedTerm) == 0 ? 1 : 0;
  });

  final resultsWithWeight = results.reversed.map((e) {
    double? confidence = (e["properties"]["confidence"]).toDouble();
    String? layer = e["properties"]["layer"];
    dynamic source = e["properties"]["source"];

    if (normalizedTerm.isEmpty) {
      // Doing search with empty string.
      // No confidence to match, so use ranked old searches and favourites
      return {
        ...e,
        "numSort": getLayerRank(getLegModeByKey(layer ?? ''), source)
      };
    }
    // must handle a mixup of geocoder searches and items above
    // Normal confidence range from geocoder is about 0.3 .. 1
    if (confidence == 0 || confidence == null) {
      // not from geocoder, estimate confidence ourselves
      double estimatedConfidence =
          getLayerRank(getLegModeByKey(layer ?? ''), source) +
              match(normalizedTerm, e["properties"]);

      return {
        ...e,
        "numSort": getLegModeByKey(layer ?? '') == LayerType.bikeRentalStation
            ? estimatedConfidence - 0.8
            : estimatedConfidence
      };
    }

    // geocoded items with confidence, just adjust a little
    switch (getLegModeByKey(layer ?? '')) {
      case LayerType.station:
        {
          double boost = source.indexOf('gtfs') == 0 ? 0.05 : 0.01;
          return {...e, "numSort": min(confidence + boost, 1)};
        }
      case LayerType.stop:
        return {...e, "numSort": confidence - 0.1};
      default:
        return {...e, "numSort": confidence};
    }
  }).toList();
  resultsWithWeight.sort(
    (a, b) => (a['numSort'] as num).compareTo(b['numSort'] as num),
  );
  return resultsWithWeight.reversed.toList();
}

double getLayerRank(LayerType layer, dynamic source) {
  switch (layer) {
    case LayerType.currentPosition:
      return 1;
    case LayerType.back:
      return 0.9;
    case LayerType.selectFromMap:
      return 0.8;
    case LayerType.selectFromOwnLocations:
      return 0.79;
    case LayerType.favouriteStation:
    case LayerType.favouritePlace:
    case LayerType.favouriteStop:
    case LayerType.favouriteRoute:
      return 0.45;
    case LayerType.futureRoute:
      return 0.44;
    case LayerType.station:
      {
        if ((source is String) && source.indexOf('gtfs') == 0) {
          return 0.43;
        }
        return 0.42;
      }
    case LayerType.favouriteBikeRentalStation:
    case LayerType.stop:
      return 0.35;
    case LayerType.bikeRentalStation:
      return 0.1;
    default:
      // venue, address, street, route-xxx
      return 0.4;
  }
}

int match(String normalizedTerm, Map<String, dynamic> resultProperties) {
  if (normalizedTerm.isEmpty) {
    return 0;
  }
  final matchProps = ['name', 'label', 'address', 'shortName'];
  matchProps
      .map((e) => resultProperties[e])
      .where((e) => e is String && e.isNotEmpty)
      .map((e) {
    if (e.indexOf(normalizedTerm) == 0) {
      // full match at start. Return max result when match is full, not only partial
      return 50 + (normalizedTerm.length / e.length).round();
    }
    // because of filtermatchingtoinput, we know that match occurred somewhere
    // don't run filtermatching again but estimate roughly:
    // the longer the matching string, the better confidence, max being 0.5
    return ((5 * normalizedTerm.length) / (normalizedTerm.length + 10)).round();
  }).reduce((value, element) => (value > element ? value : element));
  return 0;
}

String getIconProperties(Map<String, dynamic> item) {
  String? iconId;
  // ignore: unused_local_variable
  String iconColor = '#888888';

  final type = item["type"];

  if (type == 'FavouriteStop') {
    iconId = 'favouriteStop';
  } else if (type == 'FavouriteStation') {
    iconId = 'favouriteStation';
  } else if (item["selectedIconId"] != null) {
    iconId = item["selectedIconId"];
  } else if (item["properties"] != null) {
    iconId =
        item["properties"]["selectedIconId"] ?? item["properties"]["layer"];
  } else if (item["properties"]["layer"] == 'bikestation') {
    iconId = 'citybike';
  }
  if (item["iconColor"] != null) {
    // eslint-disable-next-line prefer-destructuring
    iconColor = item["iconColor"];
  } else if (isFavourite(item)) {
    iconColor = '#888888';
  }

  if (layerIcon[iconId] == 'locate') {
    iconColor = '#888888';
  }

  return layerIcon[iconId] ?? "place";
}

bool isFavourite(Map<String, dynamic> item) {
  return item["type"]?.contains('Favourite') ?? false;
}

const layerIcon = <String, String>{
  'bikeRentalStation': 'citybike',
  'bikestation': 'citybike',
  'currentPosition': 'locate',
  'favouritePlace': 'star',
  'favouriteRoute': 'star',
  'favouriteStop': 'star',
  'favouriteStation': 'star',
  'favouriteBikeRentalStation': 'star',
  'favourite': 'star',
  'address': 'place',
  'stop': 'busstop',
  'locality': 'city',
  'station': 'station',
  'localadmin': 'city',
  'neighbourhood': 'city',
  'route-BUS': 'mode-bus',
  'route-TRAM': 'mode-tram',
  'route-RAIL': 'mode-rail',
  'route-SUBWAY': 'subway',
  'route-FERRY': 'mode-ferry',
  'route-AIRPLANE': 'airplane',
  'edit': 'edit',
  'icon-icon_home': 'home',
  'icon-icon_work': 'work',
  'icon-icon_sport': 'sport',
  'icon-icon_school': 'school',
  'icon-icon_shopping': 'shopping',
  'selectFromMap': 'selec:-from-map',
  'ownLocations': 'star',
  'back': 'arrow',
  'futureRoute': 'future-route',
};

enum LayerType {
  none,
  address,
  back,
  currentPosition,
  favouriteStop,
  favouriteStation,
  favouritePlace,
  favouriteRoute,
  futureRoute,
  station,
  selectFromMap,
  selectFromOwnLocations,
  stop,
  street,
  venue,
  bikeRentalStation,
  favouriteBikeRentalStation,
}

LayerType getLegModeByKey(String key) {
  return LayerTypeExtension.names.keys.firstWhere(
    (keyE) => keyE.name == key,
    orElse: () => LayerType.none,
  );
}

extension LayerTypeExtension on LayerType {
  static const names = <LayerType, String>{
    LayerType.none: 'none',
    LayerType.address: 'address',
    LayerType.back: 'back',
    LayerType.currentPosition: 'currentPosition',
    LayerType.favouriteStop: 'favouriteStop',
    LayerType.favouriteStation: 'favouriteStation',
    LayerType.favouritePlace: 'favouritePlace',
    LayerType.favouriteRoute: 'favouriteRoute',
    LayerType.futureRoute: 'futureRoute',
    LayerType.station: 'station',
    LayerType.selectFromMap: 'selectFromMap',
    LayerType.selectFromOwnLocations: 'ownLocations',
    LayerType.stop: 'stop',
    LayerType.street: 'street',
    LayerType.venue: 'venue',
    LayerType.bikeRentalStation: 'bikeRentalStation',
    LayerType.favouriteBikeRentalStation: 'favouriteBikeRentalStation',
  };

  String get name => names[this]!;
}
