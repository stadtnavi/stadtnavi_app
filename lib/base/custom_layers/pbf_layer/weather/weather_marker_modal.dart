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

  String _mapRoadCondition(int? value, bool isEnglish) {
    if (value == null) return isEnglish ? "Unknown" : "Unbekannt";
    switch (value) {
      case 10:
        return isEnglish ? "Dry" : "Trocken";
      case 15:
        return isEnglish ? "Humid" : "Feucht";
      case 20:
        return isEnglish ? "Wet" : "Nass";
      case 25:
        return isEnglish ? "Humid with salt" : "Feucht mit Salz";
      case 30:
        return isEnglish ? "Wet with salt" : "Nass mit Salz";
      case 35:
        return isEnglish ? "Ice" : "Eis";
      case 40:
        return isEnglish ? "Snow" : "Schnee";
      case 45:
        return isEnglish ? "Frost" : "Frost / Reif";
      default:
        return isEnglish ? "Unknown" : "Unbekannt";
    }
  }

  String _mapPrecipitationType(int? value, bool isEnglish) {
    if (value == null) return isEnglish ? "Unknown" : "Unbekannt";
    switch (value) {
      case 0:
        return isEnglish ? "No precipitation" : "kein Niederschlag";
      case 60:
        return isEnglish
            ? "Liquid precipitation, e.g. rain"
            : "flüssiger Niederschlag, z.B. Regen";
      case 70:
        return isEnglish
            ? "Solid precipitation, e.g. snow"
            : "fester Niederschlag, z.B. Schnee";
      case 67:
        return isEnglish ? "Freezing rain" : "Eisregen";
      case 69:
        return isEnglish ? "Sleet" : "Schneeregen";
      case 90:
        return isEnglish ? "Hail" : "Hagel";
      default:
        return isEnglish ? "Unknown" : "Unbekannt";
    }
  }

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
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              if (parkingFeature.airPressureRelhPa != null)
                Text(
                  "${isEnglishCode ? 'Air Pressure' : 'Luftdruck'}: ${parkingFeature.airPressureRelhPa} hPa",
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              if (parkingFeature.moisturePercentage != null)
                Text(
                  "${isEnglishCode ? 'Humidity' : 'Luftfeuchtigkeit'}: ${parkingFeature.moisturePercentage} %",
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              if (parkingFeature.roadTemperatureC != null)
                Text(
                  "${isEnglishCode ? 'Road Temperature' : 'Straßentemperatur'}: ${parkingFeature.roadTemperatureC} °C",
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              if (parkingFeature.precipitationType != null)
                Text(
                  "${isEnglishCode ? 'Precipitation' : 'Niederschlag'}: ${_mapPrecipitationType(int.tryParse(parkingFeature.precipitationType!), isEnglishCode)}",
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              if (parkingFeature.roadCondition != null)
                Text(
                  "${isEnglishCode ? 'Road Condition' : 'Straßenzustand'}: ${_mapRoadCondition(int.tryParse(parkingFeature.roadCondition!), isEnglishCode)}",
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              if (parkingFeature.icePercentage != null)
                Text(
                  "${isEnglishCode ? 'Ice Percentage' : 'Eisprozent'}: ${parkingFeature.icePercentage} %",
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              if (parkingFeature.updatedAt != null)
                Text(
                  "\n${isEnglishCode ? 'Last Update' : 'Daten von'}: ${DateFormat('hh:mm a', languageCode).format(DateTime.parse(parkingFeature.updatedAt!).toLocal())}",
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(.5),
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
