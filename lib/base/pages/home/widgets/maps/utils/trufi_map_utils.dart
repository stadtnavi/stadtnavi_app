import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:stadtnavi_core/base/models/plan_entity.dart';
import 'package:trufi_core_maps/trufi_core_maps.dart';

import 'package:trufi_core/base/models/enums/transport_mode.dart';

class PolylineWithMarkers {
  PolylineWithMarkers(this.line, this.markers);

  final TrufiLine line;
  final List<TrufiMarker> markers;
}

PlanItinerary? itineraryForPoint(
    Map<PlanItinerary, List<PolylineWithMarkers>> itineraries,
    List<TrufiLine> lines,
    LatLng point) {
  return _itineraryForLine(itineraries, _lineHitTest(lines, point));
}

PlanItinerary? _itineraryForLine(
    Map<PlanItinerary, List<PolylineWithMarkers>> itineraries,
    TrufiLine? line) {
  final entry = _itineraryEntryForLine(itineraries, line);
  return entry?.key;
}

MapEntry<PlanItinerary, List<PolylineWithMarkers>>? _itineraryEntryForLine(
  Map<PlanItinerary, List<PolylineWithMarkers>> itineraries,
  TrufiLine? line,
) {
  if (line == null) return null;
  return itineraries.entries.firstWhereOrNull((pair) {
    return null !=
        pair.value.firstWhereOrNull(
          (pwm) => pwm.line.id == line.id,
        );
  });
}

TrufiLine? _lineHitTest(List<TrufiLine> lines, LatLng point) {
  TrufiLine? minLine;
  double minDist = double.maxFinite;
  for (final TrufiLine l in lines) {
    for (int i = 0; i < l.position.length - 1; i++) {
      final double dist = distToSegment(point, l.position[i], l.position[i + 1]);
      if (dist < minDist) {
        minDist = dist;
        minLine = l;
      }
    }
  }
  return minLine;
}

TrufiMarker buildTransferTrufiMarker(LatLng point) {
  return TrufiMarker(
    id: 'transfer_${point.latitude}_${point.longitude}',
    position: point,
    size: const Size(20, 20),
    imageCacheKey: 'transfer_marker',
    widget: Transform.scale(
      scale: 0.4,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 3.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.circle, color: Colors.white),
      ),
    ),
  );
}

TrufiMarker buildTransportTrufiMarker(
  LatLng point,
  Color color,
  PlanItineraryLeg leg, {
  VoidCallback? onTap,
  bool showIcon = true,
  bool showText = true,
}) {
  return TrufiMarker(
    id: 'transport_${point.latitude}_${point.longitude}_${leg.hashCode}',
    position: point,
    size: const Size(50, 30),
    widget: Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: [
            if (showIcon)
              SizedBox(
                height: 28,
                width: 28,
                child: leg.transportMode.getImage(color: Colors.white),
              ),
            if (showText)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  leg.route?.shortName ?? leg.headSign,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
          ],
        ),
      ),
    ),
  );
}

TrufiMarker buildTrufiMarker(
  LatLng point,
  IconData iconData,
  Alignment alignment,
  Color color, {
  Decoration? decoration,
}) {
  return TrufiMarker(
    id: 'marker_${point.latitude}_${point.longitude}_${iconData.codePoint}',
    position: point,
    alignment: alignment,
    widget: Container(
      decoration: decoration,
      child: Icon(iconData, color: color),
    ),
  );
}

double sqr(double x) {
  return x * x;
}

double dist2(LatLng v, LatLng w) {
  return sqr(v.longitude - w.longitude) + sqr(v.latitude - w.latitude);
}

double distToSegment(LatLng p, LatLng v, LatLng w) {
  return sqrt(distToSegmentSquared(p, v, w));
}

double distToSegmentSquared(LatLng p, LatLng v, LatLng w) {
  final double l2 = dist2(v, w);
  if (l2 == 0) return dist2(p, v);
  double t = ((p.longitude - v.longitude) * (w.longitude - v.longitude) +
          (p.latitude - v.latitude) * (w.latitude - v.latitude)) /
      l2;
  t = max(0.0, min(1.0, t));
  return dist2(
      p,
      LatLng(v.latitude + t * (w.latitude - v.latitude),
          v.longitude + t * (w.longitude - v.longitude)));
}

double lengthForPolyline(List<LatLng> points) {
  double totalLength = 0.0;
  for (int i = 0; i < points.length - 1; i++) {
    totalLength += dist2(points[i], points[i + 1]);
  }
  return totalLength;
}

LatLng midPointForPoints(List<LatLng> points) {
  final double midPointLength = lengthForPolyline(points) / 2;
  double totalLength = 0.0;
  if (points.length >= 2) {
    for (int i = 0; i < points.length - 1; i++) {
      final LatLng p0 = points[i];
      final LatLng p1 = points[i + 1];
      final double segmentLength = dist2(p0, p1);
      totalLength += segmentLength;
      if (midPointLength < totalLength) {
        final double factor1 = (totalLength - midPointLength) / segmentLength;
        final double factor0 = 1.0 - factor1;
        final double latitude = p0.latitude * factor0 + p1.latitude * factor1;
        final double longitude =
            p0.longitude * factor0 + p1.longitude * factor1;
        return LatLng(latitude, longitude);
      }
    }
  }
  return points[0];
}
