class MapLayerProperties {
  final String? layerType;
  final String? layerUrl;
  final int? layerPriority;
  final int? layerMinZoom;
  final bool? layerEnabledPerDefault;

  final String? iconSvg;
  final String? iconSvgMenu;
  final String? iconOrigin;
  final String? iconBackgroundColor;
  final String? iconColor;

  MapLayerProperties({
    this.layerType,
    this.layerUrl,
    this.layerPriority,
    this.layerMinZoom,
    this.layerEnabledPerDefault,
    this.iconSvg,
    this.iconSvgMenu,
    this.iconOrigin,
    this.iconBackgroundColor,
    this.iconColor,
  });

  factory MapLayerProperties.fromJson(json) {
    final layerMap = json['layer'];
    final iconMap = json['icon'];
    final int? layerMinZoom = layerMap?['min_zoom'];
    return MapLayerProperties(
      layerType: layerMap?['type'],
      layerUrl: layerMap?['url'],
      layerPriority: layerMap?['priority'],
      layerMinZoom: layerMinZoom != null ? layerMinZoom - 1 : null,
      layerEnabledPerDefault: layerMap?['enabled_per_default'],
      iconSvg: iconMap?['svg'],
      iconSvgMenu: iconMap?['svg_menu'],
      iconOrigin: iconMap?['origin'],
      iconBackgroundColor: iconMap?['background_color'],
      iconColor: iconMap?['color'],
    );
  }
}
