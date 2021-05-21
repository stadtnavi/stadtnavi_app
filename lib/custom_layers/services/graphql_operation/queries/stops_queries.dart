const String stopDataQuery = r'''
  query stopRoutes_StopPageHeaderContainer_Query($stopId: String!) {
        stop(id: $stopId) {
          ...StopCardHeaderContainer_stop
          ...StopPageTabContainer_stop
          stoptimesWithoutPatterns(startTime: 0, timeRange: 864000, numberOfDepartures: 100, omitCanceled: false) {
            ...DepartureListContainer_stoptimes
          }
        }
      }
''';
