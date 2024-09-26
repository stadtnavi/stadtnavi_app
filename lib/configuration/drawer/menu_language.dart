import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trufi_core/base/blocs/localization/trufi_localization_cubit.dart';
import 'package:trufi_core/base/widgets/drawer/menu/default_item_menu.dart';
import 'package:trufi_core/base/widgets/drawer/menu/menu_item.dart';

TrufiMenuItem menuLanguage() {
  return SimpleMenuItem(
      buildIcon: (context) => const Icon(Icons.translate),
      name: (context) {
        final List<Locale> values = context
            .findAncestorWidgetOfExactType<MaterialApp>()!
            .supportedLocales
            .toList();
        final currentLocale = Localizations.localeOf(context);
        return DropdownButton<Locale>(
          value: values.firstWhere(
            (value) => value == currentLocale,
          ),
          onChanged: (Locale? value) {
            context.read<TrufiLocalizationCubit>().changeLocale(
                  currentLocale: value,
                );
          },
          items: values.map((Locale value) {
            return DropdownMenuItem<Locale>(
              value: value,
              child: Text(
                TrufiLocalizationCubit.localeDisplayName(value),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            );
          }).toList(),
        );
      });
}
