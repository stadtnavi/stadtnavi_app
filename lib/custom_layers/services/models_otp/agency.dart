import 'package:meta/meta.dart';

import 'alert.dart';
import 'route.dart';

class Agency {
  int id;
  String gtfsId;
  String name;
  String url;
  String timezone;
  String lang;
  String phone;
  String fareUrl;
  List<Route> routes;
  List<Alert> alerts;

  Agency({
    @required this.id,
    @required this.gtfsId,
    @required this.name,
    @required this.url,
    @required this.timezone,
    @required this.lang,
    @required this.phone,
    @required this.fareUrl,
    @required this.routes,
    @required this.alerts,
  });

  factory Agency.fromJson(Map<String, dynamic> json) => Agency(
        id: int.tryParse(json['id'].toString()) ?? 0,
        gtfsId: json['gtfsId'].toString(),
        name: json['name'].toString(),
        url: json['url'].toString(),
        timezone: json['timezone'].toString(),
        lang: json['lang'].toString(),
        phone: json['phone'].toString(),
        fareUrl: json['fareUrl'].toString(),
        routes: json['routes'] != null
            ? List.generate(
                (json['routes'] as List).length,
                (index) => Route.fromJson(
                    json['routes'][index] as Map<String, dynamic>))
            : null,
        alerts: json['alerts'] != null
            ? List.generate(
                (json['alerts'] as List).length,
                (index) => Alert.fromJson(
                    json['alerts'][index] as Map<String, dynamic>))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gtfsId': gtfsId,
        'name': name,
        'url': url,
        'timezone': timezone,
        'lang': lang,
        'phone': phone,
        'fareUrl': fareUrl,
        'routes': List<dynamic>.from(routes.map((x) => x.toJson())),
        'alerts': List<dynamic>.from(alerts.map((x) => x.toJson())),
      };
}
