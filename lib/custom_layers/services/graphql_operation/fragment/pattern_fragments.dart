import 'package:graphql/client.dart';

// Query generate TimeTable
final timetableContainerStop = gql(
  r'''
fragment RouteStopListContainer_pattern_1WWfn2 on Pattern {
  directionId
  route {
    mode
    color
    shortName
    id
  }
  stops {
    alerts {
      alertSeverityLevel
      effectiveEndDate
      effectiveStartDate
      id
    }
    stopTimesForPattern(id: $patternId, startTime: $currentTime) {
      realtime
      realtimeState
      realtimeArrival
      realtimeDeparture
      serviceDay
      scheduledDeparture
      pickupType
      stop {
        platformCode
        id
      }
    }
    gtfsId
    lat
    lon
    name
    desc
    code
    platformCode
    zoneId
    id
  }
}
  ''',
);
