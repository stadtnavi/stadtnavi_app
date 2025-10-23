import 'package:de_stadtnavi_herrenberg_internal/pages/exception/fetch_online_exception.dart';
import 'package:de_stadtnavi_herrenberg_internal/widget/alerts/build_transit_error_alert.dart';
import 'package:de_stadtnavi_herrenberg_internal/widget/alerts/error_base_alert.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/localization/app_localization.dart';

Future<dynamic> onFetchError(BuildContext context, dynamic exception) async {
  final localization = AppLocalization.of(context);
  switch (exception.runtimeType) {
    case FetchOnlineRequestException:
      return _showErrorAlert(
        context: context,
        error: "localization.commonNoInternet",
      );
    case FetchOnlineResponseException:
      return _showErrorAlert(
        context: context,
        error: "localization.searchFailLoadingPlan",
      );
    case FetchOnlinePlanException:
      return showDialog(
        context: context,
        builder: (dialogContext) =>
            BuildTransitErrorAlert(exception: exception),
      );
    default:
      return _showErrorAlert(context: context, error: exception.toString());
  }
}

Future<void> _showErrorAlert({
  required BuildContext context,
  required String error,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return ErrorAlert(error: error);
    },
  );
}
