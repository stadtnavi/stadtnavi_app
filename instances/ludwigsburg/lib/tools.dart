import 'package:stadtnavi_core/base/custom_layers/pbf_layer/parking/parking_feature_model.dart';

AvailabilityParking? calculateParkingAvailavilityLB({
  String? state,
  int? availabilityCarPlacesCapacity,
  int? carPlacesCapacity,
  int? freeDisabled,
  int? totalDisabled,
}) {
  if (state == 'closed' ||
      availabilityCarPlacesCapacity == 0 ||
      (freeDisabled == 0 && false)) {
    return AvailabilityParking.unavailability;
  } else {
    AvailabilityParking? isAvailible;
    if (carPlacesCapacity != null && availabilityCarPlacesCapacity != null) {
      isAvailible = _selectAvailavility(
        carPlacesCapacity,
        availabilityCarPlacesCapacity,
      );
    } else if (totalDisabled != null && freeDisabled != null) {
      isAvailible = freeDisabled > 0
          ? AvailabilityParking.availability
          : AvailabilityParking.unavailability;
    }
    return isAvailible;
  }
}

AvailabilityParking _selectAvailavility(int capacity, int availabilityCapacity) {
  final percentage = (availabilityCapacity / capacity) * 100;
  if (percentage > 15) {
    return AvailabilityParking.availability;
  } else {
    return AvailabilityParking.partial;
  }
}
