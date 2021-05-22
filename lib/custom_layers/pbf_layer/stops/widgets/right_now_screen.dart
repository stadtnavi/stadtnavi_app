import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stadtnavi_app/custom_layers/services/layers_repository.dart';

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

class _RightNowScreenState extends State<RightNowScreen>
    with AutomaticKeepAliveClientMixin {
  List<Stoptime> stoptimes;
  int indexNextDay = -1;
  bool loading = true;
  String fetchError;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _fetchStopData();
    });
  }

  Future<void> _fetchStopData() async {
    if (!mounted) return;
    setState(() {
      fetchError = null;
      loading = true;
    });
    await LayersRepository().fetchStop(widget.stopFeature.gtfsId).then((value) {
      if (mounted) {
        setState(() {
          stoptimes = value.stoptimesWithoutPatternsCurrent;
          indexNextDay = stoptimes.indexWhere((element) => element.isNextDay);
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
    await Future.delayed(const Duration(seconds: 30));
    if (mounted) _fetchStopData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        if (stoptimes != null)
          Expanded(
            child: ListView.builder(
              itemCount: stoptimes.length,
              itemBuilder: (contextBuilde, index) {
                final Stoptime stopTime = stoptimes[index];
                return Column(
                  children: [
                    if (indexNextDay == index && index == 0)
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
        else if (loading)
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        else
          Text(
            fetchError,
            style: const TextStyle(color: Colors.red),
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
