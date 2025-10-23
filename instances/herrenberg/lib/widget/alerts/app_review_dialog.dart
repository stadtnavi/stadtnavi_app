import 'dart:io';
import 'package:de_stadtnavi_herrenberg_internal/widget/alerts/base_build_alert.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:trufi_core/localization/app_localization.dart';

class AppReviewDialog extends StatelessWidget {
  static Future<void> showAppReviewDialog(BuildContext context) async {
    if (Platform.isIOS) {
      // Show native app review dialog for iOS users
      await InAppReview.instance.requestReview();
    } else {
      // Show a custom dialog for Android users
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return const AppReviewDialog();
        },
      );
    }
  }

  const AppReviewDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalization.of(context);
    return BaseBuildAlert(
      title: Text("localization.appReviewDialogTitle"),
      content: Text("localization.appReviewDialogContent"),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          child: Text(
            "localization.appReviewDialogButtonDecline",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await InAppReview.instance.requestReview();
          },
          child: Text(
            "localization.appReviewDialogButtonAccept",
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
