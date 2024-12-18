import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

import 'poi_feature_model.dart';

class PoiMarkerModal extends StatelessWidget {
  final PoiFeature element;
  final void Function() onFetchPlan;

  const PoiMarkerModal({
    Key? key,
    required this.element,
    required this.onFetchPlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final localizationST = StadtnaviBaseLocalization.of(context);

    final infoWidgets = <Widget>[];

    void addInfoRow(String label, String? value) {
      if (value != null && value.isNotEmpty) {
        infoWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(value),
                ),
              ],
            ),
          ),
        );
      }
    }

    addInfoRow('ID', element.id);
    addInfoRow('OSM ID', element.osmId);
    addInfoRow('Address', element.address);
    addInfoRow('Brand', element.brand);
    addInfoRow('Category1', element.category1);
    addInfoRow('Category2', element.category2);
    addInfoRow('Category3', element.category3);
    addInfoRow('Changing Table', element.changingTable);
    addInfoRow('Cuisine', element.cuisine);
    addInfoRow('Dog', element.dog);
    addInfoRow('Drinking Water', element.drinkingWater.toString());
    addInfoRow('Email', element.email);
    addInfoRow('Fee', element.fee.toString());
    addInfoRow('Fuel', element.fuel);
    addInfoRow('Internet Access', element.internetAccess);
    addInfoRow('Name', element.name);
    addInfoRow('Opening Hours', element.openingHours);
    addInfoRow('Operator', element.operatorName);
    addInfoRow('OSM Type', element.osmType);
    addInfoRow('Outdoor Seating', element.outdoorSeating);
    addInfoRow('Phone', element.phone);
    addInfoRow('Sauna', element.sauna);
    addInfoRow('Swimming Pool', element.swimmingPool);
    addInfoRow('Website', element.website);
    addInfoRow('Wheelchair', element.wheelchair);

    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: Text(
                  element.name ?? localizationST.bicycleParking,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: infoWidgets,
          ),
        ),
        const Divider(),
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
