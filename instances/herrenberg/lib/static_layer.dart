import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/custom_poi_icons.dart';

final customLayersHerrenberg = HBLayerData.categories
    .map((category) => CustomLayerContainer(
          name: (context) =>
              TrufiBaseLocalization.of(context).localeName == "en"
                  ? category.en
                  : category.de,
          icon: (context) {
            if (category.code == "transit") {
              return const Icon(
                Icons.train,
                color: Colors.grey,
              );
            }
            if (category.code == "bike_car") {
              return const Icon(
                Icons.directions_bike,
                color: Colors.grey,
              );
            }
            if (category.code == "sharing_services") {
              return const Icon(
                Icons.bike_scooter,
                color: Colors.grey,
              );
            }
            if (category.code == "leisure_and_tourism") {
              return SvgPicture.string(
                CustomPoiIcons.iconLeisureTourism,
                color: Colors.grey,
              );
            }
            if (category.code == "shopping_and_services") {
              return SvgPicture.string(
                CustomPoiIcons.iconShoppingServices,
                color: Colors.grey,
              );
            }
            if (category.code == "public_facilities") {
              return SvgPicture.string(
                CustomPoiIcons.iconPublicFacilities,
                color: Colors.grey,
              );
            }
            if (category.code == "health_and_social_services") {
              return SvgPicture.string(
                CustomPoiIcons.iconHealthSocialServices,
                color: Colors.grey,
              );
            }
            {
              return const Icon(
                Icons.error,
                color: Colors.red,
              );
            }
          },
          layers:
              category.categories.map((element) => element.toLayer()).toList(),
        ))
    .toList();