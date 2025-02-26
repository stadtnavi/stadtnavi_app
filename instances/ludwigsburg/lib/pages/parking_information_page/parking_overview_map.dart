import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/home_page.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/stadtnavi_map.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';

import 'package:trufi_core/base/pages/transport_list/route_transports_cubit/route_transports_cubit.dart';
import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/widgets/custom_scrollable_container.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/blocs/providers/gps_location_provider.dart';

class ParkingOverviewMap extends StatefulWidget {
  final ParkingFeature parking;

  const ParkingOverviewMap({
    Key? key,
    required this.parking,
  }) : super(key: key);

  @override
  State<ParkingOverviewMap> createState() => _ParkingOverviewMapState();
}

class _ParkingOverviewMapState extends State<ParkingOverviewMap>
    with TickerProviderStateMixin {
  final TrufiMapController trufiMapController = TrufiMapController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = TrufiBaseLocalization.of(context);
    final panelCubit = context.watch<PanelCubit>();
    final mapConfiguration = context.read<MapConfigurationCubit>().state;
    trufiMapController.onReady.then((value) {
      if (panelCubit.state.panel != null) {
        trufiMapController.move(
          center: panelCubit.state.panel!.position,
          zoom: 17,
          tickerProvider: this,
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              localization.localeName == 'en' ? 'Parking spaces' : 'Parkplätze',
            ),
          ],
        ),
        leading: BackButton(
          onPressed: () {
            panelCubit.cleanPanel();
            Navigator.maybePop(context);
          },
        ),
      ),
      body: BlocBuilder<RouteTransportsCubit, RouteTransportsState>(
        builder: (context, state) {
          return CustomScrollableContainer(
            openedPosition: 300,
            body: Stack(
              children: [
                Column(
                  children: [
                    if (state.isGeometryLoading)
                      const LinearProgressIndicator(),
                    Expanded(
                      child: BlocBuilder<TrufiMapController, TrufiMapState>(
                        bloc: trufiMapController,
                        builder: (context1, state) {
                          return StadtnaviMap(
                            trufiMapController: trufiMapController,
                            showMapTypeButton: false,
                            showLayerById: 'Parking',
                            layerOptionsBuilder: (context) => [],
                            onTap: (_, point) {
                              trufiMapController.move(
                                center: point,
                                zoom: mapConfiguration.chooseLocationZoom,
                                tickerProvider: this,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            panel: panelCubit.state.panel?.panel(context, () {
              _callFetchPlan();
            }, isOnlyDestination: true),
            bottomPadding: panelCubit.state.panel?.minSize ?? 0,
          );
        },
      ),
    );
  }

  Future<void> _callFetchPlan() async {
    final localization = TrufiBaseLocalization.of(context);
    final mapRouteCubit = context.read<MapRouteCubit>();
    final panelCubit = context.read<PanelCubit>();
    final locationProvider = GPSLocationProvider();
    final currentLocation = locationProvider.myLocation;
    if (currentLocation != null) {
      await mapRouteCubit.setFromPlace(TrufiLocation(
        description: localization.commonYourLocation,
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
      ));
      panelCubit.cleanPanel();
      _cleanNavigatorStore();
    } else {
      await locationProvider.startLocation(context);
    }
  }

  void _cleanNavigatorStore() {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    Routemaster.of(context).push(
      HomePage.route,
      queryParameters: {"FetchRoute": "true"},
    );
  }
}
