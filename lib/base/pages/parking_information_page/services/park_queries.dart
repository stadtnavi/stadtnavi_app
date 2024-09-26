const String parkingByIds = r'''
 query parkings(
   $parkIds: [String]!
 ){
  vehicleParkings(ids: $parkIds) {
    vehicleParkingId
    name
    availability {
      carSpaces
      wheelchairAccessibleCarSpaces
    }
  }
}
''';