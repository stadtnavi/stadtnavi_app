import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

import 'carsharing_feature_model.dart';

class CarSharingMarkerModal extends StatelessWidget {
  final CarSharingFeature element;
  final void Function() onFetchPlan;
  final MapLayerCategory? targetMapLayerCategory;

  const CarSharingMarkerModal({
    Key? key,
    required this.element,
    required this.onFetchPlan,
    required this.targetMapLayerCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnglishCode = Localizations.localeOf(context).languageCode == 'en';

    final svgIcon = targetMapLayerCategory?.properties?.iconSvg;
    final vehiclesAvailable = element.vehiclesAvailable ?? 0;
    const greyColor = Color(0xFF747474);
    const divider = Divider(
      color: greyColor,
      thickness: 0.5,
      indent: 10,
      endIndent: 10,
    );

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
                      element.name ?? "",
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
                      (isEnglishCode
                              ? targetMapLayerCategory?.en
                              : targetMapLayerCategory?.de) ??
                          "",
                    ),
                  ),
                ],
              ),
              divider,
              Row(
                children: [
                  Container(
                    width: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 11),
                  ),
                  Expanded(
                    child: Text(
                      isEnglishCode
                          ? "Shared cars available ($vehiclesAvailable)."
                          : "Carsharing-Fahrzeuge verfügbar ($vehiclesAvailable).",
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
                      element.networkId ?? "no-id",
                    ),
                  ),
                ],
              ),
            ],
          ),
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
