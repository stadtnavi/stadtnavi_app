import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_marker_modal/time_table_tab/date_day_picker.dart';
import 'package:stadtnavi_core/base/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/pattern.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';

import '../../stop_feature_model.dart';

class TimeTableScreen extends StatefulWidget {
  final StopFeature stopFeature;
  const TimeTableScreen({
    Key? key,
    required this.stopFeature,
  }) : super(key: key);

  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen>
    with AutomaticKeepAliveClientMixin<TimeTableScreen> {
  PatternOtp? pattern;
  Map<String, List<TimeTableStop>>? stoptimesByDay;

  DateTime selecetedDate = DateTime.now();
  bool loading = true;
  String? fetchError;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _fetchStopData();
    });
  }

  Future<void> _fetchStopData({DateTime? date}) async {
    if (!mounted) return;
    setState(() {
      fetchError = null;
      loading = true;
    });
    await LayersRepository.fetchTimeTable(widget.stopFeature.gtfsId,
            date: date)
        .then((value) {
      if (mounted) {
        setState(() {
          pattern = value.stoptimesForServiceDate?[0].pattern;
          stoptimesByDay = value.stoptimesByDay;
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        if (loading)
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        else if (stoptimesByDay != null)
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                itemCount: stoptimesByDay!.length,
                itemBuilder: (contextBuilde, index) {
                  final stopTimeKey = stoptimesByDay!.keys.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == 0)
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  final tempPickedDate =
                                      await showModalBottomSheet<DateTime>(
                                    context: context,
                                    isDismissible: false,
                                    builder: (BuildContext builder) {
                                      return DateDayPicker(
                                        dateTime: selecetedDate,
                                      );
                                    },
                                  );
                                  if (tempPickedDate != null) {
                                    selecetedDate = tempPickedDate;
                                    _fetchStopData(date: tempPickedDate);
                                  }
                                },
                                child: Text(DateFormat('yyyy-MM-dd HH-mm')
                                    .format(selecetedDate)),
                              ),
                              const Divider(
                                height: 0,
                                color: Colors.black87,
                                indent: 16,
                                endIndent: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  languageCode == 'en'
                                      ? "Departures by hour (minutes/route)"
                                      : "Abfahrten nach Stunde (Minuten / Strecke)",
                                  style: theme.textTheme. bodyLarge?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Text(
                          stoptimesByDay![stopTimeKey]?[0].hourTime ?? '',
                          style: theme.textTheme. bodyLarge?.copyWith(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 5),
                        Wrap(
                          children: [
                            ...stoptimesByDay![stopTimeKey]
                                    ?.map((e) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Text(
                                            "${e.minuteTime}/${e.name}",
                                            style: theme.textTheme. bodyLarge
                                                ?.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ))
                                    .toList() ??
                                [],
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        else
          Text(
            fetchError ?? '',
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TimeTableStop {
  final String? id;
  final String? name;
  final String? headsign;
  final String? longName;
  final double? serviceDay;
  final int? scheduledDeparture;
  final bool? isCanceled;
  final TransportMode? mode;

  TimeTableStop({
    required this.id,
    required this.name,
    required this.headsign,
    required this.longName,
    required this.serviceDay,
    required this.scheduledDeparture,
    required this.isCanceled,
    required this.mode,
  });

  DateTime get dateTime {
    final int timestamp =
        ((serviceDay ?? 0) + (scheduledDeparture ?? 0)).toInt();
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  String get hourTime => DateFormat('HH').format(dateTime);

  String get minuteTime => DateFormat('mm').format(dateTime);

  String get dayTime => DateFormat('dd').format(dateTime);
}
