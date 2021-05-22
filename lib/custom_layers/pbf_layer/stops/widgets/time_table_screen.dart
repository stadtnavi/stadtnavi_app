import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stadtnavi_app/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_app/custom_layers/services/models_otp/pattern.dart';

import 'package:stadtnavi_app/custom_layers/services/models_otp/stoptime.dart';

import '../stop_feature_model.dart';

class TimeTableScreen extends StatefulWidget {
  final StopFeature stopFeature;
  const TimeTableScreen({
    Key key,
    @required this.stopFeature,
  }) : super(key: key);

  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen>
    with AutomaticKeepAliveClientMixin<TimeTableScreen> {
  PatternOtp pattern;
  Map<String, List<Stoptime>> stoptimesByDay;
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
      pattern = null;
      stoptimesByDay = null;
      loading = true;
    });
    LayersRepository().fetchTimeTable(widget.stopFeature.gtfsId).then((value) {
      setState(() {
        pattern = value.stoptimesForServiceDate[0].pattern;
        stoptimesByDay = value.stoptimesByDay;
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
    final theme = Theme.of(context);
    return Column(
      children: [
        if (loading)
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        else
          (fetchError == null && stoptimesByDay != null)
              ? Expanded(
                  child: ListView.builder(
                    itemCount: stoptimesByDay.length,
                    itemBuilder: (contextBuilde, index) {
                      final stopTimeKey = (stoptimesByDay.keys.toList())[index];
                      final now = DateTime.now();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0)
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Text(
                                      "Departures by hour (minutes/route)",
                                      style: theme.textTheme.bodyText1.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  // ignore: sized_box_for_whitespace
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
                                      maximumDate:
                                          now.add(const Duration(days: 30)),
                                      // minuteInterval: 15,
                                    ),
                                  ),
                                ],
                              ),
                            Text(
                              stopTimeKey,
                              style: theme.textTheme.bodyText1.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 5),
                            Wrap(
                              children: [
                                ...stoptimesByDay[stopTimeKey]
                                    .map((e) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Text(
                                            "${DateFormat('mm').format(e.dateTime)}/${pattern.route.shortName}",
                                            style: theme.textTheme.bodyText1
                                                .copyWith(
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
                  ),
                )
              : Center(
                  child: Text(
                    fetchError,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
