# Stadtnavi web deep links

The app accepts HTTPS links for its configured web origin. For the Herrenberg
instance this is `https://herrenberg.stadtnavi.de/`. Android App Links and iOS
Universal Links are configured only for that host; unsupported paths safely
open the normal app home screen.

## Supported mapping

| Web URL | Encoded information | Native destination |
| --- | --- | --- |
| `/-/{label::lat,lon}` and `/{label::lat,lon}/-` | Named coordinate | Map location panel |
| `/reiseplan/{from}/{to}` | Two named coordinates | Journey planning and results |
| `/pois/{category}?lat=…&lng=…&name=…&osmId=…` | POI identity, name, and coordinate | Map location panel |
| `/haltestellen/{gtfsId}` | OTP stop ID | Stop departures/timetable/disruptions panel |
| `/station/{id}` | OTP vehicle-rental station ID | Shared-mobility station panel (bike, cargo bike, scooter, carsharing, etc.) |
| `/parkplaetze/{id}` | OTP vehicle-parking ID | Parking panel |
| `/fahrradparkplaetze/{id}` | OTP vehicle-parking ID | Bicycle-parking panel |
| `/geojson`, `/baustellen`, `/ladestationen`, `/strassenwetter`, and coordinate-form `/fahrradparkplaetze` URLs | Named coordinate in query parameters | Map location panel |

The same routes with a leading `/de` or `/en` are supported. Stop timetable
and disruption subpaths select the equivalent native tab. Extra web journey
detail hashes and planning query parameters are intentionally reduced to a new
native plan between the encoded endpoints.

The location selector shown by POIs, carsharing, shared mobility, parking,
charging, and other map markers shares the canonical web form
`/-/{label::lat,lon}`. It therefore remains a working web link when the app is
not installed.

## Intentionally unsupported

- `/routen/{id}` and route pattern/trip URLs: the Flutter app has no standalone
  route-ID lookup/page equivalent.
- `/busbahnhoefe/{id}`: the web uses an OTP station query, while the Flutter app
  currently exposes stop—not terminal/station—detail models.
- `/reiseplan/POS/…` links: `POS` requires an interactive location-permission
  flow and cannot be deterministically restored from the URL alone.
- Nearby/favourites, disruptions lists, and web-only informational pages: no
  equivalent native destination exists.
- POI URLs without `osmId` or coordinates and map-entity URLs without valid
  coordinates: there is not enough information to identify a native location.

Unknown IDs and failed entity lookups are ignored (or use URL coordinates when
available) without crashing.
