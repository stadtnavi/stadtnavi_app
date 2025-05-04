import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/pois_layer.dart';
import 'package:stadtnavi_core/consts.dart';
import './live_bus_layer.dart';
import 'live_bus_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter_svg/svg.dart';

class LiveBusMarkerModal extends StatefulWidget {
  final LiveBusFeature mainElement;

  final OnLiveBusStateChangeContainer? onLiveBusStateChangeContainer;
  const LiveBusMarkerModal({
    Key? key,
    required this.mainElement,
    required this.onLiveBusStateChangeContainer,
  }) : super(key: key);

  @override
  _LiveBusMarkerModalState createState() => _LiveBusMarkerModalState();
}

class _LiveBusMarkerModalState extends State<LiveBusMarkerModal> {
  late LiveBusFeature element;
  bool loading = true;
  String? fetchError;
  Trip? trip;
  @override
  void initState() {
    element = widget.mainElement;
    super.initState();
    widget.onLiveBusStateChangeContainer?.onUpdate = (element) {
      if (mounted) {
        setState(() {
          this.element = element;
        });
      }
    };
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      loadData();
    });
  }

  @override
  void dispose() {
    widget.onLiveBusStateChangeContainer?.dispose();
    super.dispose();
  }
  //   @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((duration) {
  //     loadData();
  //   });
  // }

  @override
  void didUpdateWidget(covariant LiveBusMarkerModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mainElement != widget.mainElement) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadData(),
      );
    }
  }

  Future<void> loadData() async {
    trip = null;
    if (!mounted) return;
    setState(() {
      fetchError = null;
      loading = true;
    });
    await _fetchData("${element.feedId}:${element.tripId}").then((value) {
      if (mounted) {
        setState(() {
          trip = value;
          loading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          fetchError = "$error";
          loading = false;
        });
      }
    });
  }

  Future<Trip> _fetchData(String tripId) async {
    final response = await http.post(
      Uri.parse(ApiConfig().openTripPlannerUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'id': 'SelectVehicleContainerQuery',
        'query': '''
        query SelectVehicleContainerQuery(\$tripId: String!) {
          trip(id: \$tripId) {
            ...TripMarkerPopup_trip
            id
          }
        }

        fragment TripMarkerPopup_trip on Trip {
          gtfsId
          pattern {
            code
            headsign
            stops {
              name
              id
            }
            id
          }
          route {
            gtfsId
            mode
            shortName
            color
            type
            id
          }
        }
      ''',
        'variables': {
          'tripId': tripId,
        },
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return ResponseData.fromJson(jsonData).trip;
    } else {
      throw Exception("Failed to fetch trip data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final targetMapLayerCategory = element.category != null
        ? MapLayerCategory.findCategoryWithProperties(
            element.category!,
            element.mode.toLowerCase(),
          )
        : null;
    final svgIcon = targetMapLayerCategory?.properties?.iconSvg;

    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.string(svgIcon ?? ""),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.mainElement.name,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: fromStringToColor(
                              element.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${languageCode == "en" ? "To " : "Richtung "}${trip?.pattern.headsign ?? ""}",
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            languageCode == "en"
                ? "Position is estimated. Last known location at ${formatUnixTimestamp(element.lastUpdate)}."
                : "Position ist geschätzt. Letzte bekannte Position von ${formatUnixTimestamp(element.lastUpdate)} Uhr.",
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
        // TODO implement stop view
        // OutlinedButton(
        //   onPressed: () async {
        //     final panelCubit = context.read<PanelCubit>();

        //     if (element.category != null) {
        //       panelCubit.setPanel(
        //         CustomMarkerPanel(
        //           panel: (
        //             context,
        //             _, {
        //             isOnlyDestination,
        //           }) =>
        //               StopMarkerModal(
        //             category: element.category!,
        //             stopFeature: StopFeature(
        //               code: null,
        //               gtfsId: "${element.feedId}:${element.routeId}",
        //               name: element.name,
        //               parentStation: null,
        //               patterns: null,
        //               platform: null,
        //               type: element.mode,
        //               position: element.position,
        //             ),
        //           ),
        //           position: element.position,
        //           minSize: 130,
        //         ),
        //       );
        //     }
        //   },
        //   child: Text(
        //     languageCode == "en" ? "Trip information" : "Reiseinformationen",
        //     style: TextStyle(color: theme.primaryColor),
        //   ),
        // ),
      ],
    );
  }

  String formatUnixTimestamp(int unixTimestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);

    return DateFormat.Hms().format(date);
  }
}

class Stop {
  final String name;
  final String id;

  Stop({required this.name, required this.id});

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      name: json['name'],
      id: json['id'],
    );
  }
}

class Pattern {
  final String code;
  final String headsign;
  final List<Stop> stops;
  final String id;

  Pattern({
    required this.code,
    required this.headsign,
    required this.stops,
    required this.id,
  });

  factory Pattern.fromJson(Map<String, dynamic> json) {
    return Pattern(
      code: json['code'],
      headsign: json['headsign'],
      stops: (json['stops'] as List).map((i) => Stop.fromJson(i)).toList(),
      id: json['id'],
    );
  }
}

class Route {
  final String gtfsId;
  final String mode;
  final String shortName;
  final String color;
  final int type;
  final String id;

  Route({
    required this.gtfsId,
    required this.mode,
    required this.shortName,
    required this.color,
    required this.type,
    required this.id,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      gtfsId: json['gtfsId'],
      mode: json['mode'],
      shortName: json['shortName'],
      color: json['color'],
      type: json['type'],
      id: json['id'],
    );
  }
}

class Trip {
  final String gtfsId;
  final Pattern pattern;
  final Route route;
  final String id;

  Trip({
    required this.gtfsId,
    required this.pattern,
    required this.route,
    required this.id,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      gtfsId: json['gtfsId'],
      pattern: Pattern.fromJson(json['pattern']),
      route: Route.fromJson(json['route']),
      id: json['id'],
    );
  }
}

class ResponseData {
  final Trip trip;

  ResponseData({required this.trip});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      trip: Trip.fromJson(json['data']['trip']),
    );
  }
}
