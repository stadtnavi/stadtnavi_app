import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stadtnavi_core/base/pages/home/search_location_field/components/suggestion.dart';

import 'package:trufi_core/base/blocs/theme/theme_cubit.dart';
import 'package:trufi_core/base/models/trufi_place.dart';
import 'package:trufi_core/base/widgets/location_search_delegate/build_street_results.dart';

class LocationSearchDelegate extends SearchDelegate<TrufiLocation?> {
  final bool isOrigin;
  final String hint;
  LocationSearchDelegate({
    required this.isOrigin,
    required this.hint,
  }) : super(
          searchFieldLabel: hint,
        );

  dynamic _result;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = context.watch<ThemeCubit>().themeData(context);
    return theme.copyWith(
      scaffoldBackgroundColor:
          ThemeCubit.isDarkMode(theme) ? Colors.grey[900] : null,
      textSelectionTheme: theme.textSelectionTheme.copyWith(
        cursorColor: Colors.black87,
        selectionColor: Colors.grey[300],
      ),
      hintColor: Colors.black54,
      textTheme: theme.textTheme.copyWith(
        headlineSmall: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    final theme = context.watch<ThemeCubit>().themeData(context);
    return BackButton(
      onPressed: () {
        if (_result != null) {
          _result = null;
          showSuggestions(context);
        } else {
          close(context, null);
        }
      },
      color: theme.appBarTheme.foregroundColor,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SuggestionList(
      query: query,
      isOrigin: isOrigin,
      onSelected: (TrufiLocation suggestion) {
        _result = suggestion;
        close(context, suggestion);
      },
      onSelectedMap: (TrufiLocation location) {
        _result = location;
        showResults(context);
      },
      onStreetTapped: (TrufiStreet street) {
        _result = street;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (_result != null) {
      if (_result is TrufiStreet) {
        return BuildStreetResults(
          street: _result as TrufiStreet,
          onTap: (location) {
            close(context, location);
          },
        );
      } else {
        Future.delayed(Duration.zero, () {
          close(context, _result as TrufiLocation);
        });
      }
    }
    return buildSuggestions(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _result = null;
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }
}
