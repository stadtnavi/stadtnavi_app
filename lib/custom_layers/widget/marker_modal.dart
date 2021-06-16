import 'package:flutter/material.dart';

Future<void> showBottomMarkerModal({
  BuildContext context,
  Widget Function(BuildContext) builder,
}) async {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    builder: (buildContext) => SafeArea(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: builder(buildContext),
      ),
    ),
  );
}
