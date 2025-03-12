class CityBikeConfig {
  bool showFullInfo;
  int cityBikeMinZoom;
  int cityBikeSmallIconZoom;
  int fewAvailableCount;
  Map<String, String> buyInstructions;
  int? minZoomStopsNearYou;
  bool? showStationId;
  bool? useSpacesAvailable;
  bool? showCityBikes;
  Map<String, NetworkConfig>? networks;
  Map<String, OperatorConfig>? operators;
  Map<String, FormFactor>? formFactors;

  CityBikeConfig({
    this.showFullInfo = false,
    this.cityBikeMinZoom = 14,
    this.cityBikeSmallIconZoom = 14,
    this.fewAvailableCount = 3,
    this.buyInstructions = const {
      "fi": "Osta käyttöoikeutta päiväksi, viikoksi tai koko kaudeksi",
      "sv": "Köp ett abonnemang för en dag, en vecka eller för en hel säsong",
      "en": "Buy a daily, weekly or season pass",
    },
    this.minZoomStopsNearYou,
    this.showStationId,
    this.useSpacesAvailable,
    this.showCityBikes,
    this.networks,
    this.operators,
    this.formFactors,
  });

  CityBikeConfig copyWith({
    bool? showFullInfo,
    int? cityBikeMinZoom,
    int? cityBikeSmallIconZoom,
    int? fewAvailableCount,
    Map<String, String>? buyInstructions,
    int? minZoomStopsNearYou,
    bool? showStationId,
    bool? useSpacesAvailable,
    bool? showCityBikes,
    Map<String, NetworkConfig>? networks,
    Map<String, FormFactor>? formFactors,
  }) {
    return CityBikeConfig(
      showFullInfo: showFullInfo ?? this.showFullInfo,
      cityBikeMinZoom: cityBikeMinZoom ?? this.cityBikeMinZoom,
      cityBikeSmallIconZoom:
          cityBikeSmallIconZoom ?? this.cityBikeSmallIconZoom,
      fewAvailableCount: fewAvailableCount ?? this.fewAvailableCount,
      buyInstructions: buyInstructions ?? this.buyInstructions,
      minZoomStopsNearYou: minZoomStopsNearYou ?? this.minZoomStopsNearYou,
      showStationId: showStationId ?? this.showStationId,
      useSpacesAvailable: useSpacesAvailable ?? this.useSpacesAvailable,
      showCityBikes: showCityBikes ?? this.showCityBikes,
      networks: networks ?? this.networks,
      formFactors: formFactors ?? this.formFactors,
    );
  }
}

class NetworkConfig {
  String icon;
  String? operator;
  Map<String, String> name;
  String? type;
  List<String>? formFactors;
  bool hideCode;
  bool enabled;
  Map<String, String>? url;
  bool? visibleInSettingsUi;
  SeasonConfig? season;

  NetworkConfig({
    required this.icon,
    this.operator,
    required this.name,
    required this.type,
    this.formFactors,
    this.hideCode = true,
    required this.enabled,
    this.url,
    this.visibleInSettingsUi,
    this.season,
  });
}

class SeasonConfig {
  final DateTime start;
  final DateTime end;
  final DateTime preSeasonStart;

  SeasonConfig({
    required this.start,
    required this.end,
    required this.preSeasonStart,
  });

  factory SeasonConfig.futureSeason() {
    int futureYear = DateTime.now().year + 10;
    return SeasonConfig(
      start: DateTime(futureYear, 1, 1),
      end: DateTime(futureYear, 12, 31),
      preSeasonStart: DateTime(DateTime.now().year, 1, 1),
    );
  }
}

class OperatorConfig {
  String? operatorId;
  String? icon;
  String? iconCode;
  Map<String, String>? name;
  Map<String, String>? url;
  Map<String, String>? colors;

  OperatorConfig({
    this.operatorId,
    this.icon,
    this.iconCode,
    this.name,
    this.url,
    this.colors,
  });
}

class FormFactor {
  Set<String>? operatorIds;
  Set<String>? networkIds;

  FormFactor({
    this.operatorIds,
    this.networkIds,
  });
}
