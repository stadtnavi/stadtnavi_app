import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';
import 'package:trufi_core/base/widgets/screen/transition_page.dart';

class StadtnaviNoAnimationPage<T> extends TransitionPage<T> {
  StadtnaviNoAnimationPage({
    required Widget child,
    String? restorationId,
    AppLifecycleReactorHandler? appLifecycleReactorHandler,
  }) : super(
          child: Builder(builder: (context) {
            return BaseTrufiPage(
              child: LifecycleReactorWrapper(
                appLifecycleReactorHandler: appLifecycleReactorHandler,
                child: (_) => child,
              ),
            );
          }),
          pushTransition: PageTransition.none,
          popTransition: PageTransition.none,
          key: ObjectKey(restorationId),
          name: restorationId,
          restorationId: restorationId,
        );
}

abstract class AppLifecycleReactorHandler {
  onInitState(BuildContext context);
  onDispose();
}

class LifecycleReactorWrapper extends StatefulWidget {
  const LifecycleReactorWrapper({
    super.key,
    required this.child,
    required this.appLifecycleReactorHandler,
  });

  final WidgetBuilder child;
  final AppLifecycleReactorHandler? appLifecycleReactorHandler;

  @override
  State<LifecycleReactorWrapper> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LifecycleReactorWrapper>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return widget.child(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      widget.appLifecycleReactorHandler?.onInitState(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final isClose = state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached;
    if (isClose) {
      final payloadDataPlanCubit = context.read<SettingFetchCubit>();
      payloadDataPlanCubit.setDataDate(arriveBy: false);
    }
  }

  @override
  void dispose() {
    widget.appLifecycleReactorHandler?.onDispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
