class ChargingItem {
  String? uid;
  String? name;
  String? address;
  String? city;
  String? postalCode;
  Map? openingTimes;
  String? lastUpdated;
  List<ChargingDetail>? evses;
  Map<String, ChargingConnector> connectors = {};

  Set<String> capabilities = {};
  ChargingItem.fromJson(Map map)
      : uid = map["uid"]?.toString(),
        name = (map["name"] ?? map["address"]).toString(),
        address = map["address"]?.toString() ?? "",
        city = map["city"]?.toString() ?? "",
        postalCode = map["postal_code"]?.toString() ?? "",
        openingTimes = map["opening_times"] as Map?,
        lastUpdated = map["last_updated"]?.toString(),
        evses = (map["evses"] as List?)
            ?.map((item) => ChargingDetail.fromJson(item as Map))
            .toList() {
    for (final detail in evses ?? []) {
      if (detail.connectors == null) return;
      for (final item in detail.connectors!) {
        final maxElectricPower = item["max_electric_power"] is num
            ? ((item["max_electric_power"] / 1000) as double).floor().toString()
            : '';
        connectors[item["standard"].toString()] = ChargingConnector(
          item["standard"]?.toString() ?? '',
          maxElectricPower,
        );
      }
      capabilities.addAll(detail.capabilities ?? []);
    }
  }

  int get showCapacity {
    return (evses ?? [])
        .where(
          (evse) => evse.status == 'UNKNOWN' || evse.status == 'STATIC',
        )
        .length;
  }
}

class ChargingConnector {
  final String standard;
  final String maxElectricPower;

  ChargingConnector(this.standard, this.maxElectricPower);
}

class ChargingDetail {
  String? id;
  String? status;
  String? phone;
  List<String>? capabilities;
  List<String>? parkingRestrictions;
  List? connectors;
  List<Map>? relatedResource;

  ChargingDetail.fromJson(Map map)
      : id = map["evse_id"]?.toString(),
        status = map["status"]?.toString(),
        phone = map["phone"]?.toString(),
        relatedResource = (map["related_resource"] as List?)
            ?.map<Map>((e) => e as Map)
            .toList(),
        capabilities = (map["capabilities"] as List?)
            ?.map<String>((element) => "$element")
            .toList(),
        parkingRestrictions = (map["parking_restrictions"] as List?)
            ?.map<String>((element) => "$element")
            .toList(),
        connectors = map["connectors"] as List?;
}

final capabilitiesNameEN = {
  "RFID_READER": "RFID",
  "CREDIT_CARD_PAYABLE": "Credit Card",
  "DEBIT_CARD_PAYABLE": "Debit Card",
  "CONTACTLESS_CARD_SUPPORT": "Contactless",
};
final capabilitiesNameDE = {
  "RFID_READER": "RFID",
  "CREDIT_CARD_PAYABLE": "Kreditkarte",
  "DEBIT_CARD_PAYABLE": "Debitkarte",
  "CONTACTLESS_CARD_SUPPORT": "Kontaktlos",
};
