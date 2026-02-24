# Layers Not Rendered (post trufi_core_maps migration)

These custom layers exist in the codebase but are **not rendered** on the MapLibre map because they produce `flutter_map` widgets (`MarkerLayer`, `PolylineLayer`, `PolygonLayer`) which are incompatible with the new MapLibre GL renderer. They need to be migrated to use `trufi_core_maps` `TrufiLayer`/`TrufiMarker`/`TrufiLine` entities.

## PBF Point Layers

| Layer | Class | ID/Code | Data Source | Renders |
|-------|-------|---------|-------------|---------|
| Transit Stops | `StopsLayer` | rail, subway, bus, funicular | OTP vectorTiles/stops PBF | Station/stop markers |
| City Bikes | `CityBikesLayer` | (from config) | OTP vectorTiles/citybikes PBF | Bike sharing stations + availability |
| Parking | `ParkingLayer` | parkAndRide | OTP vectorTiles/parking PBF | Parking facilities + availability |
| POIs | `MapPoiLayer` | (from config) | `features.stadtnavi.eu/public.pois` PBF | Restaurants, shops, facilities |
| Bike Parks | `BikeParkLayer` | parkAndRideForBikes | OTP vectorTiles/parking PBF | Bicycle parking |
| Car Sharing | `CarSharingLayer` | car, cargo_bicycle, bicycle | OTP vectorTiles/realtimeRentalStations PBF | Car/cargo bike sharing |
| Scooters | `ScooterLayer` | scooter | OTP vectorTiles/rentalVehicles PBF | Scooter rental stations |
| Weather | `WeatherLayer` | weatherStations | `/map/v1/weather-stations` PBF | Weather stations |
| Charging | `ChargingLayer` | chargingStations | `services.stadtnavi.eu/tiles/charging-stations` MVT | EV charging stations |

## Non-PBF Layers

| Layer | Class | ID/Code | Data Source | Renders |
|-------|-------|---------|-------------|---------|
| Roadworks | `RoadworksLayer` | roadworks | MobiData-BW GeoServer TMS PBF | Polylines + start/end markers |
| Live Buses | `LiveBusLayer` | vehicles | MQTT WebSocket (`vehiclepositions.stadtnavi.eu`) | Real-time bus positions |
| Parking Zones | `ParkingZonesLayer` | parking_zones | GeoJSON from `stadtnavi.swlb.de` | Zone polygons + info markers |
| GeoJSON | `GeojsonLayer` | (from config) | Configurable URL | Points + MultiLineString polylines |

## Also Not Rendered

- **Route polylines** — `TrufiMapController` itinerary visualization (selected/unselected polylines + transfer markers)
- **From/To markers** — Origin/destination markers on the map
- **Selected marker overlay** — `PanelCubit` selected marker highlight
- **Current location marker** — GPS location marker layer
- **Marker clustering** — `flutter_map_marker_cluster` cluster widget
- **Map tile layer switching** — Streets/Satellite/Bike/Terrain raster tile options (replaced by single MapLibre vector style)
- **WMS cycle network overlay** — MobiData-BW WMS layer

## Herrenberg Instance Categories

The Herrenberg instance organizes layers into these categories (from remote JSON):

1. **Transit** (train icon) — Stops layers (rail, subway, bus, funicular)
2. **Bike & Car** (bike icon) — Bike parks, parking
3. **Sharing Services** (bike/scooter icon) — City bikes, car sharing, scooters
4. **Leisure & Tourism** — POI layers
5. **Shopping & Services** — POI layers
6. **Public Facilities** — POI layers
7. **Health & Social Services** — POI layers

## Migration Path

Each layer needs to be converted from producing `flutter_map` widgets to using:
- `TrufiMarker` (from `trufi_core_maps`) for point markers
- `TrufiLine` (from `trufi_core_maps`) for polylines
- `TrufiLayer` (from `trufi_core_maps`) as the layer container

The `CustomLayersCubit` methods `activeCustomLayers()`, `markers()`, `buildMarkerLayer()`, `buildAreaLayer()`, `buildOverlapLayer()`, and `buildClusterMarkers()` all return `flutter_map` widgets and need adaptation.
