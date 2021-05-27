import 'package:flutter/material.dart';
import 'package:stadtnavi_app/custom_layers/pbf_layer/stops/route_stops_screen/route_stops_screen.dart';

import 'package:stadtnavi_app/custom_layers/services/models_otp/enums/mode.dart';
import 'package:stadtnavi_app/custom_layers/services/models_otp/stoptime.dart';

class CustomStopTile extends StatelessWidget {
  final Stoptime stopTime;
  final bool isLastStop;

  const CustomStopTile({
    Key key,
    @required this.stopTime,
    this.isLastStop = false,
  })  : assert(stopTime != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        ListTile(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RoutesStopScreen(stopTime: stopTime)),
              );
            },
            leading: Container(
              decoration: BoxDecoration(
                color: Color(
                    int.tryParse("0xFF${stopTime.trip?.route?.color}") ??
                        stopTime.trip.route.mode.color.value),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5),
              width: 50,
              child: stopTime.trip.route.useIcon
                  ? stopTime.trip.route.mode.image
                  : Text(
                      stopTime.trip.route.shortName,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
            title: Text(
              stopTime.getHeadsing(
                isLastStop: isLastStop,
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: stopTime.isArrival && !isLastStop
                ? Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: const Color(0xffe5f2fa),
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: theme.primaryColor,
                                size: 17,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                languageCode == 'en'
                                    ? "Drop-off only"
                                    : "Nur Abgabe",
                                style: theme.textTheme.bodyText1
                                    .copyWith(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${stopTime.timeDiffInMinutes} ',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  '${stopTime.stopTimeAsString} ',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w800),
                ),
              ],
            )),
        const Divider(
          height: 0,
          color: Colors.black87,
          indent: 16,
          endIndent: 20,
        ),
      ],
    );
  }
}
