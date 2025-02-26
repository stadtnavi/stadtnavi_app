import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/weather/weather_feature_model.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

class ParkingMarkerModal extends StatelessWidget {
  final WeatherFeature parkingFeature;
  final Widget icon;
  final void Function() onFetchPlan;

  const ParkingMarkerModal({
    Key? key,
    required this.parkingFeature,
    required this.onFetchPlan, required this.icon,
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
                child:icon,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglishCode ? 'Weather station' : 'Wetterstation',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      parkingFeature.address,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
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
                _buildRow(
                  isEnglishCode ? 'Air Temperature' : 'Lufttemperatur',
                  "${parkingFeature.airTemperatureC} °C",
                  theme,
                ),
              if (parkingFeature.airPressureRelhPa != null)
                _buildRow(
                  isEnglishCode ? 'Air Pressure' : 'Luftdruck',
                  "${parkingFeature.airPressureRelhPa} hPa",
                  theme,
                ),
              if (parkingFeature.moisturePercentage != null)
                _buildRow(
                  isEnglishCode ? 'Humidity' : 'Luftfeuchtigkeit',
                  "${parkingFeature.moisturePercentage} %",
                  theme,
                ),
              if (parkingFeature.roadTemperatureC != null)
                _buildRow(
                  isEnglishCode ? 'Road Temperature' : 'Straßentemperatur',
                  "${parkingFeature.roadTemperatureC} °C",
                  theme,
                ),
              if (parkingFeature.precipitationType != null)
                _buildRow(
                  isEnglishCode ? 'Precipitation' : 'Niederschlag',
                  _mapPrecipitationType(
                      int.tryParse(parkingFeature.precipitationType!),
                      isEnglishCode),
                  theme,
                ),
              if (parkingFeature.roadCondition != null)
                _buildRow(
                  isEnglishCode ? 'Road Condition' : 'Straßenzustand',
                  _mapRoadCondition(int.tryParse(parkingFeature.roadCondition!),
                      isEnglishCode),
                  theme,
                ),
              if (parkingFeature.icePercentage != null)
                _buildRow(
                  isEnglishCode ? 'Ice Percentage' : 'Eisprozent',
                  "${parkingFeature.icePercentage} %",
                  theme,
                ),
              if (parkingFeature.updatedAt != null)
                _buildRow(
                  isEnglishCode ? 'Last Update' : 'Daten von',
                  formatDateWithoutSeconds(
                      parkingFeature.updatedAt!, languageCode),
                  theme,
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

  Widget _buildRow(
    String label,
    String value,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color?.withOpacity(1),
                fontSize: null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDateWithoutSeconds(String date, String languageCode) {
    final parsedDate = DateTime.parse(date).toLocal();
    String formattedDate = DateFormat(null, languageCode).format(parsedDate);
    formattedDate = formattedDate.replaceFirst(RegExp(r':\d{2}(?=\s|$)'), '');
    if (languageCode == 'de' && !formattedDate.contains('Uhr')) {
      formattedDate += ' Uhr';
    }

    return formattedDate;
  }
}
