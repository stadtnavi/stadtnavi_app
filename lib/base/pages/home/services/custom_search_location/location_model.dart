import 'package:trufi_core/base/models/trufi_place.dart';

class LocationModel {
  LocationModel({
    this.geometry,
    this.type,
    this.properties,
  });

  Geometry? geometry;
  String? type;
  Properties? properties;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        geometry: Geometry.fromJson(json["geometry"] as Map<String, dynamic>),
        type: json["type"].toString(),
        properties:
            Properties.fromJson(json["properties"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "geometry": geometry?.toJson(),
        "type": type,
        "properties": properties?.toJson(),
      };
  TrufiLocation toTrufiLocation() {
    String? houseDetails;
    if (properties?.housenumber != "null" && properties?.street != "null") {
      houseDetails = "${properties?.housenumber} ${properties?.street}, ";
    } else if (properties?.housenumber != "null") {
      houseDetails = "${properties?.housenumber}, ";
    } else if (properties?.street != "null") {
      houseDetails = "${properties?.street}, ";
    }

    String? streetDetails;
    if (properties?.postalcode != "null" && properties?.locality != "null") {
      streetDetails = "${properties?.postalcode} ${properties?.locality}";
    } else if (properties?.postalcode != "null") {
      streetDetails = properties?.postalcode;
    } else if (properties?.locality != "null") {
      streetDetails = properties?.locality;
    }

    String addressDetails = "";
    if (houseDetails != null && streetDetails != null) {
      addressDetails = "$houseDetails$streetDetails";
    } else if (houseDetails != null) {
      addressDetails = houseDetails;
    } else if (streetDetails != null) {
      addressDetails = streetDetails;
    }

    return TrufiLocation(
      description: properties?.name ?? 'not description',
      latitude: geometry?.coordinates?[1] ?? 0,
      longitude: geometry?.coordinates?[0] ?? 0,
      address: addressDetails,
    );
  }
}

class Geometry {
  Geometry({
    this.coordinates,
    this.type,
  });

  List<double>? coordinates;
  String? type;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates: List<double>.from(
            (json["coordinates"] as List).map((x) => x.toDouble())),
        type: json["type"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from((coordinates ?? []).map((x) => x)),
        "type": type,
      };
}

class Properties {
  Properties({
    this.osmId,
    this.extent,
    this.country,
    this.city,
    this.countrycode,
    this.locality,
    this.type,
    this.osmType,
    this.osmKey,
    this.housenumber,
    this.street,
    this.district,
    this.osmValue,
    this.name,
    this.region,
    this.postalcode,
    this.label,
    this.layer,
    this.county,
  });

  int? osmId;
  List<double>? extent;
  String? country;
  String? city;
  String? countrycode;
  String? locality;
  String? type;
  String? osmType;
  String? osmKey;
  String? housenumber;
  String? street;
  String? district;
  String? osmValue;
  String? name;
  String? region;
  String? postalcode;
  String? label;
  String? layer;
  String? county;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        osmId: int.tryParse(json["osm_id"].toString()) ?? 0,
        extent: json["extent"] == null
            ? null
            : List<double>.from(
                (json["extent"] as List)
                    .map((x) => double.tryParse(x.toString()) ?? 0.0),
              ),
        country: json["country"].toString(),
        city: json["city"].toString(),
        countrycode: json["countrycode"].toString(),
        locality: json["locality"].toString(),
        type: json["type"].toString(),
        osmType: json["osm_type"].toString(),
        osmKey: json["osm_key"].toString(),
        housenumber: json["housenumber"].toString(),
        street: json["street"].toString(),
        district: json["district"].toString(),
        osmValue: json["osm_value"].toString(),
        name: json["name"].toString(),
        region: json["region"].toString(),
        postalcode: json["postalcode"].toString(),
        label: json["label"].toString(),
        layer: json["layer"].toString(),
        county: json["county"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "osm_id": osmId,
        "extent":
            extent == null ? null : List<dynamic>.from(extent!.map((x) => x)),
        "country": country,
        "city": city,
        "countrycode": countrycode,
        "locality": locality,
        "type": type,
        "osm_type": osmType,
        "osm_key": osmKey,
        "housenumber": housenumber,
        "street": street,
        "district": district,
        "osm_value": osmValue,
        "name": name,
        "region": region,
        "postalcode": postalcode,
        "label": label,
        "layer": layer,
        "county": county,
      };
}
