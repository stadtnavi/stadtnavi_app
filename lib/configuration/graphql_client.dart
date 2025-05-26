import 'package:graphql/client.dart';

GraphQLClient getClient(
  String endpoint, {
  // PartialDataCachePolicy partialDataPolicy = PartialDataCachePolicy.accept,
  PartialDataCachePolicy partialDataPolicy = PartialDataCachePolicy.reject,
}) {
  final HttpLink _httpLink = HttpLink(
    endpoint,
    defaultHeaders: {
      'accept-language': 'en',
      "otptimeout": "20000",
    },
  );
  return GraphQLClient(
    cache: GraphQLCache(
      store: HiveStore(),
      partialDataPolicy: partialDataPolicy,
    ),
    link: _httpLink,
    queryRequestTimeout: const Duration(seconds: 20),
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
      "otptimeout": "20000",
    },
  );
  return graphQLClient.copyWith(link: httpLink);
}
