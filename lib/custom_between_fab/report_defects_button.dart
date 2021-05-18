import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core/blocs/gps_location/location_provider_cubit.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/widgets/alerts.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportDefectsButoon extends StatelessWidget {
  static const String reportDefectsEndpoint =
      'https://www.herrenberg.de/tools/mvs';

  const ReportDefectsButoon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Theme.of(context).backgroundColor,
      onPressed: () async {
        final location =
            context.read<LocationProviderCubit>().state.currentLocation;
        if (location == null) {
          showDialog(
            context: context,
            builder: (context) => buildAlertLocationServicesDenied(context),
          );
        } else {
          final uri = Uri.parse(reportDefectsEndpoint).replace(
            queryParameters: {
              "lat": location.latitude.toString(),
              "lng": location.longitude.toString(),
            },
            fragment: "mvPagePictures",
          );
          await _launch(context, uri.toString());
        }
      },
      heroTag: null,
      child: const Icon(Icons.warning_rounded, color: Colors.black),
    );
  }

  Future<void> _launch(BuildContext context, String uri) async {
    final theme = Theme.of(context);
    final localization = TrufiLocalization.of(context);
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              localization.errorEmailFeedback,
              style: theme.textTheme.bodyText1,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(localization.commonOK),
              )
            ],
          );
        },
      );
    }
  }
}
