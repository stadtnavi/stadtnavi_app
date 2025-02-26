import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_data_fetch.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybike_feature_model.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/citybikes/citybikes_enum.dart';
import 'package:stadtnavi_core/base/custom_layers/services/layers_repository.dart';

class CityBikeFeatureTile extends StatefulWidget {
  final CityBikeFeature element;
  const CityBikeFeatureTile({
    super.key,
    required this.element,
  });

  @override
  State<CityBikeFeatureTile> createState() => _CityBikeFeatureTileState();
}

class _CityBikeFeatureTileState extends State<CityBikeFeatureTile> {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    return Column(
      children: [
        if (loading)
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        else if (cityBikeDataFetch != null) ...[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      if (widget.element.type != null)
                        Text(
                          widget.element.type?.getTranslate(languageCode) ?? '',
                          style: TextStyle(
                            color: theme.textTheme. bodyLarge?.color
                                ?.withOpacity(.5),
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
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
