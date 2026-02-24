import 'package:intl/intl.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

/// Duration and distance formatting utilities.
/// Copied from trufi_core to decouple the OTP module.
/// Accepts TrufiBaseLocalization for locale-aware formatting.

String durationFormatString(
  TrufiBaseLocalization localization,
  Duration duration,
) {
  final hours = duration.inHours + duration.inDays * 24;
  final minutes = duration.inMinutes.remainder(60);

  if (hours >= 1) {
    return '${hours}h ${minutes}min';
  }

  if (duration.inMinutes < 1) {
    return '< 1 min';
  }

  return '$minutes min';
}

String durationToHHmm(DateTime duration) =>
    DateFormat('HH:mm').format(duration);

