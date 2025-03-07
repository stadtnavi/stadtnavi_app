import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/setting_payload/setting_panel/setting_panel.dart';
import 'package:stadtnavi_core/base/widgets/custom_switch_tile.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/city_bike_utils.dart';

class SharingOperatorSelector extends StatelessWidget {
  const SharingOperatorSelector({
    super.key,
    required this.formFactor,
    required this.formFactorsAndDefault,
  });
  final String formFactor;
  final FormFactorAndDefaultMessage formFactorsAndDefault;

  @override
  Widget build(BuildContext context) {
    final settingFetchCubit = context.watch<SettingFetchCubit>();
    final settingFetchState = context.watch<SettingFetchCubit>().state;
    final operators = CityBikeUtils.getSharingOperatorsByFormFactor(
      formFactor,
      ConfigDefault.value,
    );
    final currentOperators = CityBikeUtils.getCurrentSharingOperators(
      config: ConfigDefault.value,
      formFactor: formFactor,
      allowedVehicleRentalNetworks:
          settingFetchState.allowedVehicleRentalNetworks,
    );
    return Container(
      margin: const EdgeInsets.only(left: 55, top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: operators
            .map(
              (operator) => Column(
                children: [
                  CustomSwitchTile(
                    title: operator.name?[
                            Localizations.localeOf(context).languageCode] ??
                        '',
                    secondary: SizedBox(
                      height: 35,
                      width: 35,
                      child: FittedBox(
                        child: SvgPicture.string(operator.iconCode ??
                            formFactorsAndDefault.icon ??
                            ''),
                      ),
                    ),
                    value: currentOperators
                        .where((network) => network == operator.operatorId)
                        .isNotEmpty,
                    onChanged: (value) {
                      final ids = CityBikeUtils.toggleSharingOperator(
                        newValue: operator.operatorId ?? '',
                        config: ConfigDefault.value,
                        allowedVehicleRentalNetworks: [],
                      );

                      settingFetchCubit.setAllowedVehicleRentalNetworks(
                        rentalNetworkIds: ids,
                        isDelete: !value,
                      );
                      // TODO: This code is not required on mobile, as TransportMode.Citybike does not exist—even in the GraphQL documentation. However, it should be reviewed in the future.
                      // const modes = getModes(config);
                      // if (newNetworks.length > 0) {
                      //   if (modes.indexOf(TransportMode.Citybike) === -1) {
                      //     newSettings.modes = xor(modes, [TransportMode.Citybike]);
                      //   }
                      // } else if (modes.indexOf(TransportMode.Citybike) !== -1) {
                      //   newSettings.modes = xor(modes, [TransportMode.Citybike]);
                      // }
                      // executeAction(saveRoutingSettings, newSettings);
                    },
                  ),
                  SettingPanel.dividerSubSection,
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
