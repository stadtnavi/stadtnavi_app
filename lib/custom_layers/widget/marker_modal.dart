import 'package:flutter/material.dart';
import 'package:scrollable_panel/scrollable_panel.dart';

class MarkerModal extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  const MarkerModal({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final panelController = PanelController();
    final mediaQuery = MediaQuery.of(context);
    return ScrollablePanel(
      controller: panelController,
      onClose: () => Navigator.pop(context),
      builder: (scrollablePanelContext, controller) {
        return SingleChildScrollView(
          controller: controller,
          child: SizedBox(
            height: mediaQuery.size.height + 1,
            child: SafeArea(
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: builder(scrollablePanelContext),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> showMarkerModal({
  BuildContext context,
  Widget Function(BuildContext) builder,
}) async {
  return showDialog(
    barrierColor: Colors.transparent,
    useSafeArea: false,
    context: context,
    builder: (BuildContext context) => MarkerModal(builder: builder),
  );
}

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
