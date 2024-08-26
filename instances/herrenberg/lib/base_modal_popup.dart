import "dart:io";

import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter/material.dart";
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';
import "package:url_launcher/url_launcher.dart";
import "package:cached_network_image/cached_network_image.dart";

class BaseModalPopup extends StatelessWidget {
  static Future<T?> showAdvancedModal<T>(
    BuildContext buildContext, {
    required RemoteMessage message,
  }) async =>
      showTrufiDialog<T?>(
        context: buildContext,
        barrierColor: Colors.black54,
        builder: (buildContext) => BaseModalPopup(message: message),
      );

  const BaseModalPopup({
    super.key,
    required this.message,
  });

  final RemoteMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final notification = message.notification;
    final imageUrl = Platform.isAndroid
        ? notification?.android?.imageUrl
        : notification?.apple?.imageUrl;
    final buttons = message.data.entries.toList();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: isPortrait ? 30 : 60,
            vertical: isPortrait ? 60 : 10,
          ),
          constraints: const BoxConstraints(
            minHeight: 50,
            maxHeight: 800,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 20,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 12,
                  top: 8,
                  bottom: 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Text(
                          notification?.title ?? "",
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: IconButton(
                          tooltip: "close",
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isPortrait)
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 27,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (imageUrl != null)
                            Container(
                              margin: const EdgeInsets.only(
                                bottom: 8,
                              ),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    progressIndicatorBuilder: (_, __, ___) =>
                                        const Center(
                                            child: CircularProgressIndicator()),
                                    errorWidget: (_, __, ___) =>
                                        const SizedBox(height: 0),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          if (notification?.body != null)
                            Text(notification!.body!),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (imageUrl != null)
                          Container(
                            margin: const EdgeInsets.only(
                              right: 8,
                            ),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                progressIndicatorBuilder: (_, __, ___) =>
                                    const Center(
                                        child: CircularProgressIndicator()),
                                errorWidget: (_, __, ___) =>
                                    const SizedBox(height: 0),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        if (notification?.body != null)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                notification!.body!,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              if (buttons.isNotEmpty)
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 6, 24, 12),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: [
                      // if (leftActionsBuilder != null)
                      //   Container(
                      //     margin: const EdgeInsets.only(right: 12),
                      //     child: leftActionsBuilder!(context),
                      //   ),
                      if (buttons.isNotEmpty)
                        TextButton(
                          onPressed: () async {
                            final uri = Uri.parse(buttons[0].value);
                            if (await canLaunchUrl(uri)) {
                              launchUrl(uri);
                            } else {
                              Navigator.maybePop(context);
                            }
                          },
                          child: Text(
                            buttons[0].key,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      if (buttons.length > 1)
                        TextButton(
                          onPressed: () async {
                            final uri = Uri.parse(buttons[1].value);
                            if (await canLaunchUrl(uri)) {
                              launchUrl(uri);
                            } else {
                              Navigator.maybePop(context);
                            }
                          },
                          child: Text(buttons[1].key),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
