import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';

import 'package:trufi_core/base/const/consts.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/pages/saved_places/search_locations_cubit/search_locations_cubit.dart';

class LoadLocation extends StatefulWidget {
  final LatLng location;
  final AsyncCallback onFetchPlan;
  final String? preferredDescription;
  const LoadLocation({
    Key? key,
    required this.location,
    required this.onFetchPlan,
    this.preferredDescription,
  }) : super(key: key);
  @override
  _LoadLocationState createState() => _LoadLocationState();
}

class _LoadLocationState extends State<LoadLocation> {
  bool loading = true;
  String? fetchError;
  LocationDetail? locationData;
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      loadData();
    });
  }

  @override
  void didUpdateWidget(covariant LoadLocation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location ||
        oldWidget.preferredDescription != widget.preferredDescription) {
      WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (loading)
                LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.secondary),
                )
              else if (locationData != null) ...[
                Text(
                  locationData!.description,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  locationData!.street,
                  style: TextStyle(color: hintTextColor(theme)),
                ),
                const SizedBox(height: 20),
                CustomLocationSelector(
                  locationData: locationData!,
                  onFetchPlan: () {
                    Navigator.of(context).pop();
                    widget.onFetchPlan();
                  },
                ),
              ] else if (fetchError != null)
                Text(
                  fetchError!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    if (!mounted) return;
    final loadGeneration = ++_loadGeneration;
    setState(() {
      fetchError = null;
      loading = true;
    });
    await _fetchData().then((value) {
      if (mounted && loadGeneration == _loadGeneration) {
        setState(() {
          locationData = value;
          loading = false;
        });
      }
    }).catchError((error) {
      if (mounted && loadGeneration == _loadGeneration) {
        setState(() {
          fetchError = "$error";
          loading = false;
        });
      }
    });
  }

  Future<LocationDetail> _fetchData() async {
    final searchLocationsCubit = context.read<SearchLocationsCubit>();
    final location = widget.location;
    final preferredDescription = widget.preferredDescription;
    return searchLocationsCubit
        .reverseGeodecoding(
          location,
          lang: Localizations.localeOf(context).languageCode,
        )
        .then(
          (result) => LocationDetail(
            preferredDescription ?? result.description,
            result.street,
            location,
          ),
        )
        .catchError((error) {
      return LocationDetail(
        preferredDescription ?? "unknown place",
        "",
        location,
      );
    });
  }
}
