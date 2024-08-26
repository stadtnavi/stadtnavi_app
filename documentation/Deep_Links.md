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

## Android `geo:` intents

The Herrenberg Android app is also registered as an `ACTION_VIEW` handler for
the standard `geo:` scheme. These intents enter through the same Router and
`StadtnaviDeepLink` destination flow as the HTTPS links above.

| Format | Example | Native behavior |
| --- | --- | --- |
| Direct coordinate | `geo:48.7758,9.1829` | Opens the map location panel |
| Coordinate with zoom | `geo:48.7758,9.1829?z=15` | Opens the location; zoom hints are ignored |
| Coordinate query | `geo:0,0?q=48.7758,9.1829` | Opens the queried coordinate |
| Labeled coordinate query | `geo:0,0?q=48.7758,9.1829(Stuttgart)` | Opens the coordinate using the supplied label |
| Address query | `geo:0,0?q=Breitscheidstra%C3%9Fe%2048%2C%2070176%20Stuttgart` | Resolves the address with the existing stadtnavi search and opens its highest-ranked valid result |

Empty queries, malformed or out-of-range coordinates, `geo:0,0` without a
query, duplicate `q` parameters, coordinate altitude/uncertainty components,
and non-`geo` schemes are not handled. Other query hints, including `z`, do not
change the native map zoom. If an address cannot be resolved, the app remains
on Home and shows the existing no-results or connection-error message.






test:

adb shell am start -W \
  -a android.intent.action.VIEW \
  -c android.intent.category.BROWSABLE \
  -d "https://herrenberg.stadtnavi.de/station/HBG%3AStation%3Aherrenberg_stadtrad_1" \
  de.stadtnavi.herrenberg.internal

  adb shell am start -W \
  -a android.intent.action.VIEW \
  -c android.intent.category.BROWSABLE \
  -d "https://herrenberg.stadtnavi.de/station/HBG%3AStation%3Aherrenberg_stadtrad_1" \
  de.stadtnavi.herrenberg.internal

xcrun simctl openurl booted \
"https://herrenberg.stadtnavi.de/haltestellen/hbg%3Ade%3A08111%3A6112%3A7%3A9"