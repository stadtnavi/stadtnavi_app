import 'dart:async';
import 'package:async_executor/async_executor.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_park_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/bike_parks_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/bike_parks/citybike_marker_modal.dart'
    as bike_parking;
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_marker_modal.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/charging/charging_marker_modal.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_marker_modal.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parkings_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/poi_marker_modal.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/pois/pois_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/stops/stop_marker_modal/stop_marker_modal_base.dart';
import 'package:stadtnavi_core/base/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_core/base/pages/home/banner_alerts.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/global_alerts_cubit/global_alerts_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';

import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/search_location_field/home_app_bar.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/maps/trufi_map_cubit/trufi_map_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/plan_itinerary_tabs/custom_itinerary.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/load_location.dart';
import 'package:stadtnavi_core/deep_links/stadtnavi_web_url.dart';

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/blocs/providers/gps_location_provider.dart';
import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/pages/saved_places/search_locations_cubit/search_locations_cubit.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:trufi_core/base/widgets/custom_scrollable_container.dart';

typedef MapRouteBuilder = Widget Function(
  BuildContext,
  TrufiMapController,
);

class HomePage extends StatefulWidget {
  static const String route = "/Home";
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final WidgetBuilder drawerBuilder;
  final MapRouteBuilder mapBuilder;
  final AsyncExecutor asyncExecutor;
  final StadtnaviDeepLink? deepLink;
  final String? deepLinkRequest;
  const HomePage({
    super.key,
    required this.drawerBuilder,
    required this.mapBuilder,
    required this.asyncExecutor,
    this.deepLink,
    this.deepLinkRequest,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        TraceableClientMixin {
  final TrufiMapController trufiMapController = TrufiMapController();
  String? _lastProcessedDeepLinkRequest;
  int _deepLinkGeneration = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      final mapRouteCubit = context.read<MapRouteCubit>();
      final mapRouteState = mapRouteCubit.state;
      repaintMap(mapRouteCubit, mapRouteState);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => processIncomingRoute());
    WidgetsBinding.instance.addPostFrameCallback(
      (duration) => context
          .read<GlobalAlertsCubit>()
          .load(Localizations.localeOf(context).languageCode),
    );
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deepLinkRequest != widget.deepLinkRequest) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => processIncomingRoute(),
      );
    }
  }

  @override
  String get actionName => 'HomePage-(Mobile-App)';

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> processIncomingRoute() async {
    final deepLink = widget.deepLink;
    final deepLinkRequest = widget.deepLinkRequest;
    if (deepLink != null &&
        deepLinkRequest != null &&
        deepLinkRequest != _lastProcessedDeepLinkRequest) {
      _lastProcessedDeepLinkRequest = deepLinkRequest;
      final generation = ++_deepLinkGeneration;
      try {
        await _handleDeepLink(deepLink, generation);
      } catch (error, stackTrace) {
        debugPrint('Could not open stadtnavi deep link: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      return;
    }

    final queryParameters = RouteData.of(context).queryParameters;
    if (queryParameters['FetchRoute'] != null &&
        queryParameters['FetchRoute'] == "true") {
      await _callFetchPlan(context);
    }
  }

  Future<void> _handleDeepLink(
    StadtnaviDeepLink deepLink,
    int generation,
  ) async {
    if (deepLink is StadtnaviLocationDeepLink) {
      await _showLocation(deepLink.location, generation: generation);
    } else if (deepLink is StadtnaviAddressDeepLink) {
      await _showAddress(deepLink.query, generation);
    } else if (deepLink is StadtnaviJourneyDeepLink) {
      await _showJourney(deepLink, generation);
    } else if (deepLink is StadtnaviStopDeepLink) {
      await _showStop(deepLink, generation);
    } else if (deepLink is StadtnaviRentalStationDeepLink) {
      await _showRentalStation(deepLink, generation);
    } else if (deepLink is StadtnaviParkingDeepLink) {
      await _showParking(deepLink, generation);
    } else if (deepLink is StadtnaviPoiDeepLink) {
      await _showPoi(deepLink, generation);
    } else if (deepLink is StadtnaviChargingStationDeepLink) {
      await _showChargingStation(deepLink, generation);
    }
  }

  Future<void> _showAddress(String query, int generation) async {
    if (!mounted) return;
    final localization = TrufiBaseLocalization.of(context);
    final searchLocationsCubit = context.read<SearchLocationsCubit>();

    try {
      final results = await searchLocationsCubit.fetchLocations(
        query,
        lang: Localizations.localeOf(context).languageCode,
      );
      if (!mounted || generation != _deepLinkGeneration) return;

      TrufiLocation? resolvedLocation;
      for (final result in results ?? const <TrufiPlace>[]) {
        if (result is TrufiLocation &&
            result.latitude.isFinite &&
            result.longitude.isFinite &&
            result.latitude >= -90 &&
            result.latitude <= 90 &&
            result.longitude >= -180 &&
            result.longitude <= 180 &&
            (result.latitude != 0 || result.longitude != 0)) {
          resolvedLocation = result;
          break;
        }
      }

      if (resolvedLocation == null) {
        _showIncomingLocationError(localization.commonNoResults);
        return;
      }

      await _showLocation(
        StadtnaviLinkLocation(
          label:
              resolvedLocation.description.trim().isEmpty
                  ? query
                  : resolvedLocation.description,
          latitude: resolvedLocation.latitude,
          longitude: resolvedLocation.longitude,
        ),
        generation: generation,
      );
    } catch (_) {
      if (mounted && generation == _deepLinkGeneration) {
        _showIncomingLocationError(localization.errorNoConnectServer);
      }
    }
  }

  void _showIncomingLocationError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showLocation(
    StadtnaviLinkLocation location, {
    int? generation,
  }) async {
    if (!mounted ||
        (generation != null && generation != _deepLinkGeneration)) {
      return;
    }
    final position = LatLng(location.latitude, location.longitude);
    context.read<PanelCubit>().setPanel(
          CustomMarkerPanel(
            panel: (context, onFetchPlan, {isOnlyDestination}) => LoadLocation(
              location: position,
              preferredDescription: location.label,
              onFetchPlan: () async => onFetchPlan(),
            ),
            position: position,
            minSize: 130,
          ),
        );
    await _focusMap(position, generation: generation);
  }

  Future<void> _showJourney(
    StadtnaviJourneyDeepLink deepLink,
    int generation,
  ) async {
    if (!mounted) return;
    final mapRouteCubit = context.read<MapRouteCubit>();
    final panelCubit = context.read<PanelCubit>();
    final searchLocationsCubit = context.read<SearchLocationsCubit>();
    final from = _toTrufiLocation(deepLink.from);
    final to = _toTrufiLocation(deepLink.to);

    panelCubit.cleanPanel();
    await mapRouteCubit.reset();
    await mapRouteCubit.setFromPlace(from);
    await mapRouteCubit.setToPlace(to);
    if (!mounted || generation != _deepLinkGeneration) return;
    searchLocationsCubit.insertHistoryPlace(from);
    searchLocationsCubit.insertHistoryPlace(to);
    await _focusMap(to.latLng, generation: generation);
    if (mounted && generation == _deepLinkGeneration) {
      await _callFetchPlan(context);
    }
  }

  Future<void> _showStop(
    StadtnaviStopDeepLink deepLink,
    int generation,
  ) async {
    final stop = await LayersRepository.fetchStopCached(deepLink.id);
    if (!mounted ||
        generation != _deepLinkGeneration ||
        stop.lat == null ||
        stop.lon == null) {
      return;
    }
    final position = LatLng(stop.lat!, stop.lon!);
    final stopFeature = StopFeature(
      code: stop.code,
      gtfsId: stop.gtfsId ?? deepLink.id,
      name: stop.name,
      parentStation: stop.parentStation?.gtfsId,
      patterns: null,
      platform: stop.platformCode,
      type: stop.vehicleMode?.name.toUpperCase() ?? 'BUS',
      position: position,
    );
    context.read<PanelCubit>().setPanel(
          CustomMarkerPanel(
            panel: (context, _, {isOnlyDestination}) => StopMarkerModalBase(
              stopFeature: stopFeature,
              initialIndex: deepLink.initialTab,
            ),
            position: position,
            minSize: 130,
          ),
        );
    await _focusMap(position, generation: generation);
  }

  Future<void> _showRentalStation(
    StadtnaviRentalStationDeepLink deepLink,
    int generation,
  ) async {
    final station = await LayersRepository.fetchCityBikesData(deepLink.id);
    if (!mounted ||
        generation != _deepLinkGeneration ||
        station.lat == null ||
        station.lon == null) {
      return;
    }
    final position = LatLng(station.lat!, station.lon!);
    final feature = CityBikeFeature(
      geoJsonPoint: null,
      id: deepLink.id,
      type: station.firstNetwork,
      position: position,
      extraInfo: station,
    );
    final selectedMarker = CityBikesLayer(
      MapLayerCategory(
        code: station.firstNetwork?.name ?? 'station',
        en: '',
        de: '',
        categories: const [],
      ),
      3,
    ).buildMarker(
      element: feature,
      markerSize: CustomLayer.getMarkerSize(
        context
            .read<MapConfigurationCubit>()
            .state
            .chooseLocationZoom
            .round(),
      ),
      isSelected: true,
    );
    context.read<PanelCubit>().setPanel(
          CustomMarkerPanel(
            panel: (context, onFetchPlan, {isOnlyDestination}) =>
                CitybikeMarkerModal(
              key: ValueKey(deepLink.id),
              element: feature,
              onFetchPlan: onFetchPlan,
            ),
            position: position,
            minSize: 50,
          ),
          selectedMarker: selectedMarker,
        );
    await _focusMap(position, generation: generation);
  }

  Future<void> _showParking(
    StadtnaviParkingDeepLink deepLink,
    int generation,
  ) async {
    try {
      final parking = await LayersRepository.fetchPark(deepLink.id);
      if (!mounted || generation != _deepLinkGeneration) return;
      if (parking.lat == null || parking.lon == null) {
        final fallback = deepLink.fallbackLocation;
        if (fallback != null) {
          await _showLocation(fallback, generation: generation);
        }
        return;
      }
      final position = LatLng(parking.lat!, parking.lon!);
      final tags = parking.tags?.join(',');
      if (deepLink.isBicycleParking) {
        final feature = BikeParkFeature(
          id: deepLink.id,
          name: parking.name,
          tags: tags,
          bicyclePlaces: true,
          anyCarPlaces: parking.anyCarPlaces,
          bicyclePlacesCapacity: parking.capacity?.bicycleSpaces,
          type: tags?.contains('osm:covered') ?? false
              ? BikeParkLayerIds.covered
              : BikeParkLayerIds.notCovered,
          position: position,
        );
        context.read<PanelCubit>().setPanel(
              CustomMarkerPanel(
                panel: (context, onFetchPlan, {isOnlyDestination}) =>
                    bike_parking.CitybikeMarkerModal(
                  element: feature,
                  onFetchPlan: onFetchPlan,
                ),
                position: position,
                minSize: 50,
              ),
            );
      } else {
        final feature = ParkingFeature(
          geoJsonPoint: null,
          id: deepLink.id,
          name: parking.name,
          note: parking.note,
          url: parking.detailsUrl,
          state: null,
          tags: tags,
          openingHours: parking.openingHours,
          feeHours: null,
          bicyclePlaces: parking.capacity?.bicycleSpaces != null,
          anyCarPlaces: parking.anyCarPlaces,
          carPlaces: parking.anyCarPlaces,
          wheelchairAccessibleCarPlaces:
              parking.capacity?.wheelchairAccessibleCarSpaces != null,
          wheelchairAccessibleCarSpaces:
              parking.capacity?.wheelchairAccessibleCarSpaces,
          realTimeData: parking.availability != null,
          capacity: parking.capacity?.carSpaces?.toString(),
          bicyclePlacesCapacity: parking.capacity?.bicycleSpaces,
          carPlacesCapacity: parking.capacity?.carSpaces,
          availabilityCarPlacesCapacity: parking.availability?.carSpaces,
          totalDisabled: parking.capacity?.wheelchairAccessibleCarSpaces,
          freeDisabled: parking.availability?.wheelchairAccessibleCarSpaces,
          type: ParkingsLayerIds.parkRide,
          sOpeningHours: null,
          position: position,
        );
        context.read<PanelCubit>().setPanel(
              CustomMarkerPanel(
                panel: (context, onFetchPlan, {isOnlyDestination}) =>
                    ParkingMarkerModal(
                  parkingFeature: feature,
                  onFetchPlan: onFetchPlan,
                  isOnlyDestination: isOnlyDestination ?? false,
                ),
                position: position,
                minSize: 50,
              ),
            );
      }
      await _focusMap(position, generation: generation);
    } catch (_) {
      if (!mounted || generation != _deepLinkGeneration) return;
      final fallback = deepLink.fallbackLocation;
      if (fallback == null) rethrow;
      await _showLocation(fallback, generation: generation);
    }
  }

  Future<void> _showPoi(
    StadtnaviPoiDeepLink deepLink,
    int generation,
  ) async {
    try {
      final position = LatLng(
        deepLink.location.latitude,
        deepLink.location.longitude,
      );
      final poi = await LayersRepository.fetchPoi(
        osmId: deepLink.osmId,
        category: deepLink.category,
        position: position,
      );
      if (!mounted || generation != _deepLinkGeneration) return;
      final mapCategory = HBLayerData.findCategoryRecursively(
        HBLayerData.categories,
        poi.category2,
      );
      final category = mapCategory == null
          ? HBLayerData.findCategoryRecursively(
              HBLayerData.categories,
              deepLink.category,
            )
          : MapLayerCategory.findCategoryWithProperties(
              mapCategory,
              poi.category3,
            );
      final markerCategory = mapCategory ?? category;
      final selectedMarker = markerCategory == null
          ? null
          : MapPoiLayer(markerCategory, 3).buildMarker(
              element: poi,
              markerSize: CustomLayer.getMarkerSize(
                context
                    .read<MapConfigurationCubit>()
                    .state
                    .chooseLocationZoom
                    .round(),
              ),
              isSelected: true,
            );
      context.read<PanelCubit>().setPanel(
            CustomMarkerPanel(
              panel: (context, onFetchPlan, {isOnlyDestination}) =>
                  PoiMarkerModal(
                element: poi,
                onFetchPlan: onFetchPlan,
                targetMapLayerCategory: category,
              ),
              position: position,
              minSize: 50,
            ),
            selectedMarker: selectedMarker,
          );
      await _focusMap(position, generation: generation);
    } catch (_) {
      if (!mounted || generation != _deepLinkGeneration) return;
      await _showLocation(deepLink.location, generation: generation);
    }
  }

  Future<void> _showChargingStation(
    StadtnaviChargingStationDeepLink deepLink,
    int generation,
  ) async {
    if (!mounted || generation != _deepLinkGeneration) return;
    final position = LatLng(
      deepLink.location.latitude,
      deepLink.location.longitude,
    );
    final feature = ChargingFeature(
      geoJsonPoint: null,
      id: deepLink.stationId,
      name: deepLink.location.label,
      capacity: null,
      available: null,
      tb: null,
      capacityUnknown: null,
      type: null,
      position: position,
    );
    context.read<PanelCubit>().setPanel(
          CustomMarkerPanel(
            panel: (context, onFetchPlan, {isOnlyDestination}) =>
                ChargingMarkerModal(
              key: ValueKey(deepLink.stationId),
              element: feature,
              onFetchPlan: onFetchPlan,
            ),
            position: position,
            minSize: 50,
          ),
        );
    await _focusMap(position, generation: generation);
  }

  TrufiLocation _toTrufiLocation(StadtnaviLinkLocation location) =>
      TrufiLocation(
        description: location.label,
        address: location.label,
        latitude: location.latitude,
        longitude: location.longitude,
      );

  Future<void> _focusMap(
    LatLng position, {
    int? generation,
  }) async {
    await trufiMapController.onReady;
    if (!mounted ||
        (generation != null && generation != _deepLinkGeneration)) {
      return;
    }
    final mapConfiguration = context.read<MapConfigurationCubit>().state;
    trufiMapController.move(
      center: position,
      zoom: mapConfiguration.chooseLocationZoom,
      tickerProvider: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapRouteCubit = context.watch<MapRouteCubit>();
    final mapModesCubit = context.watch<MapModesCubit>();
    final mapConfiguratiom = context.read<MapConfigurationCubit>().state;
    final panelCubit = context.watch<PanelCubit>();
    final theme = Theme.of(context);
    trufiMapController.onReady.then((value) {
      if (panelCubit.state.panel != null) {
        trufiMapController.move(
          center: panelCubit.state.panel!.position,
          zoom: trufiMapController.mapController.camera.zoom,
          tickerProvider: this,
        );
      }
    });
    return Scaffold(
      key: HomePage.scaffoldKey,
      drawer: widget.drawerBuilder(context),
      appBar: AppBar(
        backgroundColor: ThemeCubit.isDarkMode(theme)
            ? theme.appBarTheme.backgroundColor
            : theme.colorScheme.primary,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: const BannerAlerts()),
            ],
          ),
          HomeAppBar(
            onSaveFrom: (TrufiLocation fromPlace) =>
                mapRouteCubit.setFromPlace(fromPlace).then(
              (value) {
                trufiMapController.move(
                  center: fromPlace.latLng,
                  zoom: mapConfiguratiom.chooseLocationZoom,
                  tickerProvider: this,
                );
                _callFetchPlan(context);
              },
            ),
            onClearFrom: () async {
              mapRouteCubit.resetFromPlaceKeepingToPlace();
              if (mapRouteCubit.state.plan != null) {
                panelCubit.cleanPanel();
                await mapModesCubit.reset();
              }
            },
            onSaveTo: (TrufiLocation toPlace) =>
                mapRouteCubit.setToPlace(toPlace).then(
              (value) {
                trufiMapController.move(
                  center: toPlace.latLng,
                  zoom: mapConfiguratiom.chooseLocationZoom,
                  tickerProvider: this,
                );
                _callFetchPlan(context);
              },
            ),
            onClearTo: () async {
              mapRouteCubit.resetToPlaceKeepingFromPlace();
              if (mapRouteCubit.state.plan != null) {
                panelCubit.cleanPanel();
                await mapModesCubit.reset();
              }
            },
            onBackButton: () {
              HomePage.scaffoldKey.currentState?.openDrawer();
            },
            onFetchPlan: () => _callFetchPlan(context),
            onReset: () async {
              panelCubit.cleanPanel();
              await mapModesCubit.reset();
              await mapRouteCubit.reset();
            },
            onSwap: () => mapRouteCubit
                .swapLocations()
                .then((value) => _callFetchPlan(context)),
          ),
          Expanded(
            child: Stack(
              children: [
                BlocListener<MapRouteCubit, MapRouteState>(
                  listener: (buildContext, state) {
                    trufiMapController.onReady.then((_) {
                      repaintMap(mapRouteCubit, state);
                    });
                  },
                  child: CustomScrollableContainer(
                    openedPosition: 200,
                    body: widget.mapBuilder(
                      context,
                      trufiMapController,
                    ),
                    panel: panelCubit.state.panel == null
                        ? mapRouteCubit.state.plan == null
                            ? null
                            : CustomItinerary(
                                trufiMapController: trufiMapController,
                              )
                        : panelCubit.state.panel?.panel(context, () {
                            panelCubit.cleanPanel();
                            _callFetchPlan(context);
                          }),
                    bottomPadding: panelCubit.state.panel?.minSize ?? 0,
                    onClose: panelCubit.state.panel == null
                        ? null
                        : panelCubit.cleanPanel,
                  ),
                ),
                Positioned(
                  top: -3.5,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xaa000000),
                          offset: Offset(0, 1.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void repaintMap(MapRouteCubit mapRouteCubit, MapRouteState mapRouteState) {
    if (mapRouteState.plan != null && mapRouteState.selectedItinerary != null) {
      trufiMapController.selectedItinerary(
          plan: mapRouteState.plan!,
          from: mapRouteState.fromPlace!,
          to: mapRouteState.toPlace!,
          selectedItinerary: mapRouteState.selectedItinerary!,
          tickerProvider: this,
          showAllItineraries: mapRouteState.showAllItineraries,
          onTap: (p1) {
            mapRouteCubit.selectItinerary(p1);
          });
    } else {
      trufiMapController.cleanMap();
    }
  }

  Future<void> _callFetchPlan(BuildContext context) async {
    final mapRouteCubit = context.read<MapRouteCubit>();
    final mapModesCubit = context.read<MapModesCubit>();
    final settingFetchState = context.read<SettingFetchCubit>().state;
    final mapRouteState = mapRouteCubit.state;
    if (mapRouteState.toPlace == null || mapRouteState.fromPlace == null) {
      return;
    }
    final languageCode = Localizations.localeOf(context).languageCode;
    widget.asyncExecutor.run(
      context: context,
      onExecute: () async {
        await mapModesCubit.reset();
        mapModesCubit
            .fetchModesPlans(
          from: mapRouteState.fromPlace!,
          to: mapRouteState.toPlace!,
          advancedOptions: settingFetchState,
          localeName: languageCode,
        )
            .then(
          (voids) {
            if (!mapRouteCubit.state.isPlacesDefined) {
              mapModesCubit.reset();
            }
          },
        );
        await mapRouteCubit.fetchPlan(
          advancedOptions: settingFetchState,
          localeName: languageCode,
        );
      },
      onFinish: (_) {
        mapModesCubit
            .updateIsFetchingModes(mapModesCubit.state.modesTransport == null);
      },
    );
  }
}
