# Migracion stadtnavi_app a trufi_core_maps (MapLibre) - Herrenberg

Plan de migracion del motor de mapa de `flutter_map` a `trufi_core_maps` (MapLibre nativo).
Enfocado en la instancia **Herrenberg**.

**Estado: COMPLETADO** - App corriendo con MapLibre en emulador Android.

---

## Fase 0 - Preparacion

- [x] Configurar dependencia `trufi_core_maps` en `pubspec.yaml` de stadtnavi_app (path local)
- [x] Configurar dependencias transitivas (`trufi_core_interfaces`, `trufi_core_utils`)
- [x] Resolver conflictos de versiones (`vector_tile` v2 vs v3, `maplibre_gl`, `intl`, `protobuf`, etc.)
- [x] Verificar que compila sin errores tras agregar la dependencia
- [x] Subir Flutter a 3.41.0 (Dart 3.11) via FVM
- [x] Actualizar Kotlin a 2.1.0, AGP a 8.9.1, Gradle a 8.11.1

---

## Fase 1 - Reemplazar mapa base (StadtnaviMap)

### 1.1 Widget principal del mapa
- [x] Reemplazar `FlutterMap` por `TrufiMap` en `stadtnavi_map.dart`
- [x] Adaptar callbacks (`onTap`, `onLongPress`, `onPositionChanged`)
- [x] Migrar `TrufiMapController` cubit (wrapper de `maps.TrufiMapController`)
- [x] Migrar `TrufiMapState` (listas de `TrufiMarker`/`TrufiLine` en vez de widgets)

### 1.2 Base map tiles -> MapLibre styles

Tile server Herrenberg: `https://tiles-eu.stadtnavi.eu/`

- [x] `streets` - `https://tiles-eu.stadtnavi.eu/styles/streets/style.json`
- [x] `satellite-overlay` - `https://tiles-eu.stadtnavi.eu/styles/satellite-overlay/style.json`
- [x] `bicycle` (CycloBright) - `https://tiles-eu.stadtnavi.eu/styles/bicycle/style.json`
- [x] Crear `_MapStyleButton` para selector de estilos
- [x] Eliminar dependencia de `MapTileProviderCubit` para tiles base

### 1.3 Controles y botones del mapa
- [x] `_MapStyleButton` - selector de tipo de mapa (reemplaza `MapTypeButton`)
- [x] `YourLocationButton` - boton de ubicacion actual
- [x] `MapLegend` - leyenda del mapa
- [x] Atribucion del mapa (inline)

---

## Fase 2 - Migrar sistema de custom layers

- [x] `CustomLayer` base class - nuevos metodos `buildTrufiMarkers(zoom)` y `buildTrufiLines(zoom)`
- [x] `CustomLayersCubit` - nuevo metodo `buildTrufiLayers(zoom)` que genera `TrufiLayer`s
- [x] `PanelCubit` - migrado de `Marker` (flutter_map) a `TrufiMarker`
- [x] Tap handling via `pickMarkersAt` + `buildPanel` callback en `StadtnaviMap`

---

## Fase 3 - Migrar capas PBF (10 capas)

- [x] `StopsLayer` - migrado a `TrufiMarker` + `buildTrufiMarkers`
- [x] `ParkingLayer` - migrado
- [x] `BikeParkLayer` - migrado (parcialmente por agentes, corregido manualmente)
- [x] `CityBikesLayer` - migrado (parcialmente por agentes, corregido manualmente)
- [x] `CarSharingLayer` - migrado (parcialmente por agentes, corregido manualmente)
- [x] `ScooterLayer` - migrado a `TrufiMarker`
- [x] `MapPoiLayer` - migrado (parcialmente por agentes, corregido manualmente)
- [x] `ChargingLayer` - migrado a `TrufiMarker`
- [x] `WeatherLayer` - migrado a `TrufiMarker`
- [x] `RoadworksLayer` - migrado (parcialmente por agentes)

### PBF Tile Fetching
- [x] `CancellableNetworkTileProvider` -> `PbfTileFetcher` (standalone service)
- [x] Integrado en `StadtnaviMap.onCameraChanged`

---

## Fase 4 - Migrar capas especiales

- [x] `GeojsonLayer` - migrado
- [x] `ParkingZonesLayer` - migrado
- [x] `LiveBusLayer` - mantiene MQTT, usa TrufiMarker
- [x] `UndefinedMapLayer` (hb_layers_data) - migrado

---

## Fase 5 - Migrar pantallas dependientes

- [x] `trufi_map_route.dart` - Mapa de ruta (usa StadtnaviMap + TrufiLayer)
- [x] `trufi_map_mode.dart` - Modo de transporte (usa StadtnaviMap + TrufiLayer)
- [x] `home_page.dart` - Removido `tickerProvider`, actualizado camera access
- [x] `bottom_sheet_itineraries.dart` - Removido `tickerProvider`
- [x] `custom_itinerary.dart` - Removido `tickerProvider`
- [x] `parking_overview_map.dart` - Actualizado callbacks
- [x] `route_stops_screen.dart` - Migrado a TrufiLayer/TrufiMarker/TrufiLine
- [x] `trufi_map_utils.dart` - `PolylineWithMarkers` usa TrufiLine/TrufiMarker
- [x] `trufi_map_animations.dart` - Simplificado (MapLibre anima nativamente)
- [x] `marker_configuration.dart` - Nuevos metodos `buildFromTrufiMarker`/`buildToTrufiMarker`
- [x] `custom_marker_configuration.dart` - Implementa ambas interfaces

---

## Fase 6 - Build y pruebas

- [x] 0 errores de analisis (`fvm dart analyze lib/`)
- [x] Build exitoso para Android
- [x] App corriendo en emulador con mapa MapLibre vectorial
- [x] Tiles cargando desde `tiles-eu.stadtnavi.eu`
- [ ] Probar tap en marcadores POI (requiere zoom > 13 para cargar PBF)
- [ ] Probar busqueda de rutas
- [ ] Probar cambio de estilos de mapa
- [ ] Probar en dispositivo fisico

---

## Notas

- **baseDomain**: `api.dev.stadtnavi.eu` (dev) / `api.stadtnavi.de` (prod)
- **tileServer Herrenberg**: `https://tiles-eu.stadtnavi.eu/`
- **Estilos disponibles**: streets, satellite-overlay, bicycle (CycloBright)
- **Vector data**: `https://tiles-eu.stadtnavi.eu/data/v3.json` (155 layers PBF, formato Mapbox GL v8)
- **Flutter version**: 3.41.0 (Dart 3.11) via FVM
- **dependency_overrides**: `intl: ^0.20.2`, `package_info_plus: ^9.0.0`, `protobuf: ^5.1.0`
- `flutter_map` se mantiene como dependencia transitiva via `trufi_core` (viejo) - se puede eliminar cuando se migre completamente a los paquetes modulares
