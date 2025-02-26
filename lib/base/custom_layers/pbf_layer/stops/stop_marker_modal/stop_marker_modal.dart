import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_marker_modal/disruptions/disruptions_alerts_screen.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_marker_modal/right_now_tab/right_now_screen.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_marker_modal/time_table_tab/time_table_screen.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_icon.dart';

class StopMarkerModal extends StatelessWidget {
  final StopFeature stopFeature;
  final int initialIndex;
 final MapLayerCategory category;
  const StopMarkerModal({Key? key, required this.stopFeature, required this.category,this.initialIndex = 0,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
        final targetMapLayerCategory = MapLayerCategory.findCategoryWithProperties(
      category,
      stopFeature.type.toLowerCase(),
    );
    final svgIcon = targetMapLayerCategory?.properties?.iconSvg;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.string(svgIcon ?? ""),
              ),
              Expanded(
                child: Text(
                  stopFeature.name ?? '',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 3,
            initialIndex: initialIndex,
            child: Material(
              color: Colors.white,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: languageCode == 'en' ? "Right now" : "Jetzt"),
                      Tab(
                          text:
                              languageCode == 'en' ? "Timetable" : "Fahrplan"),
                      Tab(
                        child: Row(
                          children: [
                            cautionNoExclNoStrokeIcon(),
                            const SizedBox(width: 4),
                            Text(languageCode == 'en'
                                ? "Disruptions"
                                : "Störungen")
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        RightNowScreen(
                          stopFeature: stopFeature,
                        ),
                        TimeTableScreen(
                          stopFeature: stopFeature,
                        ),
                        DisruptionAlertsScreen(
                          stopFeature: stopFeature,
                        ),
                      ],
                    ),
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
