import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import 'live_bus_enum.dart';
import 'live_bus_model.dart';

class CifsMarkerModal extends StatefulWidget {
  final LiveBusFeature mainElement;
  final BehaviorSubject<LiveBusFeature> currentFocus;
  const CifsMarkerModal({
    Key key,
    @required this.mainElement,
    @required this.currentFocus,
  }) : super(key: key);

  @override
  _CifsMarkerModalState createState() => _CifsMarkerModalState();
}

class _CifsMarkerModalState extends State<CifsMarkerModal> {
  @override
  void dispose() {
    widget.currentFocus.sink.add(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    return StreamBuilder<LiveBusFeature>(
        stream: widget.currentFocus,
        builder: (context, snapshot) {
          final LiveBusFeature element = snapshot.data ?? widget.mainElement;
          return ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: liveBusStateIcon(element.type),
                    ),
                    const Expanded(
                      child: Text(
                        "Bus",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: liveBusStateToOccupandyIcon(element.type),
                    ),
                    Expanded(
                      child: Text(
                        liveBusStateToOccupancyState(
                            element.type, languageCode),
                        style: TextStyle(
                          color: theme.textTheme.bodyText1.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
