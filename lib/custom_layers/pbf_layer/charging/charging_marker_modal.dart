import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import 'charging_feature_model.dart';
import 'charging_icons.dart';
import 'modal/charging_modal_icons.dart';
import 'modal/charging_modal_models.dart';

class ChargingMarkerModal extends StatefulWidget {
  final ChargingFeature element;

  const ChargingMarkerModal({Key key, @required this.element})
      : super(key: key);

  @override
  _ChargingMarkerModalState createState() => _ChargingMarkerModalState();
}

class _ChargingMarkerModalState extends State<ChargingMarkerModal> {
  bool loading = true;
  String fetchError;
  ChargingItem chargingItem;

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
    final localeName = TrufiLocalization.of(context).localeName;
    return Scrollbar(
      child: ListView(
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (loading)
                  LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  )
                else if (chargingItem != null) ...[
                  if (chargingItem.openingTimes["twentyfourseven"] == true) ...[
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
                          localeName == "en"
                              ? "Open 24/7"
                              : "Durchgängig geöffnet",
                          style: TextStyle(
                            color: theme.textTheme.bodyText1.color,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 10),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: chargingItem.connectors.values
                            .map(
                              (e) => Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: SvgPicture.string(
                                      chargingTypeIcons[e.standard] ?? "",
                                    ),
                                  ),
                                  Text(
                                    "${chargingTypeName[e.standard] ?? e.standard} - ${e.maxAmperage} kW",
                                    style: TextStyle(
                                      color: theme.textTheme.bodyText1.color,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      const Text("|"),
                      Text(
                        widget.element.available != null
                            ? localeName == "en"
                                ? "${widget.element.available} of ${widget.element.capacity} charging slots available"
                                : "${widget.element.available} von ${widget.element.capacity} Ladeplätzen frei"
                            : localeName == "en"
                                ? "${widget.element.capacity} charging slots"
                                : "${widget.element.capacity} Ladeplätzen",
                        style: TextStyle(
                          color: theme.textTheme.bodyText1.color,
                        ),
                      ),
                    ],
                  ),
                  if (chargingItem.openingTimes["twentyfourseven"] == true) ...[
                    const Divider(height: 10),
                    if (chargingItem.capabilities != null &&
                        chargingItem.capabilities.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on_outlined,
                            size: 15,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            chargingItem.capabilities
                                .toList()
                                .where((e) => capabilitiesNameEN[e] != null)
                                .map((e) => localeName == "en"
                                    ? capabilitiesNameEN[e]
                                    : capabilitiesNameDE[e] ?? "")
                                .toList()
                                .join(", "),
                            style: TextStyle(
                              color: theme.textTheme.bodyText1.color,
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
                          "${chargingItem.address}, ${chargingItem.postalCode}, ${chargingItem.city}",
                          style: TextStyle(
                            color: theme.textTheme.bodyText1.color,
                          ),
                        ),
                      ],
                    ),
                    if (chargingItem.evses != null &&
                        chargingItem.evses.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          launch(
                            "tel:${chargingItem.evses.first.phone}",
                          );
                        },
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
                              chargingItem.evses.first.phone,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (chargingItem.evses != null &&
                        chargingItem.evses.isNotEmpty &&
                        chargingItem.evses.first.relatedResource != null &&
                        chargingItem.evses.first.relatedResource.isNotEmpty &&
                        chargingItem.evses.first.relatedResource.first["url"] !=
                            null) ...[
                      const Divider(height: 10),
                      GestureDetector(
                        onTap: () {
                          launch(chargingItem
                              .evses.first.relatedResource.first["url"]
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
                  ],
                ] else
                  Text(
                    fetchError,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> loadData() async {
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
      "https://ochp.next-site.de/api/ocpi/2.2/location/${widget.element.id}",
    ));
    final body = jsonDecode(response.body);
    return ChargingItem.fromJson(body as Map);
  }
}
