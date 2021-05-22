import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/l10n/trufi_localization.dart';

class DateDayPicker extends StatefulWidget {
  const DateDayPicker({Key key, @required this.dateTime})
      : assert(dateTime != null),
        super(key: key);

  final DateTime dateTime;

  @override
  _DateDayPickerState createState() => _DateDayPickerState();
}

class _DateDayPickerState extends State<DateDayPicker> {
  DateTime nowDateTime = DateTime.now();
  DateTime tempDateTime;

  @override
  void initState() {
    tempDateTime = widget.dateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiLocalization.of(context);
    return Container(
      height: MediaQuery.of(context).size.height *
          (MediaQuery.of(context).orientation == Orientation.portrait
              ? 0.3
              : 0.5),
      color: theme.backgroundColor,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  localization.commonCancel,
                ),
              ),
              const Spacer(),
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    tempDateTime,
                  );
                },
                child: Text(localization.commonOK),
              ),
            ],
          ),
          const Divider(height: 0, thickness: 1),
          Expanded(
            child: CupertinoDatePicker(
              onDateTimeChanged: (picked) {
                tempDateTime = picked;
              },
              use24hFormat: true,
              initialDateTime: nowDateTime.isBefore(tempDateTime)
                  ? tempDateTime
                  : nowDateTime,
              minimumDate: nowDateTime.subtract(const Duration(minutes: 3)),
              maximumDate: nowDateTime.add(const Duration(days: 35)),
              mode: CupertinoDatePickerMode.date,
            ),
          ),
        ],
      ),
    );
  }
}
