import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/map/map.dart';
import 'package:latlong2/latlong.dart';

class CustomPolylineMapPlugin extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    if (options is CustomPolylineLayerOptions) {
      return CustomPolylineLayer(options, mapState, stream);
    }
    throw (StateError("""
Can't find correct layer for $options. Perhaps when you create your FlutterMap you need something like this:

    options: new MapOptions(plugins: [MyFlutterMapPlugin()])"""));
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is CustomPolylineLayerOptions;
  }
}

class CustomPolylineLayerOptions extends LayerOptions {
  final List<CustomPolyline> polylines;
  final bool polylineCulling;

  CustomPolylineLayerOptions({
    Key? key,
    this.polylines = const [],
    this.polylineCulling = false,
    // ignore: prefer_void_to_null
    Stream<Null>? rebuild,
  }) : super(key: key, rebuild: rebuild) {
    if (polylineCulling) {
      for (var polyline in polylines) {
        polyline.boundingBox = LatLngBounds.fromPoints(
            polyline.points.fold([], (i, j) => [...i, ...j]));
      }
    }
  }
}

class CustomPolyline {
  final List<List<LatLng>> points;
  final List<List<Offset>> offsets = [];
  final double strokeWidth;
  final Color color;
  final double borderStrokeWidth;
  final Color? borderColor;
  final List<Color>? gradientColors;
  final List<double>? colorsStop;
  final bool isDotted;
  late final LatLngBounds boundingBox;

  CustomPolyline({
    required this.points,
    this.strokeWidth = 1.0,
    this.color = const Color(0xFF00FF00),
    this.borderStrokeWidth = 0.0,
    this.borderColor = const Color(0xFFFFFF00),
    this.gradientColors,
    this.colorsStop,
    this.isDotted = false,
  });
}

class CustomPolylineLayer extends StatelessWidget {
  final CustomPolylineLayerOptions polylineOpts;
  final MapState map;
  final Stream<void>? stream;

  CustomPolylineLayer(this.polylineOpts, this.map, this.stream)
      : super(key: polylineOpts.key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints bc) {
        final size = Size(bc.maxWidth, bc.maxHeight);
        return _build(context, size);
      },
    );
  }

  Widget _build(BuildContext context, Size size) {
    return StreamBuilder<void>(
      stream: stream,
      builder: (BuildContext context, _) {
        var polylines = <Widget>[];

        for (CustomPolyline polylineOpt in polylineOpts.polylines) {
          for (var element in polylineOpt.offsets) {
            element.clear();
          }

          if (polylineOpts.polylineCulling &&
              !polylineOpt.boundingBox.isOverlapping(map.bounds)) {
            // skip this polyline as it's offscreen
            continue;
          }

          _fillOffsets(polylineOpt.offsets, polylineOpt.points);

          polylines.add(CustomPaint(
            painter: CustomPolylinePainter(polylineOpt),
            size: size,
          ));
        }

        return Stack(
          children: polylines,
        );
      },
    );
  }

  void _fillOffsets(
      final List<List<Offset>> offsets, final List<List<LatLng>> points) {
    for (var j = 0, len = points.length; j < len; ++j) {
      List<LatLng> tempList = points[j];
      List<Offset> tempListOffsets = [];
      for (var i = 0, len = tempList.length; i < len; ++i) {
        var point = tempList[i];
        var pos = map.project(point);
        pos = pos.multiplyBy(map.getZoomScale(map.zoom, map.zoom)) -
            map.getPixelOrigin();
        tempListOffsets.add(Offset(pos.x.toDouble(), pos.y.toDouble()));
        if (i > 0) {
          tempListOffsets.add(Offset(pos.x.toDouble(), pos.y.toDouble()));
        }
      }
      offsets.add(tempListOffsets);
    }
  }
}

class CustomPolylinePainter extends CustomPainter {
  final CustomPolyline polylineOpt;

  CustomPolylinePainter(this.polylineOpt);

  @override
  void paint(Canvas canvas, Size size) {
    if (polylineOpt.offsets.isEmpty) {
      return;
    }
    final rect = Offset.zero & size;
    canvas.clipRect(rect);
    final paint = Paint()
      ..strokeWidth = polylineOpt.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..blendMode = BlendMode.srcOver;

    if (polylineOpt.gradientColors == null) {
      paint.color = polylineOpt.color;
    } else {
      polylineOpt.gradientColors!.isNotEmpty
          ? paint.shader = _paintGradient()
          : paint.color = polylineOpt.color;
    }

    canvas.saveLayer(rect, Paint());
    for (var i = 0, len = polylineOpt.offsets.length; i < len; ++i) {
      final tempOffsets = polylineOpt.offsets[i];
      if (polylineOpt.isDotted) {
        paint.style = PaintingStyle.stroke;
        _paintDottedLine(canvas, tempOffsets, paint);
      } else {
        paint.style = PaintingStyle.stroke;
        _paintLine(canvas, tempOffsets, paint);
      }
    }
    canvas.restore();
  }

  void _paintDottedLine(Canvas canvas, List<Offset> offsets, Paint paint) {
    if (offsets.isNotEmpty) {
      final path = ui.Path()..moveTo(offsets[0].dx, offsets[0].dy);
      ui.Path dashPath = ui.Path();

      double dashWidth = 6.0;
      double dashSpace = 4.0;
      double distance = 0.0;

      for (var offset in offsets) {
        path.lineTo(offset.dx, offset.dy);
        for (ui.PathMetric pathMetric in path.computeMetrics()) {
          while (distance < pathMetric.length) {
            dashPath.addPath(
              pathMetric.extractPath(distance, distance + dashWidth),
              Offset.zero,
            );
            distance += dashWidth;
            distance += dashSpace;
          }
        }
      }
      canvas.drawPath(dashPath, paint);
    }
  }

  void _paintLine(Canvas canvas, List<Offset> offsets, Paint paint) {
    if (offsets.isNotEmpty) {
      final path = ui.Path()..moveTo(offsets[0].dx, offsets[0].dy);
      for (var offset in offsets) {
        path.lineTo(offset.dx, offset.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  ui.Gradient _paintGradient() => ui.Gradient.linear(
      polylineOpt.offsets.first.first,
      polylineOpt.offsets.first.last,
      polylineOpt.gradientColors!,
      _getColorsStop());

  List<double>? _getColorsStop() => (polylineOpt.colorsStop != null &&
          polylineOpt.colorsStop!.length == polylineOpt.gradientColors!.length)
      ? polylineOpt.colorsStop
      : _calculateColorsStop();

  List<double> _calculateColorsStop() {
    final colorsStopInterval = 1.0 / polylineOpt.gradientColors!.length;
    return polylineOpt.gradientColors!
        .map((gradientColor) =>
            polylineOpt.gradientColors!.indexOf(gradientColor) *
            colorsStopInterval)
        .toList();
  }

  @override
  bool shouldRepaint(CustomPolylinePainter oldDelegate) => false;
}
