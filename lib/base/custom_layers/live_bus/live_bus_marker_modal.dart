import 'package:flutter/material.dart';
import './live_bus_layer.dart';
import 'live_bus_enum.dart';
import 'live_bus_model.dart';

class LiveBusMarkerModal extends StatefulWidget {
  final LiveBusFeature mainElement;

  final OnLiveBusStateChangeContainer? onLiveBusStateChangeContainer;
  const LiveBusMarkerModal({
    Key? key,
    required this.mainElement,
    required this.onLiveBusStateChangeContainer,
  }) : super(key: key);

  @override
  _LiveBusMarkerModalState createState() => _LiveBusMarkerModalState();
}

class _LiveBusMarkerModalState extends State<LiveBusMarkerModal> {
  late LiveBusFeature element;
  @override
  void initState() {
    element = widget.mainElement;
    super.initState();
    widget.onLiveBusStateChangeContainer?.onUpdate = (element) {
      if (mounted) {
        setState(() {
          this.element = element;
        });
      }
    };
  }

  @override
  void dispose() {
    widget.onLiveBusStateChangeContainer?.dispose();
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.mainElement.name,
                          style: const TextStyle(fontSize: 25),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              Text(
                                widget.mainElement.time,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${languageCode == "en" ? "To " : "Ri. "}${widget.mainElement.to}",
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
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
                    color: theme.textTheme. bodyLarge?.color,
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
