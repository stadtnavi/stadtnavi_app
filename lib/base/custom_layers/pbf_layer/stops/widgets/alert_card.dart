import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stops_icon.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';
import "package:url_launcher/url_launcher.dart";
import 'package:intl/intl.dart';

class AlertStopCard extends StatelessWidget {
  const AlertStopCard({
    super.key,
    required this.shortName,
    required this.startDateTime,
    required this.endDateTime,
    required this.content,
    required this.alertUrl,
  });
  final String shortName;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String content;
  final String? alertUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLocale = Localizations.localeOf(context);
    String atWord = currentLocale.languageCode.contains('de') ? 'um' : 'at';

    final checkedUrl = checkUrl(alertUrl);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: TransportMode.bus.color,
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 35,
                width: 35,
                child: TransportMode.bus.getImage(color: Colors.white),
              ),
              Positioned(
                bottom: -8,
                left: -8,
                child: Stack(alignment: Alignment.center, children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: cautionNoExclNoStrokeIcon(color: Colors.white),
                  ),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: cautionNoExclNoStrokeIcon(),
                  ),
                ]),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Text.rich(
              TextSpan(
                style: const TextStyle(),
                children: <TextSpan>[
                  TextSpan(
                    text: '$shortName  ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat("dd.MM.yyyy '$atWord' HH:mm",
                            currentLocale.languageCode)
                        .format(startDateTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: ' - ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat("dd.MM.yyyy '$atWord' HH:mm",
                            currentLocale.languageCode)
                        .format(endDateTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '\n$content',
                    style: const TextStyle(),
                  ),
                  if (checkedUrl != null)
                    TextSpan(
                      text: currentLocale.languageCode.contains('en')
                          ? "More Info"
                          : "Mehr Infos",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri uri = Uri.parse(checkedUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                            );
                          }
                        },
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String? checkUrl(String? url) {
    if (url != null && url.isNotEmpty) {
      final RegExp urlPattern = RegExp(r'^[a-zA-Z]+:\/\/');

      if (urlPattern.hasMatch(url)) {
        return url;
      }
      return 'http://$url';
    }
    return null;
  }
}
