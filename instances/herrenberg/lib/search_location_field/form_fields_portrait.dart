import 'package:de_stadtnavi_herrenberg_internal/search_location_field/components/buttons.dart';
import 'package:de_stadtnavi_herrenberg_internal/search_location_field/components/location_form_field.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/pages/home/widgets/routing_map/routing_map_controller.dart';
import 'package:trufi_core/screens/route_navigation/maps/trufi_map_controller.dart';

class FormFieldsPortrait extends StatelessWidget {
  const FormFieldsPortrait({
    Key? key,
    required this.onSaveFrom,
    required this.onClearFrom,
    required this.onSaveTo,
    required this.onClearTo,
    required this.onFetchPlan,
    required this.onReset,
    required this.onSwap,
  }) : super(key: key);

  final void Function(TrufiLocation) onSaveFrom;
  final void Function() onClearFrom;
  final void Function(TrufiLocation) onSaveTo;
  final void Function() onClearTo;
  final void Function() onFetchPlan;
  final void Function() onReset;
  final void Function() onSwap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalization.of(context);
    // final mapRouteState = context.watch<MapRouteCubit>().state;
    // final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              LocationFormField(
                isOrigin: true,
                onSaved: onSaveFrom,
                onClear: onClearFrom,
                hintText: "localization.searchPleaseSelectOrigin",
                textLeadingImage: RoutingMapComponent.fromMarker,
                trailing: null,
                // value: mapRouteState.fromPlace,
              ),
              LocationFormField(
                isOrigin: false,
                onSaved: onSaveTo,
                onClear: onClearTo,
                hintText: "localization.searchPleaseSelectDestination",
                textLeadingImage: RoutingMapComponent.toMarker,
                trailing: null,
                // value: mapRouteState.toPlace,
              ),
            ],
          ),
        ),
        // if (mapRouteState.isPlacesDefined)
        // SwapButton(
        //   orientation: Orientation.portrait,
        //   onSwap: onSwap,
        //   color: theme.appBarTheme.foregroundColor!,
        // ),
      ],
    );
  }
}
