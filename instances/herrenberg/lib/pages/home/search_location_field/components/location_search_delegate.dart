import 'package:de_stadtnavi_herrenberg_internal/pages/home/search_location_field/components/suggestion.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/screens/route_navigation/maps/trufi_map_controller.dart';

class CustomLocationSearchPage extends StatefulWidget {
  final bool isOrigin;
  final String hint;
  final String? defaultSearch;

  const CustomLocationSearchPage({
    super.key,
    required this.isOrigin,
    required this.hint,
    this.defaultSearch,
  });

  @override
  State<CustomLocationSearchPage> createState() =>
      _CustomLocationSearchPageState();
}

class _CustomLocationSearchPageState extends State<CustomLocationSearchPage> {
  late TextEditingController _controller;
  dynamic _result;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultSearch ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSuggestionTap(TrufiLocation suggestion) {
    Navigator.of(context).pop(suggestion);
  }

  void _onStreetTapped(TrufiLocation street) {
    setState(() {
      _result = street;
    });
  }

  Widget _buildSuggestions() {
    return SuggestionList(
      query: _controller.text,
      isOrigin: widget.isOrigin,
      onSelected: (TrufiLocation suggestion) => _onSuggestionTap(suggestion),
      onSelectedMap: (TrufiLocation location) => _onSuggestionTap(location),
      onStreetTapped: (TrufiLocation street) => _onStreetTapped(street),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_result != null && _result is TrufiLocation) {
      // return Scaffold(
      //   appBar: AppBar(
      //     leading: BackButton(
      //       onPressed: () {
      //         setState(() => _result = null);
      //       },
      //     ),
      //     title: Text(widget.hint),
      //   ),
      //   body: BuildStreetResults(
      //     street: _result as TrufiLocation,
      //     onTap: (location) {
      //       Navigator.of(context).pop(location);
      //     },
      //   ),
      // );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: theme.appBarTheme.foregroundColor,
          onPressed: () => Navigator.of(context).pop(null),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.hint,
            border: InputBorder.none,
          ),
          onChanged: (_) {
            setState(() {});
          },
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  _result = null;
                  _controller.clear();
                });
              },
              icon: const Icon(Icons.clear),
            ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
