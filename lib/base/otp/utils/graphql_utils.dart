import 'package:gql/ast.dart';

/// Adds fragment definitions to a GraphQL document node.
/// Copied from trufi_core to decouple the OTP module.
DocumentNode addFragments(DocumentNode doc, List<DocumentNode> fragments) {
  final newDefinitions = Set<DefinitionNode>.from(doc.definitions);
  for (final frag in fragments) {
    newDefinitions.addAll(frag.definitions);
  }
  return DocumentNode(definitions: newDefinitions.toList(), span: doc.span);
}
