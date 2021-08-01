import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_app/custom_layers/services/models_otp/enums/mode.dart';
import 'package:stadtnavi_app/custom_layers/services/models_otp/route.dart';
import 'package:stadtnavi_app/custom_layers/services/models_otp/stop.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:trufi_core/models/enums/enums_plan/enums_plan.dart';

import 'stop_item_tile.dart';

class BottomStopsDetails extends StatelessWidget {
  final RouteOtp routeOtp;
  final List<Stop> stops;
  final Function(LatLng) moveTo;
  const BottomStopsDetails({
    Key key,
    @required this.routeOtp,
    @required this.stops,
    @required this.moveTo,
  })  : assert(routeOtp != null),
        assert(stops != null),
        assert(moveTo != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiLocalization.of(context);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(15, 15, 15, 20),
          child: Row(
            children: [
              SizedBox(
                height: 28,
                width: 28,
                child: routeOtp.mode.image,
              ),
              const SizedBox(width: 10),
              Text(
                getTransportMode(mode: routeOtp.mode.name)
                    .getTranslate(localization),
                style: theme.textTheme.bodyText2.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' - ${routeOtp?.shortName ?? ''}',
                style: theme.textTheme.bodyText2.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: stops.length,
            itemBuilder: (contextBuilde, index) {
              final Stop stop = stops[index];
              return TextButton(
                onPressed: () => moveTo(LatLng(stop.lat, stop.lon)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: StopItemTile(
                  stop: stop,
                  color: Color(
                    int.tryParse("0xFF${routeOtp.color}") ??
                        routeOtp.mode.color.value,
                  ),
                  isLastElement: index == stops.length - 1,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
