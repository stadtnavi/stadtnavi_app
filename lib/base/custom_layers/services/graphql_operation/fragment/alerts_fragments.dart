import 'package:graphql/client.dart';

// Query generate basicData
final stopAlertsContainer = gql(
  '''
    fragment StopAlertsContainer_stop on Stop {
      routes {
        gtfsId
      }
      gtfsId
      locationType
      alerts(types: [STOP, ROUTES]) {
        id
        alertDescriptionText
        alertHash
        alertHeaderText
        alertSeverityLevel
        alertUrl
        effectiveEndDate
        effectiveStartDate
      }
    }
  ''',
);

// Query generate basicData
final routeAlertsContainer = gql(
  '''
    fragment RoutePage_route on Route{
      alerts {
        alertSeverityLevel
        effectiveEndDate
        effectiveStartDate
        alertDescriptionTextTranslations {
          language
          text
        }
      }
    }
  ''',
);
