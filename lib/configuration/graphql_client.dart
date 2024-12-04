import 'package:graphql/client.dart';

GraphQLClient getClient(String endpoint) {
  final HttpLink _httpLink = HttpLink(
    endpoint,
    defaultHeaders: {
      'accept-language': 'en',
    },
  );
  return GraphQLClient(
    cache: GraphQLCache(
      store: HiveStore(),
      partialDataPolicy: PartialDataCachePolicy.accept,
    ),
    link: _httpLink,
  );
}

GraphQLClient updateClient({
  required GraphQLClient graphQLClient,
  required String endpoint,
  String? langugeEncode,
}) {
  final httpLink = HttpLink(
    endpoint,
    defaultHeaders: {
      'accept-language': langugeEncode ?? 'en',
    },
  );
  return graphQLClient.copyWith(link: httpLink);
}
