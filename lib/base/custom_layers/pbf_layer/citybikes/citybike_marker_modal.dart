import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:url_launcher/url_launcher.dart';

import 'citybike_data_fetch.dart';
import 'citybike_feature_model.dart';

class CitybikeMarkerModal extends StatefulWidget {
  final CityBikeFeature element;
  final void Function() onFetchPlan;
  const CitybikeMarkerModal({
    Key? key,
    required this.element,
    required this.onFetchPlan,
  }) : super(key: key);

  @override
  _CitybikeMarkerModalState createState() => _CitybikeMarkerModalState();
}

class _CitybikeMarkerModalState extends State<CitybikeMarkerModal> {
  bool loading = true;
  String? fetchError;
  CityBikeDataFetch? cityBikeDataFetch;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      loadData();
    });
  }

  @override
  void didUpdateWidget(covariant CitybikeMarkerModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.element != widget.element) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadData(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    return ListView(
      children: [
        if (loading)
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        else if (cityBikeDataFetch != null) ...[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: widget.element.type?.image,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cityBikeDataFetch?.name ?? "",
                        style: const TextStyle(fontSize: 20),
                      ),
                      if (widget.element.type != null)
                        Text(
                          widget.element.type?.getTranslate(languageCode) ?? '',
                          style: TextStyle(
                            color: theme.textTheme. bodyLarge?.color
                                ?.withOpacity(.5),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          if ((cityBikeDataFetch!.bikesAvailable ?? 0) > -1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(
                widget.element.type?.getCapacity(
                        languageCode, cityBikeDataFetch!.bikesAvailable!) ??
                    '',
                style: TextStyle(
                  color: theme.textTheme. bodyLarge?.color,
                ),
              ),
            ),
          if (cityBikeDataFetch!.firstNetwork != null &&
              cityBikeDataFetch!.firstNetwork!.hasBook(languageCode))
            Card(
              color: Colors.grey[100],
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityBikeDataFetch!.firstNetwork!
                          .getNetworkBookData(languageCode)
                          .title,
                      style: theme.textTheme. bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: theme.textTheme. bodyLarge?.fontSize,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (cityBikeDataFetch?.getUrl(languageCode) != null)
                      InkWell(
                        onTap: () async {
                          final url = cityBikeDataFetch!.getUrl(languageCode);
                          if (await canLaunch(url ?? '')) {
                            launch(url!);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cityBikeDataFetch!.firstNetwork
                                      ?.getNetworkBookData(languageCode)
                                      .bookText ??
                                  '',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              cityBikeDataFetch!.firstNetwork
                                  ?.getNetworkBookData(languageCode)
                                  .icon,
                              size: 20,
                              color: const Color(0xff007ac9),
                            )
                          ],
                        ),
                      ),
                    CustomLocationSelector(
                      onFetchPlan: widget.onFetchPlan,
                      locationData: LocationDetail(
                        cityBikeDataFetch!.name ?? "",
                        "",
                        widget.element.position,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ] else if (fetchError != null)
          Text(
            fetchError!,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Future<void> loadData() async {
    if (!mounted) return;
    setState(() {
      fetchError = null;
      loading = true;
    });
    await LayersRepository.fetchCityBikesData(widget.element.id).then((value) {
      if (mounted) {
        setState(() {
          cityBikeDataFetch = value;
          loading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          fetchError = "$error";
          loading = false;
        });
      }
    });
  }
}

class CargoBikeMarkerModal extends StatefulWidget {
  final CityBikeFeature element;
  final void Function() onFetchPlan;
  const CargoBikeMarkerModal({
    Key? key,
    required this.element,
    required this.onFetchPlan,
  }) : super(key: key);

  @override
  _CargobikeMarkerModalState createState() => _CargobikeMarkerModalState();
}

class _CargobikeMarkerModalState extends State<CargoBikeMarkerModal> {
  bool loading = true;
  String? fetchError;
  CargoBikeBody? cityBikeDataFetch;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationST = StadtnaviBaseLocalization.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    return ListView(
      children: [
        if (loading)
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        else if (cityBikeDataFetch != null) ...[
          SizedBox(
            height: 200,
            child: Image.network(
              cityBikeDataFetch!.photo,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: widget.element.type?.image,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cityBikeDataFetch!.name,
                        style: const TextStyle(fontSize: 20),
                      ),
                      if (widget.element.type != null)
                        Text(
                          widget.element.type?.getTranslate(languageCode) ?? '',
                          style: TextStyle(
                            color: theme.textTheme. bodyLarge?.color
                                ?.withOpacity(.5),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (cityBikeDataFetch!.twentyfourseven)
            Row(
              children: [
                const SizedBox(
                  width: 50,
                ),
                const Icon(
                  Icons.access_time,
                  color: Colors.grey,
                  size: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  localizationST.commonOpenAlways,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          const Divider(),
          Row(
            children: [
              Container(
                height: 20,
                width: 20,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: widget.element.type?.image,
              ),
              Text(
                languageCode == "en" ? "Cargo bike" : "Lastenfahrrad",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              const Text(
                " | ",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Text(
                languageCode == "en" ? "1 of 1 available" : "1 von 1 verfügbar",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.location_on,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "${cityBikeDataFetch!.address}, ${cityBikeDataFetch!.postalcode} ${cityBikeDataFetch!.locality}",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              const Icon(
                Icons.credit_card,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 5,
              ),
              TextButton(
                onPressed: () {
                  // launch(cityBikeDataFetch.bookingUrl);
                },
                child: Text(
                  languageCode == "en" ? "Book" : "Buchen",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          CustomLocationSelector(
            onFetchPlan: widget.onFetchPlan,
            locationData: LocationDetail(
              cityBikeDataFetch!.name,
              "",
              widget.element.position,
            ),
          ),
        ] else
          Text(
            fetchError ?? '',
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  void loadData() {
    if (!mounted) return;
    setState(() {
      fetchError = null;
      loading = true;
    });
    _fetchData(widget.element.id).then((value) {
      if (mounted) {
        setState(() {
          cityBikeDataFetch = value;
          loading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          fetchError = "$error";
          loading = false;
        });
      }
    });
  }

  Future<CargoBikeBody> _fetchData(String slug) async {
    final response = await http.get(Uri.parse(
      "https://backend.open-booking.eu/api/v1/location?slug=$slug",
    ));
    final body = jsonDecode(response.body);
    return CargoBikeBody.fromJson(body["data"] as Map);
  }
}

class CargoBikeBody {
  final String address;
  final String postalcode;
  final String locality;
  final String bookingUrl;
  final String name;
  final String photo;
  final bool twentyfourseven;
  CargoBikeBody.fromJson(Map data)
      : address = data["address"] as String,
        postalcode = data["postalcode"] as String,
        locality = data["locality"] as String,
        bookingUrl = data["booking_url"] as String,
        name = data["name"] as String,
        photo = data["photo"]["url"] as String,
        twentyfourseven = data["twentyfourseven"] as bool;
}
