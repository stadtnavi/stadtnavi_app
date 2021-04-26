import 'package:flutter/material.dart';
import 'package:stadtnavi_app/widgets/trufi_map.dart';
import 'package:trufi_core/location/location_form_field.dart';
import 'package:trufi_core/trufi_map_utils.dart';
import 'package:trufi_core/trufi_models.dart';
import 'package:trufi_core/widgets/from_marker.dart';
import 'package:trufi_core/widgets/map_type_button.dart';
import 'package:trufi_core/widgets/to_marker.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:trufi_core/widgets/your_location_button.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/';

  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return AppBar(
      bottom: PreferredSize(
        preferredSize: isPortrait
            ? const Size.fromHeight(45.0)
            : const Size.fromHeight(0.0),
        child: Container(),
      ),
      flexibleSpace: isPortrait
          ? _buildFormFieldsPortrait(context)
          : _buildFormFieldsLandscape(context),
    );
  }

  Widget _buildFormFieldsPortrait(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildFormField(
                UniqueKey(),
                const ValueKey("keys.homePageFromPlaceField"),
                "Search Origin",
                const FromMarker(),
                (_) {},
                leading: const SizedBox.shrink(),
                trailing: true ? _buildResetButton(context) : null,
              ),
              _buildFormField(
                UniqueKey(),
                const ValueKey("keys.homePageToPlaceField"),
                "Search Destination",
                const ToMarker(),
                (_) {},
                leading: const SizedBox.shrink(),
                trailing: true
                    ? _buildSwapButton(context, Orientation.portrait)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFieldsLandscape(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12.0, 4.0, 4.0, 4.0),
        child: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(
                width: 40.0,
              ),
              Flexible(
                child: _buildFormField(
                  UniqueKey(),
                  const ValueKey("homePageFromPlaceField"),
                  "localization.searchPleaseSelectOrigin",
                  const FromMarker(),
                  (_) {},
                ),
              ),
              SizedBox(
                width: 40.0,
                child: true
                    ? _buildSwapButton(context, Orientation.landscape)
                    : null,
              ),
              Flexible(
                child: _buildFormField(
                  UniqueKey(),
                  const ValueKey("homePageToPlaceField"),
                  "localization.searchPleaseSelectDestination",
                  const ToMarker(),
                  (_) {},
                ),
              ),
              SizedBox(
                width: 40.0,
                child: true ? _buildResetButton(context) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwapButton(BuildContext context, Orientation orientation) {
    return FittedBox(
      child: IconButton(
        icon: Icon(
          orientation == Orientation.portrait
              ? Icons.swap_vert
              : Icons.swap_horiz,
          color: Colors.white,
        ),
        onPressed: () async {},
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return FittedBox(
      child: IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.white,
        ),
        onPressed: _reset,
      ),
    );
  }

  Widget _buildFormField(Key key, ValueKey<String> valueKey, String hintText,
      Widget textLeadingImage, Function(TrufiLocation) onSaved,
      {Widget leading, Widget trailing}) {
    final children = <Widget>[];

    if (leading != null) {
      children.add(SizedBox(
        width: 5.0,
        child: leading,
      ));
    }

    children.add(Expanded(
      key: valueKey,
      child: LocationFormField(
        key: key,
        hintText: hintText,
        onSaved: onSaved,
        leadingImage: textLeadingImage,
      ),
    ));

    if (trailing != null) {
      children.add(SizedBox(
        width: 40.0,
        child: trailing,
      ));
    }

    return Row(children: children);
  }

  Widget _buildBody(BuildContext context) {
    // return Container();
    return PlanEmptyPage(
      onLongPress: (_) {},
    );
  }

  void _reset() {}
}

class PlanEmptyPage extends StatefulWidget {
  const PlanEmptyPage({this.initialPosition, this.onLongPress, Key key})
      : super(key: key);

  final LatLng initialPosition;
  final LongPressCallback onLongPress;

  @override
  PlanEmptyPageState createState() => PlanEmptyPageState();
}

class PlanEmptyPageState extends State<PlanEmptyPage>
    with TickerProviderStateMixin {
  final _trufiMapController = StadtnaviMapController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      SatdnaviOnlineMap(
        key: const ValueKey("PlanEmptyMap"),
        controller: _trufiMapController,
        onLongPress: widget.onLongPress,
        layerOptionsBuilder: (context) {
          return <LayerOptions>[
            _trufiMapController.yourLocationLayer,
          ];
        },
      ),
      Positioned(
        bottom: 16.0,
        right: 5.0,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.layers,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.gps_fixed,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildUpperActionButtons(BuildContext context) {
    return const SafeArea(
      child: MapTypeButton(),
    );
  }

  Widget _buildLowerActionButtons(BuildContext context) {
    return SafeArea(
      child: YourLocationButton(onPressed: () {
        _trufiMapController.moveToYourLocation(
          context: context,
          tickerProvider: this,
        );
      }),
    );
  }
}

class SatdnaviOnlineMap extends StatefulWidget {
  const SatdnaviOnlineMap({
    Key key,
    @required this.controller,
    @required this.layerOptionsBuilder,
    this.onTap,
    this.onLongPress,
    this.onPositionChanged,
  }) : super(key: key);

  final StadtnaviMapController controller;
  final LayerOptionsBuilder layerOptionsBuilder;
  final TapCallback onTap;
  final LongPressCallback onLongPress;
  final PositionCallback onPositionChanged;

  @override
  SatdnaviOnlineMapState createState() => SatdnaviOnlineMapState();
}

// TODO: I would recommend to have here an App State with the Plan, MapTyle, Locations etc.
// Everything that is related to the Map currently we collect from the Preferences
// and the HomePageBloc
class SatdnaviOnlineMapState extends State<SatdnaviOnlineMap> {
  @override
  Widget build(BuildContext context) {
    return StatdnaviMap(
      key: const ValueKey("TrufiOnlineMap"),
      controller: widget.controller,
      mapOptions: MapOptions(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onPositionChanged: _handleOnPositionChanged,
        center: LatLng(48.5950, 8.8672),
      ),
      layerOptionsBuilder: (context) {
        return <LayerOptions>[
          tileHostingTileLayerOptions(
            getTilesEndpointForMapType("streets"),
            tileProviderKey: "31Z1wlGBdnxs1UWg6PEc",
          ),
          // ...widget.layerOptionsBuilder(context),
        ];
      },
    );
  }

  void _handleOnPositionChanged(
    MapPosition position,
    bool hasGesture,
  ) {
    if (widget.onPositionChanged != null) {
      Future.delayed(Duration.zero, () {
        widget.onPositionChanged(position, hasGesture);
      });
    }
  }
}
