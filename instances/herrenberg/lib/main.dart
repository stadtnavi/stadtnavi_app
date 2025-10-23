import 'package:de_stadtnavi_herrenberg_internal/pages/home/cubits/global_alerts_cubit/global_alerts_cubit.dart';
import 'package:de_stadtnavi_herrenberg_internal/pages/home/cubits/map_route_cubit/map_route_cubit.dart';
import 'package:de_stadtnavi_herrenberg_internal/pages/home/cubits/payload_data_plan/setting_fetch_cubit.dart';
import 'package:de_stadtnavi_herrenberg_internal/pages/home/widgets/plan_itinerary_tabs/custom_itinerary.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core/extensions/translations-st/stadtnavi_base_localizations.dart';
import 'package:de_stadtnavi_herrenberg_internal/pages/home/search_location_field/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'package:trufi_core/consts.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/localization/language_bloc.dart';
import 'package:trufi_core/default_theme.dart';
import 'package:trufi_core/hive_init.dart';
import 'package:trufi_core/pages/home/service/routing_service/otp_stadtnavi/graphql_plan_data_source.dart';
import 'package:trufi_core/pages/home/widgets/routing_map/routing_map_controller.dart';
import 'package:trufi_core/repositories/location/services/stadtnavi_photon_location_search_service.dart';
import 'package:trufi_core/screens/route_navigation/map_layers/bike_parks/bike_parks_layer.dart';
import 'package:trufi_core/screens/route_navigation/map_layers/weather_stations/weather_stations_layer.dart';
import 'package:trufi_core/screens/route_navigation/route_navigation.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String appLocale = 'en';
  Intl.defaultLocale = appLocale;
  await initializeDateFormatting(appLocale);
  await initHiveForFlutter(boxes: []);
  ApiConfig().configure(
    baseDomain: "api.dev.stadtnavi.eu",
    otpPath: "/otp/gtfs/v1",
    originMap: const LatLng(48.5950, 8.8672),
    locationSearchService: StadtnaviPhotonLocationSearchService(
      photonUrl: 'https://photon-eu.stadtnavi.eu/pelias/v1/',
    ),
    faresURL: 'https://api.dev.stadtnavi.eufares',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: MultiProvider(
        providers: [
          BlocProvider<SettingFetchCubit>(
            create: (context) => SettingFetchCubit(isDateReset: true),
          ),
          BlocProvider<GlobalAlertsCubit>(
            create: (context) => GlobalAlertsCubit(
              otpEndpoint: ApiConfig().openTripPlannerUrl,
              feedIds: ['hbg'],
            ),
          ),
          BlocProvider<MapRouteCubit>(
            create: (context) => MapRouteCubit(ApiConfig().openTripPlannerUrl),
          ),
        ],

        child: MaterialApp(
          localizationsDelegates: [
            StadtnaviBaseLocalization.delegate,
            ...AppLocalization.localizationsDelegates!,
          ],
          debugShowCheckedModeBanner: false,
          title: 'stadtnavi|Herrenberg',
          supportedLocales: const [
            Locale('es', 'ES'),
            Locale('pt', 'PT'),
            Locale('pt', 'BR'),
            Locale('de', 'DE'),
            Locale('fr', 'FR'),
          ],
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          home: RouteNavigationScreen(
            routingMapComponent: (controller, planRepository) {
              return RoutingMapComponent(
                controller,
                customPlanRepository: StadtnaviGraphQLPlanDataSource(
                  ApiConfig().openTripPlannerUrl,
                ),
              );
            },
            mapLayerBuilder: (controller) => [
              BikeParksLayer(controller),
              WeatherStationsLayer(controller),
            ],
            routeSearchBuilder:
                ({
                  required destination,
                  required onClearFrom,
                  required onClearTo,
                  required onFetchPlan,
                  required onReset,
                  required onSaveFrom,
                  required onSaveTo,
                  required onSwap,
                  required origin,
                }) => HomeAppBar(
                  onSaveFrom: onSaveFrom,
                  onClearFrom: onClearFrom,
                  onSaveTo: onSaveTo,
                  onClearTo: onClearTo,
                  onBackButton: () {},
                  onFetchPlan: onFetchPlan,
                  onReset: onReset,
                  onSwap: onSwap,
                ),
            bottomSheethBuilder:
                ({
                  required destination,
                  required onClearFrom,
                  required onClearTo,
                  required onFetchPlan,
                  required onReset,
                  required onSaveFrom,
                  required onSaveTo,
                  required onSwap,
                  required origin,
                  required selectedMarker,
                  required context,
                  required iRoutingMapComponent,
                }) =>
                    CustomItinerary(iRoutingMapComponent: iRoutingMapComponent),
          ),
        ),
      ),
    );
  }
}
