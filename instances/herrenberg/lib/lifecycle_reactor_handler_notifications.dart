import 'dart:async';

import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:herrenberg/base_modal_popup.dart';
import 'package:stadtnavi_core/stadtnavi_screen_helper.dart';

class AppLifecycleReactorHandlerNotifications
    implements AppLifecycleReactorHandler {
  AppLifecycleReactorHandlerNotifications();

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;

  @override
  void onInitState(context) {
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message?.notification != null) {
          BaseModalPopup.showAdvancedModal(
            context,
            message: message!,
          );
        }
      },
    );
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        BaseModalPopup.showAdvancedModal(
          context,
          message: message,
        );
      }
    });
    _onMessageSubscription = FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        if (message.notification != null) {
          BaseModalPopup.showAdvancedModal(
            context,
            message: message,
          );
        }
      },
    );
    FirebaseInAppMessaging.instance.triggerEvent('home_event').catchError(
      (error) {
        print("$error");
      },
    );
  }

  @override
  void onDispose() {
    _onMessageOpenedAppSubscription?.cancel();
    _onMessageSubscription?.cancel();
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
