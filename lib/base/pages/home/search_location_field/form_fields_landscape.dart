import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/search_location_field/components/buttons.dart';
import 'package:stadtnavi_core/base/pages/home/search_location_field/components/location_form_field.dart';

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class FormFieldsLandscape extends StatelessWidget {
  const FormFieldsLandscape({
    Key? key,
    required this.onSaveFrom,
    required this.onSaveTo,
    required this.onFetchPlan,
    required this.onReset,
    required this.onSwap,
  }) : super(key: key);

  final void Function(TrufiLocation) onSaveFrom;
  final void Function(TrufiLocation) onSaveTo;
  final void Function() onFetchPlan;
  final void Function() onReset;
  final void Function() onSwap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiBaseLocalization.of(context);
    final mapRouteState = context.read<MapRouteCubit>().state;
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
          child: LocationFormField(
            isOrigin: true,
            hintText: localization.searchPleaseSelectOrigin,
            textLeadingImage: mapConfiguratiom.markersConfiguration.fromMarker,
            onSaved: onSaveFrom,
            value: mapRouteState.fromPlace,
          ),
        ),
        SizedBox(
          width: 40.0,
          child: mapRouteState.isPlacesDefined
              ? SwapButton(
                  orientation: Orientation.landscape,
                  onSwap: onSwap,
                  color: theme.appBarTheme.foregroundColor!,
                )
              : null,
        ),
        Flexible(
          child: LocationFormField(
            isOrigin: false,
            hintText: localization.searchPleaseSelectDestination,
            textLeadingImage: mapConfiguratiom.markersConfiguration.toMarker,
            onSaved: onSaveTo,
            value: mapRouteState.toPlace,
          ),
        ),
        SizedBox(
          width: 40.0,
          child: mapRouteState.isPlacesDefined
              ? ResetButton(
                  onReset: onReset,
                  color: theme.appBarTheme.foregroundColor!,
                )
              : null,
        ),
      ],
    );
  }
}
