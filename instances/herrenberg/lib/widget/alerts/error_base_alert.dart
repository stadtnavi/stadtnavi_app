import 'package:de_stadtnavi_herrenberg_internal/widget/alerts/base_build_alert.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/localization/app_localization.dart';

class ErrorAlert extends StatelessWidget {
  final String error;
  const ErrorAlert({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final theme = Theme.of(context);
    return BaseBuildAlert(
      title: Text(
        "localization.commonError",
        style: TextStyle(
          color: theme.colorScheme.error,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      content: Text(error),
      actions: const [OKButton()],
    );
  }
}
