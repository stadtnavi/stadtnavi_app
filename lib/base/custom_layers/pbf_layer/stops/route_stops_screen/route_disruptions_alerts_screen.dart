import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/widgets/alert_card.dart';

import 'package:stadtnavi_core/base/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_core/base/models/othermodel/alert.dart';
import 'package:stadtnavi_core/base/models/othermodel/route.dart';
import 'package:stadtnavi_core/base/models/utils/alert_utils.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

class RouteDisruptionAlertsScreen extends StatefulWidget {
  final String routeId;
  final String patternId;
  const RouteDisruptionAlertsScreen({
    Key? key,
    required this.routeId,
    required this.patternId,
  }) : super(key: key);

  @override
  _RouteDisruptionAlertsScreenState createState() =>
      _RouteDisruptionAlertsScreenState();
}

class _RouteDisruptionAlertsScreenState
    extends State<RouteDisruptionAlertsScreen>
    with AutomaticKeepAliveClientMixin<RouteDisruptionAlertsScreen> {
  RouteOtp? route;
  List<Alert>? alerts;
  // Map<String, List<TimeTableStop>>? stoptimesByDay;

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

  Future<void> _fetchStopData() async {
    if (!mounted) return;
    setState(() {
      fetchError = null;
      loading = true;
    });
    await LayersRepository.routeAlerts(
      routeId: widget.routeId,
      patternId: widget.patternId,
    ).then((value) {
      if (mounted) {
        final validAlerts = value.pattern.alerts
                ?.where(
                  (alert) => AlertUtils.isAlertValid(
                      alert, DateTime.now().millisecondsSinceEpoch / 1000),
                )
                .toList() ??
            [];

        setState(() {
          route = value.route;
          alerts = validAlerts;
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
    final stLocalization = StadtnaviBaseLocalization.of(context);
    return Column(
      children: [
        if (loading)
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        else if (alerts != null)
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: alerts!.isNotEmpty
                  ? alerts!
                      .map(
                        (e) => Column(
                          children: [
                            AlertStopCard(
                              shortName: route!.shortName ?? "",
                              startDateTime:
                                  DateTime.fromMillisecondsSinceEpoch(
                                e.effectiveStartDate!.toInt() * 1000,
                              ),
                              endDateTime: DateTime.fromMillisecondsSinceEpoch(
                                e.effectiveEndDate!.toInt() * 1000,
                              ),
                              content: e.alertDescriptionTextTranslations
                                      ?.firstOrNull?.text ??
                                  "",
                              alertUrl: e.alertUrl,
                              transportMode: route!.mode,
                              transportColor: route?.color != null
                                  ? Color(int.tryParse('0xFF${route!.color}')!)
                                  : null,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                          ],
                        ),
                      )
                      .toList()
                  : [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            stLocalization.disruptionInfoNoAlerts,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                      )
                    ],
            ),
          ))
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
