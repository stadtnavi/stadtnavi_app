
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/base/utils/text/outlined_text.dart';
import 'package:url_launcher/url_launcher.dart';

Widget stadtNaviAttributionBuilder(BuildContext context) {
  final theme = Theme.of(context);
  final languageCode = Localizations.localeOf(context).languageCode;
  final List<Shadow> shadows = outlinedText(
    strokeColor: Colors.white.withOpacity(.3),
    precision: 2,
  );
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.black,
            decoration: TextDecoration.underline,
            shadows: shadows,
          ),
          text:
              "© OpenStreetMap ${languageCode == 'en' ? "Contributors" : "Mitwirkende"},\n",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch("https://www.openstreetmap.org/copyright");
            },
        ),
        TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.black,
            shadows: shadows,
          ),
          text: languageCode == 'en' ? "Datasets by " : "Datensätze der ",
        ),
        TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.black,
            decoration: TextDecoration.underline,
            shadows: shadows,
          ),
          text: "NVBW GmbH",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch("https://www.nvbw.de/open-data");
            },
        ),
        TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.black,
            shadows: shadows,
          ),
          text: languageCode == 'en' ? " and " : " und ",
        ),
        TextSpan(
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.black,
            decoration: TextDecoration.underline,
            shadows: shadows,
          ),
          text: "VVS GmbH",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch("https://www.openvvs.de/dataset/gtfs-daten");
            },
        ),
      ],
    ),
  );
}