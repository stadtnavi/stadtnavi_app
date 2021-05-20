import 'package:flutter/material.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/stop_feature_model.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/stops_icon.dart';
import 'package:flutter_svg/svg.dart';

class StopMarkerModal extends StatelessWidget {
  final StopFeature stopFeature;
  const StopMarkerModal({Key key, @required this.stopFeature})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.string(stopsIcons[stopFeature.type] ?? ""),
              ),
              Expanded(
                child: Text(
                  stopFeature.name,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 3,
            child: Material(
              color: Colors.white,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: "Right now"),
                      Tab(text: "Timetable"),
                      Tab(text: "Disruptions"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      Container(
                        color: Colors.redAccent,
                        child: const Center(
                          child: Text(
                            'Right now',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.greenAccent,
                        child: const Center(
                          child: Text(
                            'Timetable',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.blueAccent,
                        child: const Center(
                          child: Text(
                            'Disruptions',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
