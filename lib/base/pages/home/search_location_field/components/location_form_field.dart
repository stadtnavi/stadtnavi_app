import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/pages/home/search_location_field/components/location_search_delegate.dart';

import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/pages/saved_places/translations/saved_places_localizations.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class LocationFormField extends StatefulWidget {
  const LocationFormField({
    Key? key,
    required this.hintText,
    required this.textLeadingImage,
    required this.onSaved,
    required this.isOrigin,
    this.value,
    this.leading,
    this.trailing,
  }) : super(key: key);

  final bool isOrigin;
  final String hintText;
  final Widget textLeadingImage;
  final Function(TrufiLocation) onSaved;
  final TrufiLocation? value;
  final Widget? leading;
  final Widget? trailing;

  @override
  State<LocationFormField> createState() => _LocationFormFieldState();
}

class _LocationFormFieldState extends State<LocationFormField> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = TrufiBaseLocalization.of(context);
    final localizationSP = SavedPlacesLocalization.of(context);
    return Row(
      children: [
        if (widget.leading != null)
          SizedBox(
            width: 40.0,
            child: widget.leading,
          ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              // Show search
              final TrufiLocation? location = await showSearch<TrufiLocation?>(
                context: context,
                delegate: LocationSearchDelegate(
                  isOrigin: widget.isOrigin,
                  hint: widget.isOrigin
                      ? localization.searchHintOrigin
                      : localization.searchHintDestination,
                ),
              );
              // Check result
              if (location != null) {
                widget.onSaved(location);
                if (widget.value != location) {
                  _scrollController.jumpTo(0);
                }
              }
            },
            child: Container(
              height: 36,
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(height: 24.0, child: widget.textLeadingImage),
                  Flexible(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        child: widget.value != null
                            ? Text(
                                "${widget.value?.displayName(localizationSP)}${widget.value?.address?.isNotEmpty ?? false ? ", ${widget.value?.address}" : ""}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(
                                widget.hintText,
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if (widget.trailing != null)
          SizedBox(
            width: 40.0,
            child: widget.trailing,
          )
      ],
    );
  }
}
