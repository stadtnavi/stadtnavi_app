// // TODO Review CustomPolylineLayer
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_map/flutter_map.dart';
// // ignore: implementation_imports
// // import 'package:flutter_map/src/map/map.dart';
// // import 'package:flutter_map/src/map/flutter_map_state.dart';
// import 'package:latlong2/latlong.dart';

// class CustomPolyline {
//   final List<List<LatLng>> points;
//   final List<List<Offset>> offsets = [];
//   final double strokeWidth;
//   final Color color;
//   final double borderStrokeWidth;
//   final Color? borderColor;
//   final List<Color>? gradientColors;
//   final List<double>? colorsStop;
//   final bool isDotted;
//   late final LatLngBounds boundingBox;

//   CustomPolyline({
//     required this.points,
//     this.strokeWidth = 1.0,
//     this.color = const Color(0xFF00FF00),
//     this.borderStrokeWidth = 0.0,
//     this.borderColor = const Color(0xFFFFFF00),
//     this.gradientColors,
//     this.colorsStop,
//     this.isDotted = false,
//   });
// }

// class CustomPolylineLayer extends StatelessWidget {
//   final List<CustomPolyline> polylineOpts;
//   final bool polylineCulling;

//   CustomPolylineLayer({
//     super.key,
//     this.polylineOpts = const [],
//     this.polylineCulling = false,
//   }) {
//     if (polylineCulling) {
//       for (var polyline in polylineOpts) {
//         polyline.boundingBox = LatLngBounds.fromPoints(
//             polyline.points.fold([], (i, j) => [...i, ...j]));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints bc) {
//         final map = FlutterMapState.maybeOf(context)!;
//         final size = Size(bc.maxWidth, bc.maxHeight);
//         var polylines = <Widget>[];

//         for (CustomPolyline polylineOpt in polylineOpts) {
//           for (var element in polylineOpt.offsets) {
//             element.clear();
//           }

//           if (polylineCulling &&
//               !polylineOpt.boundingBox.isOverlapping(map.bounds)) {
//             // skip this polyline as it's offscreen
//             continue;
//           }

//           _fillOffsets(polylineOpt.offsets, polylineOpt.points, map);

//           polylines.add(CustomPaint(
//             painter: CustomPolylinePainter(polylineOpt),
//             size: size,
//           ));
//         }

//         return Stack(
//           children: polylines,
//         );
//       },
//     );
//   }

//   void _fillOffsets(
//     final List<List<Offset>> offsets,
//     final List<List<LatLng>> points,
//     FlutterMapState map,
//   ) {
//     for (var j = 0, len = points.length; j < len; ++j) {
//       List<LatLng> tempList = points[j];
//       List<Offset> tempListOffsets = [];
//       for (var i = 0, len = tempList.length; i < len; ++i) {
//         var point = tempList[i];

//         final offset = map.getOffsetFromOrigin(point);
//         // var pos = map.project(point);
//         // pos = pos.multiplyBy(map.getZoomScale(map.zoom, map.zoom)) -
//         //     map.getPixelOrigin();
//         tempListOffsets.add(offset);
//         if (i > 0) {
//           tempListOffsets.add(offset);
//         }
//       }
//       offsets.add(tempListOffsets);
//     }
//   }
// }

// class CustomPolylinePainter extends CustomPainter {
//   final CustomPolyline polylineOpt;

//   CustomPolylinePainter(this.polylineOpt);

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (polylineOpt.offsets.isEmpty) {
//       return;
//     }
//     final rect = Offset.zero & size;
//     canvas.clipRect(rect);
//     final paint = Paint()
//       ..strokeWidth = polylineOpt.strokeWidth
//       ..strokeCap = StrokeCap.round
//       ..strokeJoin = StrokeJoin.round
//       ..blendMode = BlendMode.srcOver;

//     if (polylineOpt.gradientColors == null) {
//       paint.color = polylineOpt.color;
//     } else {
//       polylineOpt.gradientColors!.isNotEmpty
//           ? paint.shader = _paintGradient()
//           : paint.color = polylineOpt.color;
//     }

//     canvas.saveLayer(rect, Paint());
//     for (var i = 0, len = polylineOpt.offsets.length; i < len; ++i) {
//       final tempOffsets = polylineOpt.offsets[i];
//       if (polylineOpt.isDotted) {
//         paint.style = PaintingStyle.stroke;
//         _paintDottedLine(canvas, tempOffsets, paint);
//       } else {
//         paint.style = PaintingStyle.stroke;
//         _paintLine(canvas, tempOffsets, paint);
//       }
//     }
//     canvas.restore();
//   }

//   void _paintDottedLine(Canvas canvas, List<Offset> offsets, Paint paint) {
//     if (offsets.isNotEmpty) {
//       final path = ui.Path()..moveTo(offsets[0].dx, offsets[0].dy);
//       ui.Path dashPath = ui.Path();

//       double dashWidth = 6.0;
//       double dashSpace = 4.0;
//       double distance = 0.0;

//       for (var offset in offsets) {
//         path.lineTo(offset.dx, offset.dy);
//         for (ui.PathMetric pathMetric in path.computeMetrics()) {
//           while (distance < pathMetric.length) {
//             dashPath.addPath(
//               pathMetric.extractPath(distance, distance + dashWidth),
//               Offset.zero,
//             );
//             distance += dashWidth;
//             distance += dashSpace;
//           }
//         }
//       }
//       canvas.drawPath(dashPath, paint);
//     }
//   }

//   void _paintLine(Canvas canvas, List<Offset> offsets, Paint paint) {
//     if (offsets.isNotEmpty) {
//       final path = ui.Path()..moveTo(offsets[0].dx, offsets[0].dy);
//       for (var offset in offsets) {
//         path.lineTo(offset.dx, offset.dy);
//       }
//       canvas.drawPath(path, paint);
//     }
//   }

//   ui.Gradient _paintGradient() => ui.Gradient.linear(
//       polylineOpt.offsets.first.first,
//       polylineOpt.offsets.first.last,
//       polylineOpt.gradientColors!,
//       _getColorsStop());

//   List<double>? _getColorsStop() => (polylineOpt.colorsStop != null &&
//           polylineOpt.colorsStop!.length == polylineOpt.gradientColors!.length)
//       ? polylineOpt.colorsStop
//       : _calculateColorsStop();

//   List<double> _calculateColorsStop() {
//     final colorsStopInterval = 1.0 / polylineOpt.gradientColors!.length;
//     return polylineOpt.gradientColors!
//         .map((gradientColor) =>
//             polylineOpt.gradientColors!.indexOf(gradientColor) *
//             colorsStopInterval)
//         .toList();
//   }

//   @override
//   bool shouldRepaint(CustomPolylinePainter oldDelegate) => false;
// }
