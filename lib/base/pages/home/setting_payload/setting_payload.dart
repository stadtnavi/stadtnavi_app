import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'date_time_picker/itinerary_date_selector.dart';
import 'setting_panel/map_setting_button.dart';

class SettingPayload extends StatelessWidget {
  const SettingPayload({
    Key? key,
    required this.onFetchPlan,
  }) : super(key: key);

  final void Function() onFetchPlan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homePageState = context.watch<MapRouteCubit>().state;
    return Row(
      children: [
        Expanded(
          child: ItineraryDateSelector(
            onFetchPlan: onFetchPlan,
          ),
        ),
        if (homePageState.isPlacesDefined)
          Container(
            width: 1,
            height: 25,
            color: theme.appBarTheme.foregroundColor!,
          ),
        if (homePageState.isPlacesDefined)
          MapSettingButton(onFetchPlan: onFetchPlan)
        else
          const SizedBox(width: 100),
      ],
    );
  }
}
