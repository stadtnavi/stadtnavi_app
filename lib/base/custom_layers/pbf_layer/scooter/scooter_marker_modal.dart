import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

import 'scooter_feature_model.dart';


class ScooterMarkerModal extends StatelessWidget {
  final ScooterFeature element;
  final void Function() onFetchPlan;
  final MapLayerCategory? targetMapLayerCategory;

  const ScooterMarkerModal({
    Key? key,
    required this.element,
    required this.onFetchPlan,
    required this.targetMapLayerCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnglishCode = Localizations.localeOf(context).languageCode == 'en';

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
              Row(
                children: [
                  Container(
                    width: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 11),
                  ),
                  Expanded(
                    child: Text(
                      element.formFactors ?? "",
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
              Row(
                children: [
                  Container(
                    width: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 11),
                  ),
                  Expanded(
                    child: Text(
                      element.vehiclesAvailable?.toString() ?? "",
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
