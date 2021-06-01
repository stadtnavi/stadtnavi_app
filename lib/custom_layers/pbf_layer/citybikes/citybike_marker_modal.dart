import 'package:flutter/material.dart';

import 'package:stadtnavi_app/custom_layers/services/layers_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import 'citybike_data_fetch.dart';
import 'citybike_feature_model.dart';
import 'citybikes_enum.dart';

class CitybikeMarkerModal extends StatefulWidget {
  final CityBikeFeature element;
  const CitybikeMarkerModal({Key key, @required this.element})
      : super(key: key);

  @override
  _CitybikeMarkerModalState createState() => _CitybikeMarkerModalState();
}

class _CitybikeMarkerModalState extends State<CitybikeMarkerModal> {
  bool loading = true;
  String fetchError;
  CityBikeDataFetch cityBikeDataFetch;

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
    final languageCode = Localizations.localeOf(context).languageCode;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  child: widget.element.type.image,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cityBikeDataFetch.name ?? "",
                        style: const TextStyle(fontSize: 20),
                      ),
                      if (widget.element.type != null)
                        Text(
                          widget.element.type.getTranslate(languageCode),
                          style: TextStyle(
                            color:
                                theme.textTheme.bodyText1.color.withOpacity(.5),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          if (cityBikeDataFetch.bikesAvailable > -1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(
                languageCode == 'en'
                    ? "Bikes available at the station right now (${cityBikeDataFetch.bikesAvailable})"
                    : "Leihräder verfübar (${cityBikeDataFetch.bikesAvailable})",
                style: TextStyle(
                  color: theme.textTheme.bodyText1.color,
                ),
              ),
            ),
          if (cityBikeDataFetch.firstNetwork != null &&
              cityBikeDataFetch.firstNetwork.hasBook(languageCode))
            Card(
              color: Colors.grey[100],
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityBikeDataFetch.firstNetwork
                          .getNetworkBookData(languageCode)
                          .title,
                      style: theme.textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: theme.textTheme.bodyText1.fontSize + 1),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        launch(cityBikeDataFetch.firstNetwork
                            .getNetworkBookData(languageCode)
                            .url);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cityBikeDataFetch.firstNetwork
                                .getNetworkBookData(languageCode)
                                .bookText,
                            style: theme.textTheme.bodyText2
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            cityBikeDataFetch.firstNetwork
                                .getNetworkBookData(languageCode)
                                .icon,
                            size: 20,
                            color: const Color(0xff007ac9),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ] else
          Text(
            fetchError,
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
