import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_icons.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

class ParkingMarkerModal extends StatelessWidget {
  final WeatherFeature parkingFeature;
  final void Function() onFetchPlan;
  const ParkingMarkerModal({
    Key? key,
    required this.parkingFeature,
    required this.onFetchPlan,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final isEnglishCode = languageCode == 'en';
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.string(roadWeatherIcons),
              ),
              Expanded(
                child: Text(
                  parkingFeature.address,
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
              if (parkingFeature.airTemperatureC != null)
                Text(
                  "${isEnglishCode ? 'Air Temperature' : 'Lufttemperatur'}: ${parkingFeature.airTemperatureC} °C",
                  style: TextStyle(
                    color: theme.textTheme. bodyLarge?.color,
                  ),
                ),
              if (parkingFeature.roadTemperatureC != null)
                Text(
                  "${isEnglishCode ? 'Road Temperature' : 'Straßentemperatur'}:  ${parkingFeature.roadTemperatureC} °C",
                  style: TextStyle(
                    color: theme.textTheme. bodyLarge?.color,
                  ),
                ),
              if (parkingFeature.precipitationType != null)
                Text(
                  "${isEnglishCode ? 'Precipitation' : 'Niederschlag'}: ${parkingFeature.precipitationType}",
                  style: TextStyle(
                    color: theme.textTheme. bodyLarge?.color,
                  ),
                ),
              if (parkingFeature.roadCondition != null)
                Text(
                  "${isEnglishCode ? 'Condition' : 'Straßenzustand'}: ${parkingFeature.roadCondition}",
                  style: TextStyle(
                    color: theme.textTheme. bodyLarge?.color,
                  ),
                ),
              if (parkingFeature.updatedAt != null)
                Text(
                  "${isEnglishCode ? 'Last update' : 'Daten von'}: ${DateFormat('hh:mm a', languageCode).format(DateTime.parse(parkingFeature.updatedAt!).toLocal())}",
                  style: TextStyle(
                    color: theme.textTheme. bodyLarge?.color,
                  ),
                ),
            ],
          ),
        ),
        CustomLocationSelector(
          onFetchPlan: onFetchPlan,
          locationData: LocationDetail(
            parkingFeature.address,
            "",
            parkingFeature.position,
          ),
        ),
      ],
    );
  }
}
