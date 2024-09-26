import 'package:flutter/material.dart';

class SpeedExpansionTile extends StatelessWidget {
  final String title;
  final List<DataSpeed> dataSpeeds;
  final String textSelected;
  final Function(String) onChanged;
  final bool isSubtitle;

  const SpeedExpansionTile({
    Key? key,
    required this.title,
    required this.dataSpeeds,
    required this.textSelected,
    required this.onChanged,
    this.isSubtitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isSubtitle) const SizedBox(width: 55),
          Expanded(child: Text(title, style: theme.textTheme.bodyLarge)),
          Text(
            textSelected,
            style: TextStyle(
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
      collapsedIconColor: theme.colorScheme.primary,
      iconColor: theme.colorScheme.primary,
      children: dataSpeeds
          .map(
            (dataSpeed) => Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              child: ListTile(
                tileColor: theme.textTheme.bodyLarge?.color?.withOpacity(0.05),
                visualDensity: VisualDensity.compact,
                title: Text(
                  dataSpeed.name,
                  style: TextStyle(
                    color: theme.primaryColor,
                  ),
                ),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dataSpeed.speed,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      if (dataSpeed.name.toLowerCase() ==
                          textSelected.toLowerCase())
                        Icon(
                          Icons.check,
                          color: theme.colorScheme.primary,
                        )
                      else
                        Container(width: 15),
                    ],
                  ),
                ),
                onTap: () {
                  onChanged(dataSpeed.name);
                },
              ),
            ),
          )
          .toList(),
    );
  }
}

class DataSpeed {
  final String name;
  final String speed;

  DataSpeed(this.name, this.speed);
}
