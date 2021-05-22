const String routeStopListContainer = r'''
query RouteStopListContainerQuery(
  $patternId: String!
  $currentTime: Long!
) {
  pattern(id: $patternId) {
    ...RouteStopListContainer_pattern_1WWfn2
    id
  }
}
''';
