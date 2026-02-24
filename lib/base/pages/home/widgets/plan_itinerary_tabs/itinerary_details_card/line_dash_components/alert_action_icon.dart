import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/otp/models/alert.dart';
import 'package:stadtnavi_core/base/otp/models/enums/alert_severity_level_type.dart';
import 'package:stadtnavi_core/base/models/utils/alert_utils.dart';

class AlertActionIcon extends StatelessWidget {
  static Widget? getActiveAlertSeverityLevel({
    required List<Alert>? alerts,
    required double? referenceUnixTime,
    required VoidCallback ontap,
  }) {
    final activeAlertSeverityLevel = AlertUtils.getActiveAlertSeverityLevel(
      alerts,
      referenceUnixTime,
    );
    return activeAlertSeverityLevel != null
        ? AlertActionIcon(
          alertSeverityLevelType: activeAlertSeverityLevel,
          ontap: ontap,
        )
        : null;
  }

  const AlertActionIcon({
    super.key,
    required this.alertSeverityLevelType,
    required this.ontap,
  });
  final AlertSeverityLevelType alertSeverityLevelType;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: alertSeverityLevelType.getServiceAlertIcon(size: 16),
    );
  }
}
