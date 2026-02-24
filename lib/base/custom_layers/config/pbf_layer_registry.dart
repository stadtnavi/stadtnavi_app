/// Registry for PBF tile fetchers.
///
/// Each [PbfPointLayer] (and other tile-based layers) registers its
/// static [fetchPBF] method here. [CancellableNetworkTileProvider]
/// uses this registry instead of hard-coding imports to every layer.
class PbfLayerRegistry {
  PbfLayerRegistry._();

  static final Map<Type, Future<void> Function(int z, int x, int y)>
      _fetchers = {};

  /// Register a fetcher for a layer type.
  /// Called once per layer type (typically in a top-level initializer).
  static void register(
    Type layerType,
    Future<void> Function(int z, int x, int y) fetcher,
  ) {
    _fetchers[layerType] = fetcher;
  }

  /// Returns futures for all active layers' tile fetches.
  static List<Future<void>> fetchActiveLayers(
    List<Type> activeTypes,
    int z,
    int x,
    int y,
  ) {
    return activeTypes
        .where((type) => _fetchers.containsKey(type))
        .map((type) => _fetchers[type]!(z, x, y))
        .toList();
  }
}
