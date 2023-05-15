import 'package:stadtnavi_core/base/custom_layers/models/enums.dart';

AvailabilityState? calculateParkingAvailavilityLB({
  String? state,
  int? availabilityCarPlacesCapacity,
  int? carPlacesCapacity,
  int? freeDisabled,
  int? totalDisabled,
}) {
  if (state == 'closed' ||
      availabilityCarPlacesCapacity == 0 ||
      (freeDisabled == 0 && false)) {
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
