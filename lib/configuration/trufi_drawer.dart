import 'package:flutter/material.dart';

import 'package:trufi_core/base/widgets/drawer/menu/menu_item.dart';

class StadtnaviDrawer extends StatelessWidget {
  const StadtnaviDrawer(
    this.currentRoute, {
    Key? key,
    required this.appName,
    required this.cityName,
    this.backgroundImageBuilder,
    required this.urlShareApp,
    required this.menuItems,
  }) : super(key: key);

  final String appName;
  final String cityName;
  final String urlShareApp;
  final String currentRoute;
  final List<List<TrufiMenuItem>> menuItems;
  final WidgetBuilder? backgroundImageBuilder;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (backgroundImageBuilder != null)
                  backgroundImageBuilder!(context)
                else
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black12,
                        Colors.black87,
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appName,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cityName,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ...menuItems.fold<List<Widget>>(
                  [],
                  (previousValue, element) => [
                    ...previousValue,
                    if (previousValue.isNotEmpty) const Divider(),
                    ...element.map(
                      (element) => element.buildItem(
                        context,
                        isSelected: currentRoute == element.id,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
