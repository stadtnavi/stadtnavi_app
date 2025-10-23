import 'package:de_stadtnavi_herrenberg_internal/pages/home/search_location_field/components/location_form_field.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/pages/home/widgets/routing_map/routing_map_controller.dart';
import 'package:trufi_core/screens/route_navigation/maps/trufi_map_controller.dart';

class FormFieldsLandscape extends StatelessWidget {
  const FormFieldsLandscape({
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
    // final mapRouteState = context.read<MapRouteCubit>().state;
    // final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
          child: LocationFormField(
            isOrigin: true,
            hintText: "localization.searchPleaseSelectOrigin",
            textLeadingImage: RoutingMapComponent.fromMarker,
            onSaved: onSaveFrom,
            onClear: onClearFrom,
            // value: mapRouteState.fromPlace,
          ),
        ),
        // SizedBox(
        //   width: 40.0,
        //   child: mapRouteState.isPlacesDefined
        //       ? SwapButton(
        //           orientation: Orientation.landscape,
        //           onSwap: onSwap,
        //           color: theme.appBarTheme.foregroundColor!,
        //         )
        //       : null,
        // ),
        Flexible(
          child: LocationFormField(
            isOrigin: false,
            hintText: "localization.searchPleaseSelectDestination",
            textLeadingImage: RoutingMapComponent.toMarker,
            onSaved: onSaveTo,
            onClear: onClearTo,
            // value: mapRouteState.toPlace,
          ),
        ),
      ],
    );
  }
}
