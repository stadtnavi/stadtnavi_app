import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrufiMapAnimations {
  TrufiMapAnimations();
  static const _startedId = "AnimatedMapController#MoveStarted";
  static const _inProgressId = "AnimatedMapController#MoveInProgress";
  static const _finishedId = "AnimatedMapController#MoveFinished";

  void move({
    required LatLng center,
    required double zoom,
    required TickerProvider vsync,
    required MapController mapController,
  }) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final camera = mapController.camera;
    final latTween = Tween<double>(
      begin: camera.center.latitude,
      end: center.latitude,
    );
    final lngTween = Tween<double>(
      begin: camera.center.longitude,
      end: center.longitude,
    );
    final zoomTween = Tween<double>(begin: camera.zoom, end: zoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    // Note this method of encoding the target destination is a workaround.
    // When proper animated movement is supported (see #1263) we should be able
    // to detect an appropriate animated movement event which contains the
    // target zoom/center.
    final startIdWithTarget =
        "$_startedId#${center.latitude},${center.longitude},$zoom";
    var hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void fitBounds({
    required LatLngBounds bounds,
    required TickerProvider vsync,
    required MapController mapController,
  }) {
    // final neLatitudeTween = Tween<double>(
    //   begin: mapController.camera.visibleBounds.northEast.latitude,
    //   end: bounds.northEast.latitude,
    // );
    // final neLongitudeTween = Tween<double>(
    //   begin: mapController.camera.visibleBounds.northEast.longitude,
    //   end: bounds.northEast.longitude,
    // );
    // final swLatitudeTween = Tween<double>(
    //   begin: mapController.camera.visibleBounds.southWest.latitude,
    //   end: bounds.southWest.latitude,
    // );
    // final swLongitudeTween = Tween<double>(
    //   begin: mapController.camera.visibleBounds.southWest.longitude,
    //   end: bounds.southWest.longitude,
    // );
    final controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: vsync,
    );
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );
    controller.addListener(() {
      // TODO update fitBounds
      mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: EdgeInsets.all(50),
        ),
        // LatLngBounds(
        //   LatLng(
        //     neLatitudeTween.evaluate(animation),
        //     neLongitudeTween.evaluate(animation),
        //   ),
        //   LatLng(
        //     swLatitudeTween.evaluate(animation),
        //     swLongitudeTween.evaluate(animation),
        //   ),
        // ),
        // // TODO update FitBoundsOptions
        // options: const FitBoundsOption(
        //   padding: EdgeInsets.all(50),
        // ),
      );
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }
}
