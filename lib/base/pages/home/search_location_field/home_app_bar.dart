import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/pages/home/search_location_field/form_fields_landscape.dart';
import 'package:stadtnavi_core/base/pages/home/search_location_field/form_fields_portrait.dart';
import 'package:stadtnavi_core/base/pages/home/setting_payload/setting_payload.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/transport_selector.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';

import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';
import 'package:trufi_core/base/models/trufi_place.dart';

class HomeAppBar extends StatelessWidget {
  final void Function(TrufiLocation) onSaveFrom;
  final void Function() onClearFrom;
  final void Function(TrufiLocation) onSaveTo;
  final void Function() onClearTo;
  final void Function() onBackButton;
  final void Function() onFetchPlan;
  final void Function() onReset;
  final void Function() onSwap;
  const HomeAppBar({
    Key? key,
    required this.onSaveFrom,
    required this.onClearFrom,
    required this.onSaveTo,
    required this.onClearTo,
    required this.onBackButton,
    required this.onFetchPlan,
    required this.onReset,
    required this.onSwap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final theme = Theme.of(context);

    final stLocalization = StadtnaviBaseLocalization.of(context);
    return Card(
      margin: EdgeInsets.zero,
      color: ThemeCubit.isDarkMode(theme)
        ? theme.appBarTheme.backgroundColor
        : theme.colorScheme.primary,
      shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(5),
      ),
    ),
      child: SafeArea(
        bottom: false,
        top: false,
        child: Semantics(
          label: stLocalization.searchFieldsSrInstructions,
          excludeSemantics: false,
          child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: theme.appBarTheme.foregroundColor,
                    ),
                    splashRadius: 24,
                    iconSize: 24,
                    onPressed: onBackButton,
                    tooltip: MaterialLocalizations.of(context)
                        .openAppDrawerTooltip,
                  ),
                  Expanded(
                    child: (isPortrait)
                        ? Padding(
                            padding:
                                const EdgeInsets.fromLTRB(2.0, 4.0, 6.0, 0.0),
                            child: FormFieldsPortrait(
                              onFetchPlan: onFetchPlan,
                              onReset: onReset,
                              onSaveFrom: onSaveFrom,
                              onClearFrom:onClearFrom,
                              onSaveTo: onSaveTo,
                              onClearTo:onClearTo,
                              onSwap: onSwap,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(
                                12.0, 4.0, 4.0, 0.0),
                            child: FormFieldsLandscape(
                              onFetchPlan: onFetchPlan,
                              onReset: onReset,
                              onSaveFrom: onSaveFrom,
                              onClearFrom:onClearFrom,
                              onSaveTo: onSaveTo,
                              onClearTo:onClearTo,
                              onSwap: onSwap,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: isPortrait ? 55 : 65,
                right: isPortrait ? 15 : 50,
                bottom: 3,
              ),
              child: SettingPayload(
                onFetchPlan: onFetchPlan,
              ),
            ),
            const TransportSelector(),
          ],
        ),
        ),
      ),
    );
  }
}
