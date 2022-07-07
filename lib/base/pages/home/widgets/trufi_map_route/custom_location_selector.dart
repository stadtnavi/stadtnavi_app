import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/pages/saved_places/search_locations_cubit/search_locations_cubit.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class CustomLocationSelector extends StatelessWidget {
  const CustomLocationSelector({
    Key? key,
    required this.locationData,
    required this.onFetchPlan,
    this.isOnlyDestination = false,
  }) : super(key: key);

  final LocationDetail locationData;
  final void Function() onFetchPlan;
  final bool isOnlyDestination;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiBaseLocalization.of(context);
    final mapRouteCubit = context.read<MapRouteCubit>();
    final searchLocationsCubit = context.read<SearchLocationsCubit>();
    return Row(
      children: [
        const SizedBox(width: 10),
        if (!isOnlyDestination)
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final location = TrufiLocation(
                  description: locationData.description,
                  address: locationData.street,
                  latitude: locationData.position.latitude,
                  longitude: locationData.position.longitude,
                );
                await mapRouteCubit.setFromPlace(location);
                searchLocationsCubit.insertHistoryPlace(location);
                onFetchPlan();
              },
              child: Text(
                localization.commonOrigin,
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
          ),
        if (isOnlyDestination) const SizedBox(width: 10),
        Expanded(
          child: (isOnlyDestination)
              ? Center(
                  child: OutlinedButton(
                    onPressed: () async {
                      final location = TrufiLocation(
                        description: locationData.description,
                        address: locationData.street,
                        latitude: locationData.position.latitude,
                        longitude: locationData.position.longitude,
                      );
                      await mapRouteCubit.setToPlace(location);
                      searchLocationsCubit.insertHistoryPlace(location);
                      onFetchPlan();
                    },
                    child: Text(
                      localization.commonDestination,
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ),
                )
              : OutlinedButton(
                  onPressed: () async {
                    final location = TrufiLocation(
                      description: locationData.description,
                      address: locationData.street,
                      latitude: locationData.position.latitude,
                      longitude: locationData.position.longitude,
                    );
                    await mapRouteCubit.setToPlace(location);
                    searchLocationsCubit.insertHistoryPlace(location);
                    onFetchPlan();
                  },
                  child: Text(
                    localization.commonDestination,
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
