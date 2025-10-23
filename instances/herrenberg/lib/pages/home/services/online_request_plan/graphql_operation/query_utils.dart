import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:trufi_core/extensions/stadtnavi_models/enums_plan/enums_plan.dart';
import 'package:trufi_core/extensions/utils/geo_utils.dart';
import 'package:trufi_core/models/enums/transport_mode.dart';
import 'package:trufi_core/screens/route_navigation/maps/trufi_map_controller.dart';

String parsePlace(TrufiLocation location) {
  return "${location.description}::${location.position.latitude},${location.position.longitude}";
}

List<Map<String, String>> parseBikeAndPublicModes(List<TransportMode> list) {
  final dataParse = list
      .map((e) => <String, String>{'mode': e.name})
      .where((e) => e['mode'] != TransportMode.bicycle.name)
      .toList();
  dataParse.add({"mode": TransportMode.bicycle.name});
  return dataParse;
}

List<Map<String, String>> parsebikeParkModes(List<TransportMode> list) {
  final dataParse = list
      .map((e) => <String, String>{'mode': e.name})
      .where((e) => e['mode'] != TransportMode.bicycle.name)
      .toList();
  dataParse.add({"mode": TransportMode.bicycle.name, 'qualifier': 'PARK'});
  return dataParse;
}

Map<String, String?> parseCarMode(LatLng destiny) {
  final bool isInHerrenbergOldTown = insidePointInPolygon(
    destiny,
    herrenbergOldTown,
  );

  return {
    "mode": TransportMode.car.name,
    if (isInHerrenbergOldTown) 'qualifier': 'PARK',
  };
}

List<Map<String, String?>> parseTransportModes(List<TransportMode> list) {
  final dataParse = list
      .map((e) => <String, String?>{'mode': e.name, 'qualifier': e.qualifier})
      .toList();
  return dataParse;
}

List<String> parseBikeRentalNetworks(List<BikeRentalNetwork> list) {
  final dataParse = list.map((e) => e.name).toList();
  return dataParse;
}

String parseDateFormat(DateTime? date) {
  final tempDate = date ?? DateTime.now();
  return DateFormat('yyyy-MM-dd').format(tempDate);
}

String parseTime(DateTime? date) {
  final tempDate = date ?? DateTime.now();
  return DateFormat('HH:mm:ss').format(tempDate);
}
