import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stadtnavi_core/base/custom_layers/models/icons.dart';

enum AvailabilityState {
  availability,
  partial,
  unavailability,
}

extension AvailabilityParkingExtension on AvailabilityState {
  static Widget? _images(AvailabilityState transportMode) {
    switch (transportMode) {
      case AvailabilityState.availability:
        return SvgPicture.string(availabilityIcon);
      case AvailabilityState.partial:
        return SvgPicture.string(partialAvailabilityIcon);
      case AvailabilityState.unavailability:
        return SvgPicture.string(unavailabilityIcon);
      }
  }

  Widget getImage({double size = 24}) {
    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        child: _images(this) ?? Container(),
      ),
    );
  }
}
