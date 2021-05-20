import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_app/custom_layers/local_json_layer/custom_marker_model.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';

class CustomMarkerModal extends StatelessWidget {
  final CustomMarker element;
  const CustomMarkerModal({Key key, @required this.element}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = TrufiLocalization.of(context);
    final theme = Theme.of(context);
    final localeName = localization.localeName;
    String title;
    String body;
    if (localeName == "en") {
      title = element.nameEn ?? element.name ?? "";
      body = element.popupContentEn ?? element.popupContent ?? "";
    } else {
      title = element.nameDe ?? element.name ?? "";
      body = element.popupContentDe ?? element.popupContent ?? "";
    }
    // apply format to the popup content
    body = body.replaceAll(", ", "\n\n");
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.string(element.image),
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                body,
                style: TextStyle(
                  color: theme.textTheme.bodyText1.color,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
