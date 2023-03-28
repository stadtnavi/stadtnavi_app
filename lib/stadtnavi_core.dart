import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/custom_layers/map_layers/map_leyers.dart';
import 'package:stadtnavi_core/base/pages/home/services/custom_search_location/online_search_location.dart';
import 'package:stadtnavi_core/configuration/attribution_map.dart';
import 'package:stadtnavi_core/configuration/custom_async_executor.dart';
import 'package:stadtnavi_core/configuration/custom_marker_configuration.dart';
import 'package:stadtnavi_core/default_stadtnavi_values.dart';
import 'package:stadtnavi_core/stadtnavi_screen_helper.dart';

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/blocs/map_tile_provider/map_tile_provider.dart';
import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';
import 'package:trufi_core/base/widgets/drawer/menu/menu_item.dart';
import 'package:trufi_core/base/widgets/drawer/menu/social_media_item.dart';
import 'package:trufi_core/trufi_core.dart';
import 'package:trufi_core/trufi_router.dart';

class StadtnaviApp extends StatelessWidget {
  final String appNameTitle;
  final String appName;
  final String cityName;
  final String otpGraphqlEndpoint;
  final String urlFeedback;
  final String urlShareApp;
  final String urlRepository;
  final String urlImpressum;
  final Uri reportDefectsUri;
  final Map<String, dynamic>? searchLocationQueryParameters;
  final LatLng center;
  final double? onlineZoom;
  final List<CustomLayerContainer> layersContainer;
  final UrlSocialMedia urlSocialMedia;
  final TrufiBaseTheme? trufiBaseTheme;
  final List<MapTileProvider>? mapTileProviders;

  // TODO we need improve these params
  final List<TrufiMenuItem>? extraDrawerItems;
  final RouterBuilder? extraRoutes;
  final List<BlocProvider>? extraBlocs;
  final WidgetBuilder? extraFloatingMapButtons;

  final AppLifecycleReactorHandler? appLifecycleReactorHandler;
  const StadtnaviApp({
    Key? key,
    required this.appNameTitle,
    required this.appName,
    required this.cityName,
    required this.otpGraphqlEndpoint,
    required this.urlFeedback,
    required this.urlShareApp,
    required this.urlRepository,
    required this.urlImpressum,
    required this.reportDefectsUri,
    this.searchLocationQueryParameters,
    required this.center,
    this.onlineZoom,
    required this.layersContainer,
    required this.urlSocialMedia,
    this.trufiBaseTheme,
    this.mapTileProviders,
    this.extraDrawerItems,
    this.extraRoutes,
    this.extraBlocs,
    this.extraFloatingMapButtons,
    this.appLifecycleReactorHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TrufiApp(
      appNameTitle: appNameTitle,
      trufiBaseTheme: trufiBaseTheme,
      trufiLocalization: DefaultStadtnaviValues.trufiLocalization(),
      blocProviders: DefaultStadtnaviValues.blocProviders(
        otpGraphqlEndpoint: otpGraphqlEndpoint,
        mapConfiguration: MapConfiguration(
          center: center,
          onlineZoom: onlineZoom ?? 13,
          markersConfiguration: const CustomMarkerConfiguration(),
          mapAttributionBuilder: stadtNaviAttributionBuilder,
        ),
        searchLocationRepository: OnlineSearchLocation(
          queryParameters: searchLocationQueryParameters,
        ),
        layersContainer: layersContainer,
        mapTileProviders: mapTileProviders ??
            [
              MapLayer(MapLayerIds.streets),
              MapLayer(MapLayerIds.satellite),
              MapLayer(MapLayerIds.bike),
            ],
        extraBlocs: extraBlocs,
      ),
      trufiRouter: TrufiRouter(
        routerDelegate: DefaultStadtnaviValues.routerDelegate(
          appLifecycleReactorHandler: appLifecycleReactorHandler,
          appName: appName,
          cityName: cityName,
          backgroundImageBuilder: (_) {
            return Image.asset(
              'assets/images/drawer-bg.jpg',
              fit: BoxFit.cover,
            );
          },
          urlFeedback: urlFeedback,
          urlRepository: urlRepository,
          urlShareApp: urlShareApp,
          urlSocialMedia: urlSocialMedia,
          urlImpressum: urlImpressum,
          reportDefectsUri: reportDefectsUri,
          asyncExecutor: customAsyncExecutor,
          extraDrawerItems: extraDrawerItems,
          extraRoutes: extraRoutes,
          extraFloatingMapButtons: extraFloatingMapButtons,
        ),
      ),
    );
  }
}
