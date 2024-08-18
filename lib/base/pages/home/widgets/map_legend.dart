import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stadtnavi_core/base/custom_layers/map_layers/map_leyers.dart';
import 'package:stadtnavi_core/base/models/enums/enums_plan/icons/map_bicycle_legend.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/blocs/map_tile_provider/map_tile_provider_cubit.dart';

class MapLegend extends StatefulWidget {
  const MapLegend({super.key});

  @override
  State<MapLegend> createState() => _MapLegendState();
}

class _MapLegendState extends State<MapLegend> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stLocalization = StadtnaviBaseLocalization.of(context);
    final mapTileProviderCubit = context.watch<MapTileProviderCubit>();
    return Container(
      decoration: BoxDecoration(
        color: isExpanded ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(isExpanded ? 3 : 50),
        boxShadow: [
          if (isExpanded)
            const BoxShadow(
              color: Color(0xaa000000),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
        ],
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mapTileProviderCubit.state.currentMapTileProvider.id ==
                MapLayerIds.bike.enumToString())
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: ExpansionTile(
                  trailing: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: isExpanded ? Colors.transparent : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (!isExpanded)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          ),
                      ],
                    ),
                    child: isExpanded
                        ? const Icon(
                            Icons.keyboard_arrow_up_outlined,
                          )
                        : Center(
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: MapBicycleLegendIcons.mapLegendSvg,
                            ),
                          ),
                  ),
                  title: Text(
                    isExpanded ? stLocalization.mapLegend : " ",
                    style: const TextStyle(fontWeight: FontWeight.w400),
                    maxLines: 1,
                  ),
                  textColor: theme.textTheme.bodyMedium?.color,
                  collapsedTextColor: theme.textTheme.bodyMedium?.color,
                  collapsedIconColor: theme.iconTheme.color,
                  iconColor: theme.iconTheme.color,
                  tilePadding: EdgeInsets.fromLTRB(
                      isExpanded ? 5 : 0, 0, isExpanded ? 0 : 5, 0),
                  childrenPadding: const EdgeInsets.fromLTRB(5, 0, 10, 8),
                  initiallyExpanded: isExpanded,
                  onExpansionChanged: (value) => setState(() {
                    isExpanded = value;
                  }),
                  children: [
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LegendTile(
                            description: stLocalization.mapLegendBicycleParking,
                            icon: MapBicycleLegendIcons.bicycleParkingSvg,
                          ),
                          const Divider(height: 1, thickness: 1),
                          _LegendTile(
                            description:
                                stLocalization.mapLegendCoveredBicycleParking,
                            icon:
                                MapBicycleLegendIcons.coveredBicycleParkingSvg,
                          ),
                          const Divider(height: 1, thickness: 1),
                          _LegendTile(
                            description:
                                stLocalization.mapLegendLockableBicycleParking,
                            icon:
                                MapBicycleLegendIcons.lockableBicycleParkingSvg,
                          ),
                          const Divider(height: 1, thickness: 1),
                          _LegendTile(
                            description:
                                stLocalization.mapLegendBicycleRepairFacility,
                            icon:
                                MapBicycleLegendIcons.bicycleRepairFacilitySvg,
                          ),
                          const Divider(height: 1, thickness: 1),
                          _LegendTile(
                            description: stLocalization.mapLegendBikeLane,
                            icon: MapBicycleLegendIcons.bikeLaneSvg,
                          ),
                          const Divider(height: 1, thickness: 1),
                          _LegendTile(
                            description:
                                stLocalization.mapLegendMajorCyclingRoute,
                            icon: MapBicycleLegendIcons.majorCyclingRouteSvg,
                          ),
                          const Divider(height: 1, thickness: 1),
                          _LegendTile(
                            description:
                                stLocalization.mapLegendLocalCyclingRoute,
                            icon: MapBicycleLegendIcons.localCyclingRouteSvg,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LegendTile extends StatelessWidget {
  final String description;
  final Widget icon;
  const _LegendTile({
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      // color: Colors.red,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 24, height: 24, child: icon),
          const SizedBox(width: 5),
          Text(description),
        ],
      ),
    );
  }
}
