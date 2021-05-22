
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/weather/weather_feature_model.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/weather/weather_icons.dart';
import 'package:intl/intl.dart';

class ParkingMarkerModal extends StatelessWidget {
  final WeatherFeature parkingFeature;
  const ParkingMarkerModal({Key key, @required this.parkingFeature})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  "Air Temperature: ${parkingFeature.airTemperatureC} °C",
                  style: TextStyle(
                    color: theme.textTheme.bodyText1.color,
                  ),
                ),
              if (parkingFeature.roadTemperatureC != null)
                Text(
                  "Road Temperature:  ${parkingFeature.roadTemperatureC} °C",
                  style: TextStyle(
                    color: theme.textTheme.bodyText1.color,
                  ),
                ),
              if (parkingFeature.precipitationType != null)
                Text(
                  "Precipitation: ${parkingFeature.precipitationType}",
                  style: TextStyle(
                    color: theme.textTheme.bodyText1.color,
                  ),
                ),
              if (parkingFeature.roadCondition != null)
                Text(
                  "Condition: ${parkingFeature.roadCondition}",
                  style: TextStyle(
                    color: theme.textTheme.bodyText1.color,
                  ),
                ),
              if (parkingFeature.updatedAt != null)
                Text(
                  "Last update: ${DateFormat('hh:mm a').format(DateTime.parse(parkingFeature.updatedAt).toLocal())}",
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
