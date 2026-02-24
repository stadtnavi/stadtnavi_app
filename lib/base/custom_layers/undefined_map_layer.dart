import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/custom_layer.dart';

class UndefinedMapLayer extends CustomLayer {
  UndefinedMapLayer() : super("UndefinedMapLayer", 1);

  @override
  Widget buildMarkerLayer(int zoom) {
    return const Icon(Icons.error, color: Colors.red);
  }

  @override
  Widget icon(BuildContext context) {
    return const Icon(
      Icons.error,
      color: Colors.red,
    );
  }

  @override
  String name(BuildContext context) {
    return "TODO: implement name";
  }

  @override
  bool isDefaultOn() => false;
}
