import 'package:flutter/material.dart';
import 'package:async_executor/async_executor.dart';
import 'package:rive/rive.dart';
import 'package:trufi_core/base/widgets/alerts/fetch_error_handler.dart';

import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

AsyncExecutor customAsyncExecutor = AsyncExecutor(
  loadingMessage: (
    BuildContext context,
  ) async {
    return await showTrufiDialog(
      context: context,
      barrierDismissible: false,
      onWillPop: false,
      builder: (context) {
        return const RiveAnimation.asset(
          'assets/images/loading.riv',
          animations: ["Trufi Drive"],
        );
      },
    );
  },
  errorMessage: (BuildContext context, dynamic error) async {
    return await onFetchError(context, error);
  },
);
