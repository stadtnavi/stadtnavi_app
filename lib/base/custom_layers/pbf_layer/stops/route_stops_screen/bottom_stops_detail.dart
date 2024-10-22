import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/route.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/stop.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

import 'stop_item_tile.dart';

class BottomStopsDetails extends StatelessWidget {
  final RouteOtp routeOtp;
  final List<Stop> stops;
  final Function(LatLng) moveTo;
  const BottomStopsDetails({
    Key? key,
    required this.routeOtp,
    required this.stops,
    required this.moveTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiBaseLocalization.of(context);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(15, 15, 15, 20),
          child: Row(
            children: [
              Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  color: routeOtp.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: routeOtp.mode?.getImage(color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                getTransportMode(mode: routeOtp.mode?.name ?? '')
                    .getTranslate(localization),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' - ${routeOtp.shortName ?? ''}',
                style: theme.textTheme.bodyMedium?.copyWith(
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
                onPressed: () => moveTo(LatLng(stop.lat!, stop.lon!)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: StopItemTile(
                  stop: stop,
                  color: routeOtp.color != null
                      ? Color(int.tryParse("0xFF${routeOtp.color}") ?? 0)
                      : routeOtp.mode?.color,
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
