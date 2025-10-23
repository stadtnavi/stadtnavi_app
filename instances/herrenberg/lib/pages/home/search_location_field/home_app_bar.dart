import 'package:de_stadtnavi_herrenberg_internal/pages/home/search_location_field/form_fields_landscape.dart';
import 'package:de_stadtnavi_herrenberg_internal/pages/home/search_location_field/form_fields_portrait.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/screens/route_navigation/maps/trufi_map_controller.dart';

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

    final stLocalization = AppLocalization.of(context);
    return Container(
      child: Card(
        margin: EdgeInsets.zero,
        color: theme.brightness == Brightness.dark
            ? theme.appBarTheme.backgroundColor
            : theme.colorScheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        ),
        child: SafeArea(
          child: Semantics(
            label: "stLocalization.searchFieldsSrInstructions",
            excludeSemantics: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: theme.colorScheme.onPrimary,
                      ),
                      splashRadius: 24,
                      iconSize: 24,
                      onPressed: onBackButton,
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).openAppDrawerTooltip,
                    ),
                      Expanded(
                        child: (isPortrait)
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  2.0,
                                  4.0,
                                  6.0,
                                  0.0,
                                ),
                                child: FormFieldsPortrait(
                                  onFetchPlan: onFetchPlan,
                                  onReset: onReset,
                                  onSaveFrom: onSaveFrom,
                                  onClearFrom: onClearFrom,
                                  onSaveTo: onSaveTo,
                                  onClearTo: onClearTo,
                                  onSwap: onSwap,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12.0,
                                  4.0,
                                  4.0,
                                  0.0,
                                ),
                                child: FormFieldsLandscape(
                                  onFetchPlan: onFetchPlan,
                                  onReset: onReset,
                                  onSaveFrom: onSaveFrom,
                                  onClearFrom: onClearFrom,
                                  onSaveTo: onSaveTo,
                                  onClearTo: onClearTo,
                                  onSwap: onSwap,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(
                //     left: isPortrait ? 55 : 65,
                //     right: isPortrait ? 15 : 50,
                //     bottom: 3,
                //   ),
                //   child: SettingPayload(onFetchPlan: onFetchPlan),
                // ),
                // const TransportSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
