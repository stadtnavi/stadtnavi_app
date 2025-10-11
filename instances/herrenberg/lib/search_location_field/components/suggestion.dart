import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:de_stadtnavi_herrenberg_internal/widget/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/repositories/services/gps_lcoation/gps_location.dart';
import 'package:trufi_core/screens/route_navigation/maps/trufi_map_controller.dart';
import 'package:trufi_core/widgets/maps/choose_location/choose_location.dart';

class SuggestionList extends StatefulWidget {
  final String query;
  final bool isOrigin;
  final ValueChanged<TrufiLocation> onSelected;
  final ValueChanged<TrufiLocation> onSelectedMap;
  final ValueChanged<TrufiLocation> onStreetTapped;
  const SuggestionList({
    super.key,
    required this.query,
    required this.isOrigin,
    required this.onSelected,
    required this.onSelectedMap,
    required this.onStreetTapped,
  });

  @override
  State<SuggestionList> createState() => _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor, context: context);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (!stopDefaultButtonEvent) {
      Navigator.pop(context);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // final searchLocationsCubit = context.watch<SearchLocationsCubit>();
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (context) {
          final localizationSP = AppLocalization.of(context);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: CustomScrollView(
              slivers: [
                _BuildYourLocation(widget.onSelected),
                _BuildChooseOnMap(
                  onSelectedMap: widget.onSelectedMap,
                  isOrigin: widget.isOrigin,
                ),
                if (widget.query.isEmpty)
                  _BuildYourPlaces(
                    title: "localizationSP.menuYourPlaces",
                    places: [
                      // ...searchLocationsCubit.state.myDefaultPlaces
                      //     .where((element) => element.isLatLngDefined)
                      //     .toList(),
                      // ...searchLocationsCubit.state.myPlaces,
                    ],
                    onSelected: widget.onSelected,
                  ),
                if (widget.query.isEmpty)
                  _BuildObjectList(
                    title: "localizationSP.searchTitleFavorites",
                    iconData: Icons.place,
                    places: [
                      // searchLocationsCubit.state.favoritePlaces
                    ],
                    onSelected: widget.onSelected,
                    onStreetTapped: widget.onStreetTapped,
                  ),
                if (widget.query.isEmpty)
                  _BuildObjectList(
                    title: "localizationSP.searchTitleRecent",
                    iconData: Icons.history,
                    places: [
                      // searchLocationsCubit.getHistoryList()
                    ],
                    onSelected: widget.onSelected,
                    onStreetTapped: widget.onStreetTapped,
                  ),
                if (widget.query.isNotEmpty)
                  _BuildFutureBuilder(
                    title: "localizationSP.searchTitleResults",
                    // future: searchLocationsCubit.fetchLocations(
                    //   widget.query,
                    //   lang: Localizations.localeOf(context).languageCode,
                    // ),
                    future: Future.value([]),
                    iconData: Icons.place,
                    isVisibleWhenEmpty: true,
                    onSelected: widget.onSelected,
                    onStreetTapped: widget.onStreetTapped,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BuildFutureBuilder extends StatelessWidget {
  final String title;
  final Future<List<TrufiLocation>?> future;
  final IconData iconData;
  final bool isVisibleWhenEmpty;
  final ValueChanged<TrufiLocation> onSelected;
  final ValueChanged<TrufiLocation> onStreetTapped;

  const _BuildFutureBuilder({
    required this.title,
    required this.future,
    required this.iconData,
    required this.onSelected,
    required this.onStreetTapped,
    this.isVisibleWhenEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    return FutureBuilder(
      future: future,
      initialData: null,
      builder:
          (BuildContext context, AsyncSnapshot<List<TrufiLocation>?> snapshot) {
            // Error
            if (snapshot.hasError) {
              return _BuildErrorList(
                title: title,
                error: "localization.errorNoConnectServer,",
              );
            }
            // Loading
            if (snapshot.data == null) {
              return SliverToBoxAdapter(
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
              );
            }
            if (snapshot.data!.isEmpty) {
              return _BuildErrorList(
                title: title,
                error: "localization.commonNoResults",
              );
            }
            // No results
            final int count = snapshot.data!.isNotEmpty
                ? snapshot.data!.length + 1
                : 0;
            if (count == 0 && isVisibleWhenEmpty) {
              return SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    _BuildTitle(title: title),
                    _BuildErrorItem(title: "localization.commonNoResults"),
                  ],
                ),
              );
            }
            // Items
            return _BuildObjectList(
              title: title,
              iconData: iconData,
              places: [],
              // places: context.read<SearchLocationsCubit>().sortedByFavorites(
              //   snapshot.data!,
              // ), // TODO GT remove workaround
              onSelected: onSelected,
              onStreetTapped: onStreetTapped,
            );
          },
    );
  }
}

class _BuildChooseOnMap extends StatelessWidget {
  final ValueChanged<TrufiLocation> onSelectedMap;
  final bool isOrigin;
  const _BuildChooseOnMap({
    required this.onSelectedMap,
    required this.isOrigin,
  });

  @override
  Widget build(BuildContext context) {
    final localizationST = AppLocalization.of(context);
    return SliverToBoxAdapter(
      child: BuildItem(
        onTap: () async {
          final chooseLocationDetail = await ChooseLocationPage.selectLocation(
            context,
            isOrigin: isOrigin,
          );

          if (chooseLocationDetail != null) {
            onSelectedMap(chooseLocationDetail);
          }
        },
        iconData: const Icon(Icons.place),
        title: "localizationST.chooseOnMap",
      ),
    );
  }
}

class _BuildYourPlaces extends StatelessWidget {
  final String title;
  final ValueChanged<TrufiLocation> onSelected;
  final List<TrufiLocation> places;

  const _BuildYourPlaces({
    required this.title,
    required this.onSelected,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationSP = AppLocalization.of(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final TrufiLocation location = places[index];
        return Column(
          children: [
            if (index == 0) _BuildTitle(title: title),
            BuildItem(
              onTap: () {
                onSelected(location);
              },
              iconData: typeToIconDataStadtnavi(
                location.type,
                color: theme.iconTheme.color,
              ),
              title: location.displayName(localizationSP),
              subtitle: location.address,
            ),
          ],
        );
      }, childCount: places.length),
    );
  }
}

class _BuildObjectList extends StatelessWidget {
  final String title;
  final IconData iconData;
  final List<TrufiLocation> places;
  final ValueChanged<TrufiLocation> onSelected;
  final ValueChanged<TrufiLocation> onStreetTapped;

  const _BuildObjectList({
    required this.title,
    required this.iconData,
    required this.places,
    required this.onSelected,
    required this.onStreetTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationSP = AppLocalization.of(context);
    // final searchLocationsCubit = context.watch<SearchLocationsCubit>();
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == 0) {
          return _BuildTitle(title: title);
        }
        final object = places[index - 1];
        // if (object is TrufiLocation) {
        //   return BuildItem(
        //     onTap: () {
        //       searchLocationsCubit.insertHistoryPlace(object);
        //       onSelected(object);
        //     },
        //     iconData: typeToIconDataStadtnavi(
        //       object.type,
        //       color: theme.iconTheme.color,
        //     ),
        //     title: object.displayName(localizationSP),
        //     subtitle: object.address,
        //     trailing: FavoriteButton(location: object),
        //   );
        // } else
        if (object is TrufiLocation) {
          return BuildItem(
            onTap: () {
              onStreetTapped(object);
            },
            iconData: const Icon(Icons.label),
            title: object.displayName(localizationSP),
            trailing: const Icon(Icons.keyboard_arrow_right),
          );
        }
        return Container();
      }, childCount: places.isNotEmpty ? places.length + 1 : 0),
    );
  }
}

class _BuildYourLocation extends StatelessWidget {
  final ValueChanged<TrufiLocation> onMapTapped;

  const _BuildYourLocation(this.onMapTapped);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    return SliverToBoxAdapter(
      child: BuildItem(
        onTap: () => _handleOnYourLocationTapped(context),
        iconData: const Icon(Icons.gps_fixed),
        title: "localization.commonYourLocation",
      ),
    );
  }

  Future<void> _handleOnYourLocationTapped(BuildContext context) async {
    final localization = AppLocalization.of(context);
    final locationProvider = GPSLocationProvider();
    final currentLocation = locationProvider.current;
    if (currentLocation != null) {
      final TrufiLocation value = TrufiLocation(
        description: "localization.commonYourLocation",
        position: currentLocation,
      );
      onMapTapped(value);
    } else {
      await locationProvider.start(context: context);
    }
  }
}

class _BuildErrorList extends StatelessWidget {
  final String title;
  final String error;

  const _BuildErrorList({Key? key, required this.title, required this.error})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          _BuildTitle(title: title),
          _BuildErrorItem(title: error),
        ],
      ),
    );
  }
}

class _BuildTitle extends StatelessWidget {
  final String title;

  const _BuildTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: Row(
        children: <Widget>[
          Container(padding: const EdgeInsets.all(4.0)),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildErrorItem extends StatelessWidget {
  final String title;

  const _BuildErrorItem({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BuildItem(
      onTap: () {},
      iconData: const Icon(Icons.error),
      title: title,
    );
  }
}

class BuildItem extends StatelessWidget {
  final void Function() onTap;
  final Widget iconData;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const BuildItem({
    Key? key,
    required this.onTap,
    required this.iconData,
    required this.title,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
        child: Row(
          children: <Widget>[
            iconData,
            const SizedBox(width: 10.0, height: 48.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14)),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        // color: hintTextColor(theme), //TODO GT define Color
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
