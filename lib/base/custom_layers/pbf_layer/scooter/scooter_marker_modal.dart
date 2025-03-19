import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/hb_layers_data.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/car_sharing/icon_networks.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_data_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/services/layers_repository.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:stadtnavi_core/base/translations/string_translation.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:url_launcher/url_launcher.dart';

import 'scooter_feature_model.dart';

class ScooterMarkerModal extends StatefulWidget {
  final ScooterFeature element;
  final void Function() onFetchPlan;
  final MapLayerCategory? targetMapLayerCategory;

  const ScooterMarkerModal({
    Key? key,
    required this.element,
    required this.onFetchPlan,
    required this.targetMapLayerCategory,
  }) : super(key: key);

  @override
  State<ScooterMarkerModal> createState() => _ScooterMarkerModalState();
}

class _ScooterMarkerModalState extends State<ScooterMarkerModal> {
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
  void didUpdateWidget(covariant ScooterMarkerModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.element != widget.element) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadData(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationST = StadtnaviBaseLocalization.of(context);
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    final networkName = widget.element.network?.name[languageCode];
    final vehiclesAvailable = cityBikeDataFetch?.bikesAvailable ?? 0;
    const greyColor = Color(0xFF747474);
    const divider = Divider(
      color: greyColor,
      thickness: 0.5,
    );
    String? cityBikeNetworkUrl = widget.element.network?.url != null
        ? widget.element.network!.url![languageCode]
        : '';

    if (cityBikeDataFetch?.rentalUris != null) {
      if (kIsWeb &&
          Platform.isIOS &&
          cityBikeDataFetch!.rentalUris!.ios != null) {
        cityBikeNetworkUrl = cityBikeDataFetch!.rentalUris!.ios;
      } else if ((!kIsWeb && (Platform.isIOS || Platform.isAndroid)) &&
          Platform.isAndroid &&
          cityBikeDataFetch!.rentalUris!.android != null) {
        cityBikeNetworkUrl = cityBikeDataFetch!.rentalUris!.android;
      } else if (cityBikeDataFetch!.rentalUris!.web != null) {
        cityBikeNetworkUrl = cityBikeDataFetch!.rentalUris!.web;
      }
    }
    return ListView(
      children: [
        if (loading)
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        else if (cityBikeDataFetch != null)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.element.name ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        localizationST.translate(
                            "${widget.element.network?.formFactors?.firstOrNull}-station-no-id"),
                      ),
                    ),
                  ],
                ),
                divider,
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(right: 10),
                      child: SvgPicture.string(
                          getNetworkIcon(widget.element.network?.icon)),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: localizationST.translate(
                                  "${widget.element.network?.formFactors?.firstOrNull}-availability"),
                            ),
                            TextSpan(
                              text: '($vehiclesAvailable)',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (cityBikeNetworkUrl != null && cityBikeNetworkUrl.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffF4F4F5),
                      border: Border.all(
                        color: const Color(0xFFDDDDDD),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(top: 16),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                localizationST.translate(
                                    "${widget.element.network?.formFactors?.firstOrNull}-start-using"),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final Uri uri =
                                      Uri.parse(cityBikeNetworkUrl!);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  }
                                },
                                child: Text(
                                  "${localizationST.translate("${widget.element.network?.formFactors?.firstOrNull}-start-using-info")}${(networkName != null ? " $networkName" : '')}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xff9BBF28),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
              ],
            ),
          )
        else if (fetchError != null)
          Text(
            fetchError!,
            style: const TextStyle(color: Colors.red),
          ),
        CustomLocationSelector(
          onFetchPlan: widget.onFetchPlan,
          locationData: LocationDetail(
            widget.element.name ?? "",
            "",
            widget.element.position,
          ),
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
    await LayersRepository.fetchCityBikesData(
            widget.element.id.split(":").skip(1).join(":"))
        .then((value) {
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
