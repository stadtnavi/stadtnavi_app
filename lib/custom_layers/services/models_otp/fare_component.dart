import 'route.dart';

class FareComponent {
  String fareId;
  String currency;
  int cents;
  List<Route> routes;

  FareComponent({this.fareId, this.currency, this.cents, this.routes});

  factory FareComponent.fromJson(Map<String, dynamic> json) => FareComponent(
        fareId: json['fareId'] as String,
        currency: json['currency'] as String,
        cents: int.tryParse(json['cents'].toString()) ?? 0,
        routes: json['routes'] != null
            ? List<Route>.from((json["routes"] as List<dynamic>).map(
                (x) => Route.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'fareId': fareId,
        'currency': currency,
        'cents': cents,
        'routes': List<dynamic>.from(routes.map((x) => x.toJson())),
      };
}
