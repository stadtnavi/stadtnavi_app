import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/stop_feature_model.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/stops_icon.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/widgets/custom_stop_tile.dart';
import 'package:stadtnavi_app/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_app/custom_layers/services/models_otp/stop.dart';
import 'package:stadtnavi_app/custom_layers/services/models_otp/stoptime.dart';

class StopMarkerModal extends StatefulWidget {
  final StopFeature stopFeature;
  const StopMarkerModal({Key key, @required this.stopFeature})
      : super(key: key);

  @override
  _StopMarkerModalState createState() => _StopMarkerModalState();
}

class _StopMarkerModalState extends State<StopMarkerModal> {
  Stop stops;
  bool loading = true;
  String fetchError;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _fetchStopData();
    });
  }

  void _fetchStopData() {
    setState(() {
      fetchError = null;
      stops = null;
      loading = true;
    });
    LayersRepository().fetchStop(widget.stopFeature.gtfsId).then((value) {
      setState(() {
        stops = value;
        loading = false;
      });
    }).catchError((error) {
      setState(() {
        fetchError = "$error";
        loading = false;
      });
    });
  }

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
                child: SvgPicture.string(
                    stopsIcons[widget.stopFeature.type] ?? ""),
              ),
              Expanded(
                child: Text(
                  widget.stopFeature.name,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        if (loading)
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        if (!loading)
          (fetchError == null)
              ? Expanded(
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
                              _RightNowScreen(
                                  stoptimes:
                                      stops.stoptimesWithoutPatternsCurrent),
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
                )
              : Text(
                  fetchError,
                  style: const TextStyle(color: Colors.red),
                ),
      ],
    );
  }
}

class _RightNowScreen extends StatelessWidget {
  const _RightNowScreen({
    Key key,
    @required this.stoptimes,
  }) : super(key: key);

  final List<Stoptime> stoptimes;

  @override
  Widget build(BuildContext context) {
    final indexNextDay = stoptimes.indexWhere((element) => element.isNextDay);
    return ListView.builder(
      itemCount: stoptimes.length,
      itemBuilder: (contextBuilde, index) {
        final Stoptime stopTime = stoptimes[index];
        return Column(
          children: [
            CustomStopTile(
              stopTime: stopTime,
              isLastStop: stoptimes.length - 1 == index,
            ),
            if (indexNextDay - 1 == index)
              Column(
                children: [
                  ListTile(
                    title: Text(
                      DateFormat('EEEE  dd.MM.yyyy')
                          .format(stoptimes[index + 1].stopTime),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    color: Colors.black87,
                    indent: 16,
                    endIndent: 20,
                  ),
                ],
              )
          ],
        );
      },
    );
  }
}
