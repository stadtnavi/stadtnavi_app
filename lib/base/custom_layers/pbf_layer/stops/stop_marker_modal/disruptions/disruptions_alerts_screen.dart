import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/widgets/alert_card.dart';
import 'package:stadtnavi_core/base/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_core/base/models/othermodel/alert.dart';
import 'package:stadtnavi_core/base/models/utils/alert_utils.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

import '../../stop_feature_model.dart';

class DisruptionAlertsScreen extends StatefulWidget {
  final StopFeature stopFeature;
  const DisruptionAlertsScreen({
    Key? key,
    required this.stopFeature,
  }) : super(key: key);

  @override
  _DisruptionAlertsScreenState createState() => _DisruptionAlertsScreenState();
}

class _DisruptionAlertsScreenState extends State<DisruptionAlertsScreen>
    with AutomaticKeepAliveClientMixin<DisruptionAlertsScreen> {
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
    await LayersRepository.stopAlerts(idStop: widget.stopFeature.gtfsId)
        .then((value) {
      if (mounted) {
        final validAlerts = value.alerts
                ?.where(
                  (alert) => AlertUtils.isAlertValid(
                      alert, DateTime.now().millisecondsSinceEpoch / 1000),
                )
                .toList() ??
            [];
        setState(() {
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
              child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: alerts!.isNotEmpty
                    ? alerts!
                        .map(
                          (e) => Column(
                            children: [
                              AlertStopCard(
                                shortName: null,
                                startDateTime:
                                    DateTime.fromMillisecondsSinceEpoch(
                                  e.effectiveStartDate!.toInt() * 1000,
                                ),
                                endDateTime:
                                    DateTime.fromMillisecondsSinceEpoch(
                                  e.effectiveEndDate!.toInt() * 1000,
                                ),
                                content: e.alertDescriptionText ?? "",
                                alertUrl: e.alertUrl,
                                transportMode: null,
                                transportColor: null,
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
