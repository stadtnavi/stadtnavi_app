import 'package:trufi_core/base/models/trufi_place.dart' as trufi;

import 'stadtnavi_location.dart';

/// Converts between StadtnaviLocation and trufi_core's TrufiLocation
/// at the boundary points where the OTP module connects with the rest of the app.
extension TrufiLocationToStadtnavi on trufi.TrufiLocation {
  StadtnaviLocation toStadtnaviLocation() => StadtnaviLocation(
        description: description,
        latitude: latitude,
        longitude: longitude,
        alternativeNames: alternativeNames,
        localizedNames: localizedNames,
        address: address,
        type: type,
      );
}

extension StadtnaviLocationToTrufi on StadtnaviLocation {
  trufi.TrufiLocation toTrufiLocation() => trufi.TrufiLocation(
        description: description,
        latitude: latitude,
        longitude: longitude,
        alternativeNames: alternativeNames,
        localizedNames: localizedNames,
        address: address,
        type: type,
      );
}
