const stopAlertsQuery = r'''
  query stopRoutes_StopAlertsContainer_Query
  ($stopId: String!) {
    stop(id: $stopId) {
      ...StopAlertsContainer_stop
    }
  }
''';
const routeAlertsQuery = r'''
  query routeRoutes_RoutePage_Query(
    $routeId: String!
  ) {
    route(id: $routeId) {
      ...RoutePage_route
    }
  }
''';
