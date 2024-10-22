import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'charging_feature_model.dart';
import 'charging_icons.dart';
import 'modal/charging_modal_icons.dart';
import 'modal/charging_modal_models.dart';

class ChargingMarkerModal extends StatefulWidget {
  final ChargingFeature element;
  final void Function() onFetchPlan;

  const ChargingMarkerModal({
    Key? key,
    required this.element,
    required this.onFetchPlan,
  }) : super(key: key);

  @override
  _ChargingMarkerModalState createState() => _ChargingMarkerModalState();
}

class _ChargingMarkerModalState extends State<ChargingMarkerModal> {
  bool loading = true;
  String? fetchError;
  ChargingItem? chargingItem;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      loadData();
    });
  }

  @override
  void didUpdateWidget(covariant ChargingMarkerModal oldWidget) {
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
    final localizationST = StadtnaviBaseLocalization.of(context);
    final localeName = TrufiBaseLocalization.of(context).localeName;
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SvgPicture.string(
                  chargingIcon,
                ),
              ),
              Expanded(
                child: Text(
                  chargingItem?.name ?? "",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (loading)
                LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                )
              else if (chargingItem != null) ...[
                if (chargingItem!.openingTimes?["twentyfourseven"] == true) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        localizationST.commonOpenAlways,
                        style: TextStyle(
                          color: theme.textTheme. bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 10),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: chargingItem!.connectors.values
                            .map(
                              (e) => Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    margin: const EdgeInsets.only(right: 5),
                                    child: SvgPicture.string(
                                      chargingTypeIcons[e.standard] ?? "",
                                    ),
                                  ),
                                  Text(
                                    "${chargingTypeName[e.standard] ?? e.standard} - ${e.maxElectricPower} kW",
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      const Text("|"),
                      Text(
                        chargingItem?.showCapacity == 0
                            ? localeName == "en"
                                ? "${widget.element.available} of ${widget.element.capacity} charging slots available"
                                : "${widget.element.available} von ${widget.element.capacity} Ladeplätzen frei"
                            : localeName == "en"
                                ? "${widget.element.capacity} charging slots"
                                : "${widget.element.capacity} Ladeplätze",
                        style: TextStyle(
                          color: theme.textTheme. bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 10),
                if (chargingItem?.capabilities != null &&
                    chargingItem!.capabilities.isNotEmpty)
                  Row(
                    children: [
                      const Icon(
                        Icons.euro,
                        size: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        chargingItem!.capabilities.isNotEmpty
                            ? chargingItem!.capabilities
                                .toList()
                                .where((e) => capabilitiesNameEN[e] != null)
                                .map((e) => localeName == "en"
                                    ? capabilitiesNameEN[e]
                                    : capabilitiesNameDE[e] ?? "")
                                .toList()
                                .join(", ")
                            : (localeName == "en" ? 'Unknown' : 'Unbekannt'),
                        style: TextStyle(
                          color: theme.textTheme. bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${chargingItem!.address}, ${chargingItem!.postalCode}, ${chargingItem!.city}",
                      style: TextStyle(
                        color: theme.textTheme. bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
                if (chargingItem!.evses != null &&
                    chargingItem!.evses!.isNotEmpty &&
                    chargingItem!.evses!.first.phone != null)
                  GestureDetector(
                    onTap: chargingItem?.evses?.first.phone != null
                        ? () {
                            {
                              launch(
                                "tel:${chargingItem!.evses!.first.phone}",
                              );
                            }
                          }
                        : null,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 15,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          chargingItem?.evses?.first.phone != null
                              ? chargingItem!.evses!.first.phone!
                              : (localeName == "en" ? 'Unknown' : 'Unbekannt'),
                          style: chargingItem?.evses?.first.phone != null
                              ? const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                if (chargingItem!.evses != null &&
                    chargingItem!.evses!.isNotEmpty &&
                    chargingItem!.evses!.first.relatedResource != null &&
                    chargingItem!.evses!.first.relatedResource!.isNotEmpty &&
                    chargingItem!.evses!.first.relatedResource!.first["url"] !=
                        null) ...[
                  const Divider(height: 10),
                  GestureDetector(
                    onTap: () {
                      launch(chargingItem!
                          .evses!.first.relatedResource!.first["url"]
                          .toString());
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: SvgPicture.string(
                            deepLinkIcon,
                          ),
                        ),
                        Text(
                          localeName == "en"
                              ? "Start charging"
                              : "Ladevorgang starten",
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                CustomLocationSelector(
                  onFetchPlan: widget.onFetchPlan,
                  locationData: LocationDetail(
                    chargingItem?.name ?? "",
                    "",
                    widget.element.position,
                  ),
                ),
              ] else if (fetchError != null)
                Text(
                  fetchError!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> loadData() async {
    chargingItem = null;
    if (!mounted) return;
    setState(() {
      fetchError = null;
      loading = true;
    });
    await _fetchData().then((value) {
      if (mounted) {
        setState(() {
          chargingItem = value;
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

  Future<ChargingItem> _fetchData() async {
    final response = await http.get(Uri.parse(
      "https://api.ocpdb.de/api/ocpi/2.2/location/${widget.element.id}",
    ));
    final body = jsonDecode(response.body);
    return ChargingItem.fromJson(body as Map);
  }
}
