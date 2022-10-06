import 'package:flutter/material.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';
import 'package:trufi_core/base/widgets/screen/transition_page.dart';

class StadtnaviNoAnimationPage<T> extends TransitionPage<T> {
  StadtnaviNoAnimationPage({
    required Widget child,
    AppLifecycleReactorHandler? appLifecycleReactorHandler,
  }) : super(
          child: Builder(builder: (context) {
            return BaseTrufiPage(
              child: (appLifecycleReactorHandler == null)
                  ? child
                  : NotificationWrapper(
                      appLifecycleReactorHandler: appLifecycleReactorHandler,
                      child: (_) => child,
                    ),
            );
          }),
          pushTransition: PageTransition.none,
          popTransition: PageTransition.none,
        );
}

abstract class AppLifecycleReactorHandler {
  onInitState(BuildContext context);
  onDispose();
}

class NotificationWrapper extends StatefulWidget {
  const NotificationWrapper({
    super.key,
    required this.child,
    required this.appLifecycleReactorHandler,
  });

  final WidgetBuilder child;
  final AppLifecycleReactorHandler appLifecycleReactorHandler;

  @override
  State<NotificationWrapper> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NotificationWrapper> {
  @override
  Widget build(BuildContext context) {
    return widget.child(context);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      widget.appLifecycleReactorHandler.onInitState(context);
    });
  }

  @override
  void dispose() {
    widget.appLifecycleReactorHandler.onDispose();
    super.dispose();
  }
}
