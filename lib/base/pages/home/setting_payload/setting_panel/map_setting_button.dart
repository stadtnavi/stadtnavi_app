import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/setting_payload/setting_panel/setting_panel.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

class MapSettingButton extends StatelessWidget {
  const MapSettingButton({
    Key? key,
    required this.onFetchPlan,
  }) : super(key: key);

  final void Function() onFetchPlan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    return InkWell(
      onTap: () async {
        final oldPayloadDataPlanState = context.read<SettingFetchCubit>().state;

        final newPayloadDataPlanState = await Navigator.of(context).push(
          MaterialPageRoute<SettingFetchState?>(
            builder: (BuildContext context) => const BaseTrufiPage(
              child: SettingPanel(),
            ),
          ),
        );

        if (oldPayloadDataPlanState != newPayloadDataPlanState) {
          onFetchPlan();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Row(
          children: [
            Icon(
              Icons.tune,
              color: theme.appBarTheme.foregroundColor!,
            ),
            const SizedBox(width: 5),
            Text(
              localization.commonSettings,
              style: TextStyle(
                fontSize: 15,
                color: theme.appBarTheme.foregroundColor!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
