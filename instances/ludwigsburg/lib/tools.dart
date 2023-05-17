import 'package:stadtnavi_core/base/custom_layers/models/enums.dart';
import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/simple_opening_hours.dart';

AvailabilityState? calculateParkingAvailavilityLB({
  String? state,
  int? availabilityCarPlacesCapacity,
  int? carPlacesCapacity,
  int? freeDisabled,
  int? totalDisabled,
  SimpleOpeningHours? sOpeningHours,
}) {
  if (state == 'closed' ||
      availabilityCarPlacesCapacity == 0 ||
      (freeDisabled == 0 && false) ||
      !(sOpeningHours?.isOpenNow() ?? true)) {
    return AvailabilityState.unavailability;
  } else {
    AvailabilityState? isAvailible;
    if (carPlacesCapacity != null && availabilityCarPlacesCapacity != null) {
      isAvailible = _selectAvailavility(
        carPlacesCapacity,
        availabilityCarPlacesCapacity,
      );
    } else if (totalDisabled != null && freeDisabled != null) {
      isAvailible = freeDisabled > 0
          ? AvailabilityState.availability
          : AvailabilityState.unavailability;
    }
    return isAvailible;
  }
}

AvailabilityState _selectAvailavility(int capacity, int availabilityCapacity) {
  final percentage = (availabilityCapacity / capacity) * 100;
  if (percentage > 15) {
    return AvailabilityState.availability;
  } else {
    return AvailabilityState.partial;
  }
}
