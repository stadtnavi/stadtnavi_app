import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/local_json_layer/geojson_marker_model.dart';
import 'package:stadtnavi_core/base/pages/home/widgets/trufi_map_route/custom_location_selector.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class GeojsonMarkerModal extends StatelessWidget {
  final GeojsonMarker element;
  final Widget icon;
  final void Function() onFetchPlan;

  const GeojsonMarkerModal({
    Key? key,
    required this.element,
    required this.icon,
    required this.onFetchPlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = element.name?.trim() ?? "";
    final details = [
      if (_isNotEmpty(element.address))
        _buildInfoRow(Icons.place, element.address!),
      if (_isNotEmpty(element.website))
        _buildLinkRow(Icons.language, element.website!),
      if (_isNotEmpty(element.phone))
        _buildInfoRow(Icons.phone, element.phone!),
      if (_isNotEmpty(element.email))
        _buildInfoRow(Icons.email, element.email!),
      if (_isNotEmpty(element.openingHoursLink))
        _buildLinkRow(Icons.schedule, element.openingHoursLink!),
    ];
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
                child: icon,
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        if (_isNotEmpty(element.imageUrl))
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 250,
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    element.imageUrl!,
                  ),
                ),
                const Divider(
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        if (details.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...details,
                const Divider(
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        if (_isNotEmpty(element.openingHours))
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfoRow(
                    Icons.access_time,
                    element.openingHours == "off"
                        ? element.openingHoursText ?? element.openingHours!
                        : element.openingHours!),
                const Divider(
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        if (_isNotEmpty(element.popupContent))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Html(
                  data: element.popupContent!,
                  style: {
                    ".text-light": Style(
                      color: const Color(0xFF666666),
                      margin: Margins.only(top: 5, bottom: 5),
                      fontSize: FontSize(13)
                    ),
                  },
                ),
              ],
            ),
          ),
        CustomLocationSelector(
          onFetchPlan: onFetchPlan,
          locationData: LocationDetail(
            title,
            "",
            element.position,
          ),
        ),
      ],
    );
  }

  bool _isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Color(0xFF747474),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF747474),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow(IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: () async {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Color(0xFF747474),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                url,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff9BBF28),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
