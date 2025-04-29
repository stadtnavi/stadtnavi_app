import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter_map_marker_cluster/src/node/marker_node.dart';

class ShowOverlappingData extends StatelessWidget {
  final Key keyData;
  final MarkerNode markerNode;
  const ShowOverlappingData({
    super.key,
    required this.keyData,
    required this.markerNode,
  });

  @override
  Widget build(BuildContext context) {
    final markerTileContainer = (markerNode.child as Builder).build(context);
    if (markerTileContainer is MarkerTileContainer) {
      return InkWell(
          onTap: () {
            final gestureDetector = markerTileContainer.child;
            if (gestureDetector is GestureDetector &&
                gestureDetector.onTap != null) {
              gestureDetector.onTap!.call();
              Navigator.of(context).pop();
            }
            final data =
                (markerNode.child as Builder).build(context) as GestureDetector;
            data.onTap!();
            Navigator.of(context).pop();
          },
          child: markerTileContainer.menuBuilder(context));
    }
    return const Text("MarkerTileContainer not implemented");
  }
}

class MarkerTileContainer extends StatelessWidget {
  const MarkerTileContainer(
      {super.key, required this.child, required this.menuBuilder});
  final Widget Function(BuildContext) menuBuilder;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return child;
  }
}
class MarkerTileListItem extends StatelessWidget {
  final Widget icon;
  final String name;

  const MarkerTileListItem({
    super.key,
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
          child: icon,
        ),
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
