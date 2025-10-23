import 'package:de_stadtnavi_herrenberg_internal/widget/alerts/base_build_alert.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trufi_core/localization/app_localization.dart';

class AlertLocationServicesDenied extends StatelessWidget {
  const AlertLocationServicesDenied({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    return BaseBuildAlert(
      title: Text("localization.alertLocationServicesDeniedTitle"),
      content: Text("localization.alertLocationServicesDeniedMessage"),
      actions: [
        OKButton(
          onPressed: () async {
            Navigator.pop(context);
            await Geolocator.openAppSettings();
          },
        ),
      ],
    );
  }
}

class AlertLocationServicesDeniedWeb extends StatelessWidget {
  const AlertLocationServicesDeniedWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    return BaseBuildAlert(
      title: Text("localization.alertLocationServicesDeniedTitle"),
      content: Text("localization.alertLocationServicesDeniedMessage"),
      actions: const [OKButton()],
    );
  }
}
