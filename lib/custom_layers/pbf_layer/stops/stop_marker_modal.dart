import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/stop_feature_model.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/stops_icon.dart';
import 'package:flutter_svg/svg.dart';

import 'widgets/right_now_screen.dart';
import 'widgets/time_table_screen.dart';

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
            length: 2,
            child: Material(
              color: Colors.white,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: "Right now"),
                      Tab(text: "Timetable"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      RightNowScreen(
                        stopFeature: stopFeature,
                      ),
                      TimeTableScreen(
                        stopFeature: stopFeature,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
