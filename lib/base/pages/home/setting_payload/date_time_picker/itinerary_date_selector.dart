import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

import 'date_time_picker.dart';

class ItineraryDateSelector extends StatelessWidget {
  const ItineraryDateSelector({
    Key? key,
    required this.onFetchPlan,
  }) : super(key: key);

  final void Function() onFetchPlan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final payloadDataPlanCubit = context.watch<SettingFetchCubit>();
    final homePageState = context.watch<MapRouteCubit>().state;
    return InkWell(
      onTap: () async {
        final tempPickedDate = await showTrufiModalBottomSheet<DateTimeConf>(
          context: context,
          isDismissible: false,
          builder: (BuildContext builder) {
            return DateTimePicker(
              dateConf: DateTimeConf(
                payloadDataPlanCubit.state.date,
                isArriveBy: payloadDataPlanCubit.state.arriveBy,
              ),
            );
          },
        );
        if (tempPickedDate != null) {
          await payloadDataPlanCubit.setDataDate(
              arriveBy: tempPickedDate.isArriveBy, date: tempPickedDate.date);
          if (homePageState.isPlacesDefined) {
            onFetchPlan();
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.access_time_rounded,
              color: theme.appBarTheme.foregroundColor!,
              size: 20,
            ),
            Expanded(
              child: Text(
                payloadDataPlanCubit.state.date == null
                    ? localization.commonLeavingNow
                    : payloadDataPlanCubit.state.arriveBy
                        ? "${localization.commonArrival} ${payloadDataPlanCubit.state.date!.customFormat(languageCode)}"
                        : "${localization.commonDeparture}  ${payloadDataPlanCubit.state.date!.customFormat(languageCode)}",
                style: TextStyle(
                  fontSize: 15,
                  height: 0,
                  color: theme.appBarTheme.foregroundColor!,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: theme.appBarTheme.foregroundColor!,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

extension on DateTime {
  String customFormat(String languageCode) {
    return DateFormat('E dd.MM.  HH:mm', languageCode).format(this);
  }
}
