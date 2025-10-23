import 'package:flutter/material.dart';

class CustomSwitchTile extends StatelessWidget {
  const CustomSwitchTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.isSubSection = false,
    this.secondary,
    this.titleColor,
  }) : super(key: key);
  final String title;
  final Widget? secondary;
  final bool value;
  final Function(bool) onChanged;
  final bool isSubSection;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SwitchListTile.adaptive(
      visualDensity: const VisualDensity(vertical: -2),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: titleColor,
          fontWeight: isSubSection ? null : FontWeight.bold,
        ),
      ),
      secondary: secondary,
      activeColor: theme.colorScheme.primary,
      value: value,
      onChanged: onChanged,
    );
  }
}
