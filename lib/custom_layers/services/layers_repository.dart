import 'dart:async';

import 'package:gql/language.dart';
import 'package:graphql/client.dart';

import 'graphl_client/graphql_client.dart';
import 'graphl_client/graphql_utils.dart';

import 'graphql_operation/fragment/stop_fragments.dart' as stops_fragments;
import 'graphql_operation/queries/stops_queries.dart' as stops_queries;
import 'models_otp/stop.dart';

class LayersRepository {
  final GraphQLClient client = getClient();

  LayersRepository();

  Future<Stop> fetchStop(String idStop) async {
    final WatchQueryOptions listStopTimes = WatchQueryOptions(
      document: addFragments(parseString(stops_queries.stopDataQuery), [
        stops_fragments.fragmentStopCardHeaderContainerstop,
        stops_fragments.stopPageTabContainerStop,
        stops_fragments.departureListContainerStoptimes,
      ]),
      variables: <String, dynamic>{
        'stopId': idStop,
      },
      pollInterval: const Duration(seconds: 4),
      fetchResults: true,
    );
    final dataStopsTimes = await client.query(listStopTimes);
    final stopData =
        Stop.fromJson(dataStopsTimes.data['stop'] as Map<String, dynamic>);

    return stopData;
  }
}
