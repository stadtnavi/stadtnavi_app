import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:trufi_core/l10n/trufi_localization.dart';
import 'charging_feature_model.dart';
import 'charging_icons.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Text(
                localeName == "en"
                    ? "${widget.element.ca} of ${widget.element.c} charging slots available"
                    : "${widget.element.ca} von ${widget.element.c} Ladeplätzen frei",
                style: TextStyle(
                  color: theme.textTheme.bodyText1.color,
                ),
              ),
              const Divider(),
              if (loading)
                LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                )
              else if (chargingItem != null)
                ...chargingItem.evses.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.id,
                          style: TextStyle(
                            color: theme.textTheme.bodyText1.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Status: ${item.status}",
                          style: TextStyle(
                            color: theme.textTheme.bodyText1.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Text(
                  fetchError,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        )
      ],
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

class ChargingItem {
  String uid;
  String name;
  String address;
  String postalCode;
  String lastUpdated;
  List<ChargingDetail> evses;
  ChargingItem({
    @required this.uid,
    @required this.name,
    @required this.address,
  });

  ChargingItem.fromJson(Map map)
      : uid = map["uid"]?.toString(),
        name = map["name"]?.toString(),
        address = map["address"]?.toString(),
        postalCode = map["postal_code"]?.toString(),
        lastUpdated = map["last_updated"]?.toString(),
        evses = (map["evses"] as List)
            .map((item) => ChargingDetail.fromJson(item as Map))
            .toList();
}

class ChargingDetail {
  String id;
  String status;
  String phone;
  List<String> capabilities;
  List<String> parkingRestrictions;
  Map openingTimes;
  List<String> connectors;
  ChargingDetail({
    @required this.id,
    @required this.status,
    @required this.phone,
    @required this.capabilities,
    @required this.parkingRestrictions,
    @required this.openingTimes,
    @required this.connectors,
  });

  ChargingDetail.fromJson(Map map)
      : id = map["evse_id"]?.toString(),
        status = map["status"]?.toString(),
        phone = map["phone"]?.toString(),
        capabilities = (map["capabilities"] as List)
            .map<String>((element) => "$element")
            .toList(),
        parkingRestrictions = (map["parking_restrictions"] as List)
            .map<String>((element) => "$element")
            .toList(),
        openingTimes = map["opening_times"] as Map,
        connectors = (map["connectors"] as List)
            .map<String>((element) => "$element")
            .toList();
}
