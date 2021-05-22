import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stadtnavi_app/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_app/custom_layers/services/models_otp/stop.dart';

import 'package:stadtnavi_app/custom_layers/services/models_otp/stoptime.dart';

import '../stop_feature_model.dart';
import 'custom_stop_tile.dart';

class RightNowScreen extends StatefulWidget {
  final StopFeature stopFeature;
  const RightNowScreen({
    Key key,
    @required this.stopFeature,
  }) : super(key: key);

  @override
  _RightNowScreenState createState() => _RightNowScreenState();
}

class _RightNowScreenState extends State<RightNowScreen> {
  List<Stoptime> stoptimes;
  int indexNextDay = -1;
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
    log("message");
    setState(() {
      fetchError = null;
      loading = true;
    });
    LayersRepository().fetchStop(widget.stopFeature.gtfsId).then((value) {
      setState(() {
        stoptimes = value.stoptimesWithoutPatternsCurrent;
        indexNextDay = stoptimes.indexWhere((element) => element.isNextDay);
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
      children: [
        if (loading)
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        if (stoptimes != null)
          (fetchError == null && stoptimes != null)
              ? Expanded(
                  child: ListView.builder(
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
