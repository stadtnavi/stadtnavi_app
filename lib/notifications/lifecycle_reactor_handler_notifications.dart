import 'dart:async';

import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stadtnavi_core/notifications/firebase_push_notification_modal.dart';
import 'package:stadtnavi_core/stadtnavi_screen_helper.dart';

class LifecycleReactorHandlerNotifications
    implements AppLifecycleReactorHandler {
  LifecycleReactorHandlerNotifications({
    required this.hasPushNotifications,
    required this.hasInAppNotifications,
  });

  final bool hasPushNotifications;
  final bool hasInAppNotifications;

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;

  @override
  void onInitState(context) {
    if (hasPushNotifications) {
      FirebaseMessaging.instance.getInitialMessage().then(
        (RemoteMessage? message) {
          if (message?.notification != null) {
            FirebasePushNotificationModal.showAdvancedModal(
              context,
              message: message!,
            );
          }
        },
      );
      _onMessageOpenedAppSubscription =
          FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.notification != null) {
          FirebasePushNotificationModal.showAdvancedModal(
            context,
            message: message,
          );
        }
      });
      _onMessageSubscription = FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          if (message.notification != null) {
            FirebasePushNotificationModal.showAdvancedModal(
              context,
              message: message,
            );
          }
        },
      );
    }
    if (hasInAppNotifications) {
      FirebaseInAppMessaging.instance.triggerEvent('home_event').catchError(
        (error) {
          print("$error");
        },
      );
    }
  }

  @override
  void onDispose() {
    if (hasPushNotifications) {
      _onMessageOpenedAppSubscription?.cancel();
      _onMessageSubscription?.cancel();
    }
  }

  // showNotification(
  //   BuildContext context,
  //   String? id,
  //   String title,
  //   String body,
  // ) {
  //   showTrufiDialog(
  //     context: context,
  //     builder: (_) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: Text(body),
  //         actions: [
  //           NotShowAgain(
  //             onPressed: () {
  //               Navigator.pop(_);
  //               if (id != null) makeDoNotShowAgain(id).catchError((error) {});
  //             },
  //           ),
  //           const OKButton()
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future makeDoNotShowAgain(String id) async {
  //   final SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   _prefs.setString(id, id);
  // }
}

// class NotShowAgain extends StatelessWidget {
//   final VoidCallback? onPressed;

//   const NotShowAgain({
//     Key? key,
//     this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final localization = StadtnaviBaseLocalization.of(context);
//     final theme = Theme.of(context);
//     return TextButton(
//       onPressed: onPressed ?? () => Navigator.pop(context),
//       child: Text(
//         localization.notShowAgain,
//         style: TextStyle(
//           color: theme.colorScheme.secondary,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
