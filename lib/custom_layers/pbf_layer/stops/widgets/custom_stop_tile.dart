import 'package:flutter/material.dart';
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
    return Column(
      children: [
        ListTile(
          leading: Container(
            color: Color(int.tryParse("0xFF${stopTime.trip?.route?.color}") ??
                0xFF000000),
            padding: const EdgeInsets.symmetric(vertical: 5),
            width: 50,
            child: Text(
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
          trailing: Text(
            stopTime.stopTimeAsString,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800),
          ),
        ),
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
