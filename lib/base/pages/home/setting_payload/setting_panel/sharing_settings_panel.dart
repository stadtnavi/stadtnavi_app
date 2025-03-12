import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/setting_payload/setting_panel/setting_panel.dart';
import 'package:stadtnavi_core/base/pages/home/setting_payload/setting_panel/sharing_operator_selector.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:stadtnavi_core/base/translations/string_translation.dart';
import 'package:stadtnavi_core/base/widgets/custom_switch_tile.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/city_bike_utils.dart';

class SharingSettingsPanel extends StatefulWidget {
  const SharingSettingsPanel({super.key});

  @override
  State<SharingSettingsPanel> createState() => _SharingSettingsPanelState();
}

class _SharingSettingsPanelState extends State<SharingSettingsPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationST = StadtnaviBaseLocalization.of(context);
    final settingFetchCubit = context.watch<SettingFetchCubit>();
    final settingFetchState = settingFetchCubit.state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            localizationST.pickRentalMode,
            style: theme.textTheme.bodyLarge,
          ),
        ),
        ...ConfigDefault.value.formFactorsAndDefaultMessages.keys.map(
          (formFactor) {
            final formFactorsAndDefault =
                ConfigDefault.value.formFactorsAndDefaultMessages[formFactor]!;
            final operators = CityBikeUtils.getSharingOperatorsByFormFactor(
              formFactor,
              ConfigDefault.value,
            );
            return operators.isNotEmpty
                ? [
                    CustomSwitchTile(
                      title: localizationST
                          .translate(formFactorsAndDefault.translationKey),
                      secondary: SizedBox(
                        height: 35,
                        width: 35,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          child: FittedBox(
                            child: SvgPicture.string(
                                formFactorsAndDefault.icon ?? ''),
                          ),
                        ),
                      ),
                      value: settingFetchState.allowedVehicleRentalFormFactors
                          .contains(formFactor),
                      onChanged: (value) {
                        settingFetchCubit.setAllowedVehicleRentalFormFactors(
                          rentalFormFactorsId: formFactor,
                          isDelete: !value,
                        );
                      },
                    ),
                    SettingPanel.dividerSubSection,
                    if (settingFetchState.allowedVehicleRentalFormFactors
                        .contains(formFactor))
                      SharingOperatorSelector(
                        formFactor: formFactor,
                        formFactorsAndDefault: formFactorsAndDefault,
                      ),
                  ]
                : <Widget>[];
          },
        ).expand((element) => element),
      ],
    );
  }
}
