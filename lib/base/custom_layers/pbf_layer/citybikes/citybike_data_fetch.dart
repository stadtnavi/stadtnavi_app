import 'package:stadtnavi_core/base/custom_layers/services/models_otp/bike_rental_station.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/bike_rental_station_uris.dart';

import 'citybikes_enum.dart';

class CityBikeDataFetch {
  final String? id;
  final String? stationId;
  final String? name;
  final int? bikesAvailable;
  final int? spacesAvailable;
  final String? state;
  final List<CityBikeLayerIds>? networks;
  final BikeRentalStationUris? rentalUris;
  final double? lon;
  final double? lat;
  final int? capacity;

  const CityBikeDataFetch({
    this.id,
    this.stationId,
    this.name,
    this.bikesAvailable,
    this.spacesAvailable,
    this.state,
    this.networks,
    this.rentalUris,
    this.lon,
    this.lat,
    this.capacity,
  });

  factory CityBikeDataFetch.fromBikeRentalStation(
    BikeRentalStation? bikeRentalStation,
  ) {
    return CityBikeDataFetch(
      id: bikeRentalStation?.id,
      stationId: bikeRentalStation?.stationId,
      name: bikeRentalStation?.name,
      bikesAvailable: bikeRentalStation?.bikesAvailable,
      spacesAvailable: bikeRentalStation?.spacesAvailable,
      state: bikeRentalStation?.state,
      networks: bikeRentalStation?.networks
          ?.map((e) => cityBikeLayerIdStringToEnum(e))
          .toList(),
      rentalUris: bikeRentalStation?.rentalUris,
      lon: bikeRentalStation?.lon,
      lat: bikeRentalStation?.lat,
      capacity: bikeRentalStation?.capacity,
    );
  }

  CityBikeLayerIds? get firstNetwork =>
      (networks?.isNotEmpty ?? false) ? networks![0] : null;

  String? getUrl(String languageCode) {
    return rentalUris?.web ??
        firstNetwork?.getNetworkBookData(languageCode).url;
  }
}
