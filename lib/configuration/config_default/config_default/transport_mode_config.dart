class TransportModeConfig {
  bool availableForSelection;
  bool defaultValue;
  int? smallIconZoom;
  String? name;
  Map<String, String>? nearYouLabel;

  TransportModeConfig({
    this.availableForSelection = false,
    this.defaultValue = false,
    this.smallIconZoom,
    this.nearYouLabel,
    this.name,
  });
}
