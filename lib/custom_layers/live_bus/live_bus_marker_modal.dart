import 'package:flutter/material.dart';
import './live_bus_layer.dart';
import 'live_bus_enum.dart';
import 'live_bus_model.dart';

class LiveBusMarkerModal extends StatefulWidget {
  final LiveBusFeature mainElement;

  final OnLiveBusStateChangeContainer onLiveBusStateChangeContainer;
  const LiveBusMarkerModal({
    Key key,
    @required this.mainElement,
    @required this.onLiveBusStateChangeContainer,
  }) : super(key: key);

  @override
  _LiveBusMarkerModalState createState() => _LiveBusMarkerModalState();
}

class _LiveBusMarkerModalState extends State<LiveBusMarkerModal> {
  LiveBusFeature element;
  @override
  void initState() {
    element = widget.mainElement;
    super.initState();
    widget.onLiveBusStateChangeContainer.onUpdate = (element) {
      if (mounted) {
        setState(() {
          this.element = element;
        });
      }
    };
  }

  @override
  void dispose() {
    widget.onLiveBusStateChangeContainer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
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
                  liveBusStateToOccupancyState(element.type, languageCode),
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
  }
}
