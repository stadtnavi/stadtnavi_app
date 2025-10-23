import 'dart:async';

import 'package:de_stadtnavi_herrenberg_internal/pages/home/services/global_alerts/models/global_alert_entity.dart';
import 'package:gql/language.dart';
import 'package:graphql/client.dart';
import 'package:trufi_core/pages/home/service/graphql_client.dart';

class OtpGlobalAlertsRepository {
  final GraphQLClient client;

  OtpGlobalAlertsRepository(String endpoint)
      : client = getClient(endpoint,
            partialDataPolicy: PartialDataCachePolicy.reject);

  Future<List<GlobalAlertEntity>> fetchAlerts({
    required List<String> feedIds,
    required String locale,
  }) async {
    final QueryOptions planAdvancedQuery = QueryOptions(
      document: parseString(r'''
    query MessageBarQuery($feedids: [String!]) {
      alerts: alerts(severityLevel: [SEVERE], feeds: $feedids) {
        feed
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
'''),
      variables: <String, dynamic>{
        'feedids': feedIds,
      },
      fetchPolicy: FetchPolicy.noCache,
      cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
    );
    final planAdvancedData = await client.query(planAdvancedQuery);
    if (planAdvancedData.hasException && planAdvancedData.data == null) {
      final errorMessage =
          locale == 'en'
              ? 'Service alerts are temporarily unavailable. Please try again later.'
              : 'Servicehinweise sind vorübergehend nicht verfügbar. Bitte versuchen Sie es später erneut.';
      throw Exception(errorMessage);
    }
    List<GlobalAlertEntity> planData =
        (planAdvancedData.data!['alerts'] as List)
            .map(
              (e) => GlobalAlertEntity.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList();
    DateTime currentTime = DateTime.now();
    planData = planData.where((alert) {
      return (alert.effectiveStartDate != null &&
              alert.effectiveStartDate != null)
          ? (alert.effectiveStartDate!.isBefore(currentTime) &&
              alert.effectiveEndDate!.isAfter(currentTime))
          : false;
    }).toList();
    final planDatas = uniqBy(planData, (alert) => alert.alertHash);

    return planDatas;
  }

  List<T> uniqBy<T, V>(List<T> list, V Function(T) key) {
    var seenKeys = <V>{};
    return list.where((element) => seenKeys.add(key(element))).toList();
  }
}
