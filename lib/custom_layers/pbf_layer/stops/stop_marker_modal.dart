import 'package:flutter/cupertino.dart';
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
                              _TimeTable(stoptimesByDay: stops.stoptimesByDay),
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
            if (indexNextDay == index)
              _TitleDay(
                stoptime: stoptimes[index + 1],
              ),
            CustomStopTile(
              stopTime: stopTime,
              isLastStop: stoptimes.length - 1 == index,
            ),
            if (indexNextDay - 1 == index)
              _TitleDay(
                stoptime: stoptimes[index + 1],
              ),
          ],
        );
      },
    );
  }
}

class _TimeTable extends StatelessWidget {
  const _TimeTable({
    Key key,
    @required this.stoptimesByDay,
  }) : super(key: key);

  final Map<String, List<Stoptime>> stoptimesByDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: stoptimesByDay.length,
      itemBuilder: (contextBuilde, index) {
        final stopTimeKey = (stoptimesByDay.keys.toList())[index];
        final now = DateTime.now();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Departures by hour (minutes/route)",
                        style: theme.textTheme.bodyText1.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      child: CupertinoDatePicker(
                        onDateTimeChanged: (picked) {
                          // tempDateConf = tempDateConf.copyWith(date: picked);
                        },
                        use24hFormat: true,
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: now,
                        minimumDate: now,
                        maximumDate: now.add(const Duration(days: 30)),
                        // minuteInterval: 15,
                      ),
                    ),
                  ],
                ),
              Text(
                stopTimeKey,
                style: theme.textTheme.bodyText1
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 5),
              Wrap(
                children: [
                  ...stoptimesByDay[stopTimeKey]
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(
                              "${DateFormat('mm').format(e.dateTime)}/${e.trip.route.shortName}",
                              style: theme.textTheme.bodyText1.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class _TitleDay extends StatelessWidget {
  const _TitleDay({
    Key key,
    @required this.stoptime,
  })  : assert(stoptime != null),
        super(key: key);

  final Stoptime stoptime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            DateFormat('EEEE  dd.MM.yyyy').format(stoptime.dateTime),
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
    );
  }
}
