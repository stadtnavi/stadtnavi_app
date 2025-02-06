import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/widgets/location_search_delegate/build_street_results.dart';

import 'package:stadtnavi_core/base/pages/home/search_location_field/components/suggestion.dart';

class CustomLocationSearchPage extends StatefulWidget {
  final bool isOrigin;
  final String hint;
  final String? defaultSearch;

  const CustomLocationSearchPage({
    Key? key,
    required this.isOrigin,
    required this.hint,
    this.defaultSearch,
  }) : super(key: key);

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

  void _onStreetTapped(TrufiStreet street) {
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
      onStreetTapped: (TrufiStreet street) => _onStreetTapped(street),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeCubit>().themeData(context);

    if (_result != null && _result is TrufiStreet) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              setState(() => _result = null);
            },
          ),
          title: Text(widget.hint),
        ),
        body: BuildStreetResults(
          street: _result as TrufiStreet,
          onTap: (location) {
            Navigator.of(context).pop(location);
          },
        ),
      );
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
            )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
