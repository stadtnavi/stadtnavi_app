import 'package:flutter/material.dart';

class SpeedExpansionTile extends StatefulWidget {
  final String? title;
  final List<DataSpeed> dataSpeeds;
  final String textSelected;
  final Function(String) onChanged;
  final bool isSubSection;

  const SpeedExpansionTile({
    Key? key,
    required this.title,
    required this.dataSpeeds,
    required this.textSelected,
    required this.onChanged,
    this.isSubSection = false,
  }) : super(key: key);

  @override
  State<SpeedExpansionTile> createState() => _SpeedExpansionTileState();
}

class _SpeedExpansionTileState extends State<SpeedExpansionTile> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: widget.isSubSection ? const EdgeInsets.only(left: 55) : null,
      child: ExpansionTile(
        visualDensity: VisualDensity(vertical: -4),
        // tilePadding: EdgeInsets.symmetric(horizontal: 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.title != null)
              Expanded(
                  child: Text(
                widget.title!,
                style: theme.textTheme.bodyLarge,
              )),
            Text(
              widget.textSelected,
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.title == null)
              Container(
                margin: const EdgeInsets.only(left: 8.0),
                child: Icon(isExpanded
                    ? Icons.keyboard_arrow_up_outlined
                    : Icons.keyboard_arrow_down_outlined),
              )
          ],
        ),
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        collapsedIconColor: theme.colorScheme.primary,
        iconColor: theme.colorScheme.primary,
        showTrailingIcon: widget.title != null,
        children: widget.dataSpeeds.map((dataSpeed) {
          final isSelected =
              dataSpeed.name.toLowerCase() == widget.textSelected.toLowerCase();
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            decoration: BoxDecoration(
              border: isSelected ? Border.all(width: 0.5) : null,
              borderRadius: BorderRadius.circular(5),
              color: isSelected ? null : const Color(0xffF4F4F5),
            ),
            child: ListTile(
              visualDensity: const VisualDensity(vertical: -4),
              title: Text(
                dataSpeed.name,
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dataSpeed.speed,
                      style: const TextStyle(),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check,
                        color: Color(0xff007AC9),
                      )
                    else
                      Container(width: 15),
                  ],
                ),
              ),
              onTap: () {
                widget.onChanged(dataSpeed.name);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DataSpeed {
  final String name;
  final String speed;

  DataSpeed(this.name, this.speed);
}
