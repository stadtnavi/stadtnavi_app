const String stopDataQuery = r'''
  query stopRoutes_StopPageHeaderContainer_Query($stopId: String!, $startTime: Long!, $timeRange: Int!, $numberOfDepartures: Int!) {
        stop(id: $stopId) {
          ...StopCardHeaderContainer_stop
          ...StopPageTabContainer_stop
          stoptimesWithoutPatterns(startTime: $startTime, timeRange: $timeRange, numberOfDepartures: $numberOfDepartures, omitCanceled: false) {
            ...DepartureListContainer_stoptimes
          }
        }
      }
''';
