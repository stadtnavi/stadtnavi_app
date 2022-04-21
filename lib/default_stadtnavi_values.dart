import 'package:async_executor/async_executor.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stadtnavi_core/base/custom_layers/cubits/custom_layer/custom_layers_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/cubits/panel/panel_cubit.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';
import 'package:stadtnavi_core/base/pages/about/about.dart';
import 'package:stadtnavi_core/base/pages/feedback/feedback.dart';
import 'package:stadtnavi_core/base/pages/home/transport_selector/map_modes_cubit/map_modes_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:stadtnavi_core/base/pages/home/home_page.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/trufi_map_route.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:stadtnavi_core/configuration/drawer/menu_items_stadtnavi.dart';
import 'package:stadtnavi_core/configuration/trufi_drawer.dart';

import 'package:trufi_core/base/blocs/map_configuration/map_configuration_cubit.dart';
import 'package:trufi_core/base/blocs/map_tile_provider/map_tile_provider.dart';
import 'package:trufi_core/base/blocs/map_tile_provider/map_tile_provider_cubit.dart';
import 'package:trufi_core/base/pages/about/translations/about_localizations.dart';
import 'package:trufi_core/base/pages/feedback/translations/feedback_localizations.dart';
import 'package:trufi_core/base/pages/saved_places/repository/search_location_repository.dart';
import 'package:trufi_core/base/pages/saved_places/saved_places.dart';
import 'package:trufi_core/base/pages/saved_places/translations/saved_places_localizations.dart';
import 'package:trufi_core/base/widgets/drawer/menu/social_media_item.dart';
import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';
import 'package:trufi_core/base/blocs/localization/trufi_localization_cubit.dart';
import 'package:trufi_core/base/pages/saved_places/search_locations_cubit/search_locations_cubit.dart';
import 'package:trufi_core/base/pages/transport_list/route_transports_cubit/route_transports_cubit.dart';

abstract class DefaultStadtnaviValues {
  static TrufiLocalization trufiLocalization({Locale? currentLocale}) =>
      TrufiLocalization(
        currentLocale: currentLocale ?? const Locale("de"),
        localizationDelegates: const [
          StadtnaviBaseLocalization.delegate,
          SavedPlacesLocalization.delegate,
          FeedbackLocalization.delegate,
          AboutLocalization.delegate,
        ],
        supportedLocales: const [
          Locale('de'),
          Locale('en'),
        ],
      );

  static List<BlocProvider> blocProviders({
    required String otpGraphqlEndpoint,
    required MapConfiguration mapConfiguration,
    required SearchLocationRepository searchLocationRepository,
    required List<CustomLayerContainer> layersContainer,
    required List<MapTileProvider> mapTileProviders,
  }) {
    return [
      BlocProvider<RouteTransportsCubit>(
        create: (context) => RouteTransportsCubit(otpGraphqlEndpoint),
      ),
      BlocProvider<SearchLocationsCubit>(
        create: (context) => SearchLocationsCubit(
          searchLocationRepository: searchLocationRepository,
        ),
      ),
      BlocProvider<MapConfigurationCubit>(
        create: (context) => MapConfigurationCubit(mapConfiguration),
      ),
      BlocProvider<MapRouteCubit>(
        create: (context) => MapRouteCubit(
          otpGraphqlEndpoint,
        ),
      ),
      BlocProvider<MapModesCubit>(
        create: (context) => MapModesCubit(
          otpGraphqlEndpoint,
        ),
      ),
      BlocProvider<SettingFetchCubit>(
        create: (context) => SettingFetchCubit(),
      ),
      BlocProvider<CustomLayersCubit>(
        create: (context) => CustomLayersCubit(layersContainer),
      ),
      BlocProvider<PanelCubit>(
        create: (context) => PanelCubit(),
      ),
      BlocProvider<MapTileProviderCubit>(
        create: (context) => MapTileProviderCubit(
          mapTileProviders: mapTileProviders,
        ),
      ),
    ];
  }

  static RouterDelegate<Object> routerDelegate({
    required String appName,
    required String cityName,
    WidgetBuilder? backgroundImageBuilder,
    AsyncExecutor? asyncExecutor,
    required String urlShareApp,
    required String urlFeedback,
    required String urlRepository,
    UrlSocialMedia? urlSocialMedia,
    String? impressumUrl,
    Uri? reportDefectsUri,
  }) {
    generateDrawer(String currentRoute) {
      return (BuildContext _) => StadtnaviDrawer(
            currentRoute,
            appName: appName,
            cityName: cityName,
            backgroundImageBuilder: backgroundImageBuilder,
            urlShareApp: urlShareApp,
            menuItems: stadtnaviMenuItems(
                defaultUrls: urlSocialMedia,
                reportDefectsUri:
                    Uri.parse('https://www.herrenberg.de/tools/mvs').replace(
                  fragment: "mvPagePictures",
                ),
                impressumUrl: 'https://www.herrenberg.de/impressum'),
          );
    }

    return RoutemasterDelegate(
      routesBuilder: (routeContext) {
        return RouteMap(
          onUnknownRoute: (_) => const Redirect(HomePage.route),
          routes: {
            HomePage.route: (route) => NoAnimationPage(
                  child: HomePage(
                    asyncExecutor: asyncExecutor ?? AsyncExecutor(),
                    mapBuilder: (
                      mapContext,
                      trufiMapController,
                    ) {
                      return TrufiMapRoute(
                        trufiMapController: trufiMapController,
                        asyncExecutor: asyncExecutor ?? AsyncExecutor(),
                      );
                    },
                    drawerBuilder: generateDrawer(HomePage.route),
                  ),
                ),
            SavedPlacesPage.route: (route) => NoAnimationPage(
                  child: SavedPlacesPage(
                    drawerBuilder: generateDrawer(SavedPlacesPage.route),
                  ),
                ),
            FeedbackPage.route: (route) => NoAnimationPage(
                  child: FeedbackPage(
                    urlFeedback: urlFeedback,
                    drawerBuilder: generateDrawer(FeedbackPage.route),
                  ),
                ),
            AboutPage.route: (route) => NoAnimationPage(
                  child: AboutPage(
                    appName: appName,
                    cityName: cityName,
                    urlRepository: urlRepository,
                    drawerBuilder: generateDrawer(AboutPage.route),
                  ),
                ),
          },
        );
      },
    );
  }
}
