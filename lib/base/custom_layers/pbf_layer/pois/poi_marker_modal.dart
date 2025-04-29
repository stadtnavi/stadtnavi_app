import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/simple_opening_hours.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/widgets/opening_time_table.dart';
import "package:url_launcher/url_launcher.dart";
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/other_icons.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

import 'poi_feature_model.dart';

class PoiMarkerModal extends StatelessWidget {
  final PoiFeature element;
  final void Function() onFetchPlan;
  final MapLayerCategory? targetMapLayerCategory;

  const PoiMarkerModal({
    Key? key,
    required this.element,
    required this.onFetchPlan,
    required this.targetMapLayerCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnglishCode = Localizations.localeOf(context).languageCode == 'en';
    final localizationST = StadtnaviBaseLocalization.of(context);
    SimpleOpeningHours? openingHours;
    if (element.openingHours != null) {
      openingHours = SimpleOpeningHours(element.openingHours!);
    }
    const greyColor = Color(0xFF747474);
    const divider = Divider(
      color: greyColor,
      thickness: 0.5,
      indent: 10,
      endIndent: 10,
    );

    final svgIcon = targetMapLayerCategory?.properties?.iconSvg;
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: svgIcon != null
                        ? SvgPicture.string(svgIcon)
                        : const Icon(Icons.error),
                  ),
                  Expanded(
                    child: Text(
                      (isEnglishCode
                              ? targetMapLayerCategory?.en
                              : targetMapLayerCategory?.de) ??
                          "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 11),
                  ),
                  Expanded(
                    child: Text(
                      element.name ?? "",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (element.address != null ||
            element.phone != null ||
            element.website != null)
          divider,
        if (element.address != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(
                  width: 7,
                ),
                const Icon(
                  Icons.location_on,
                  color: greyColor,
                  size: 16,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  element.address!,
                  style: const TextStyle(color: greyColor),
                ),
              ],
            ),
          ),
        if (element.phone != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(
                  width: 7,
                ),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: iconPhoneSvg(color: greyColor),
                ),
                const SizedBox(
                  width: 5,
                ),
                RichText(
                  text: TextSpan(
                    style: theme.primaryTextTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                      color: theme.colorScheme.primary,
                    ),
                    text: element.phone,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri uri =
                            Uri(scheme: 'tel', path: element.phone!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                          );
                        }
                      },
                  ),
                ),
              ],
            ),
          ),
        if (element.website != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(
                  width: 7,
                ),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: iconWebsiteSvg(color: greyColor),
                ),
                const SizedBox(
                  width: 5,
                ),
                RichText(
                  text: TextSpan(
                    style: theme.primaryTextTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                      color: theme.colorScheme.primary,
                    ),
                    text: element.website,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri uri = Uri.parse(element.website!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                          );
                        }
                      },
                  ),
                ),
              ],
            ),
          ),
        if (openingHours != null) ...[
          divider,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: OpeningTimeTable(
              openingHours: openingHours,
              isOpenParking: openingHours.isOpenNow(),
              currentOpeningTime:
                  OpeningTimeTable.getCurrentOpeningTime(openingHours),
            ),
          ),
        ],
        if (element.wheelchair == 'yes')
          LabelPOIsDetails(
            label: localizationST.poiTagWheelchair,
            color: greyColor,
          ),
        if (element.outdoorSeating == 'yes')
          LabelPOIsDetails(
            label: localizationST.poiTagOutdoor,
            color: greyColor,
          ),
        if (element.dog == 'yes')
          LabelPOIsDetails(
            label: localizationST.poiTagDogs,
            color: greyColor,
          ),
        if (element.internetAccess == 'wlan')
          LabelPOIsDetails(
            label: localizationST.poiTagWifi,
            color: greyColor,
          ),
        if (element.operatorName != null)
          LabelPOIsDetails(
            label: localizationST.poiTagOperator(element.operatorName!),
            color: greyColor,
          ),
        if (element.brand != null)
          LabelPOIsDetails(
            label: localizationST.poiTagBrand(element.brand!),
            color: greyColor,
          ),
        CustomLocationSelector(
          onFetchPlan: onFetchPlan,
          locationData: LocationDetail(
            element.name ?? "",
            "",
            element.position,
          ),
        ),
      ],
    );
  }
}

class LabelPOIsDetails extends StatelessWidget {
  const LabelPOIsDetails({
    super.key,
    required this.label,
    required this.color,
  });
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Text(
        label,
        style: TextStyle(color: color),
      ),
    );
  }
}
