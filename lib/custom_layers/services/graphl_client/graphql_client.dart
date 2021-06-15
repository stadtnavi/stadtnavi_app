import 'package:graphql/client.dart';
import 'package:stadtnavi_app/configuration_service.dart';

GraphQLClient getClient() {
  final HttpLink _httpLink = HttpLink(
    'https://$baseDomain/routing/v1/router/index/graphql',
  );

  return GraphQLClient(
    cache: GraphQLCache(
      store: HiveStore(),
    ),
    link: _httpLink,
  );
}
