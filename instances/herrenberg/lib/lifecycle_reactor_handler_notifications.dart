import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:stadtnavi_core/stadtnavi_screen_helper.dart';

import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';
import 'package:trufi_core/base/widgets/alerts/base_build_alert.dart';

class AppLifecycleReactorHandlerNotifications
    implements AppLifecycleReactorHandler {
  final String? onStartNotificationsURL;

  AppLifecycleReactorHandlerNotifications({
    this.onStartNotificationsURL,
  });

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;

  @override
  void onInitState(context) {
    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        showTrufiDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('${message.notification!.title}'),
                content: Text('${message.notification!.body}'),
              );
            });
      }
    });
    _onMessageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(context, null, message.notification!.title ?? "",
            message.notification!.body ?? "");
      }
    });
    if (onStartNotificationsURL != null) {
      handlerOnStartNotifications(context,onStartNotificationsURL!)
          .then((value) => null)
          .catchError((error) {
        print("$error");
      });
    }
  }

  @override
  void onDispose() {
    _onMessageOpenedAppSubscription?.cancel();
    _onMessageSubscription?.cancel();
  }

  Future<void> handlerOnStartNotifications(BuildContext context, String startNotificationsURL) async {
    final response = await http.get(Uri.parse(startNotificationsURL));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final notifications = data["notifications"] as List;
      if (notifications.isNotEmpty) {
        final notification = notifications[0];
        final notificationId = notification["id"];
        if (await showShowNotification(notificationId)) {
          showNotification(context, notificationId, notification["title"],
              notification["body"]);
        }
      }
    }
  }

  Future<bool> showShowNotification(String? id) async {
    if (id == null) return true;
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final flag = _prefs.getString(id);
    return flag == null;
  }

  Future makeDoNotShowAgain(String id) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(id, id);
  }

  showNotification(
      BuildContext context, String? id, String title, String body) {
    showTrufiDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            NotShowAgain(
              onPressed: () {
                Navigator.pop(_);
                if (id != null) makeDoNotShowAgain(id).catchError((error) {});
              },
            ),
            const OKButton()
          ],
        );
      },
    );
  }
}

class NotShowAgain extends StatelessWidget {
  final VoidCallback? onPressed;

  const NotShowAgain({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = StadtnaviBaseLocalization.of(context);
    final theme = Theme.of(context);
    return TextButton(
      onPressed: onPressed ?? () => Navigator.pop(context),
      child: Text(
        localization.notShowAgain,
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
