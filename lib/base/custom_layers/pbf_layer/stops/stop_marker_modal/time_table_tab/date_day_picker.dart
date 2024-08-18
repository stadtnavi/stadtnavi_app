import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class DateDayPicker extends StatefulWidget {
  const DateDayPicker({Key? key, required this.dateTime}) : super(key: key);

  final DateTime dateTime;

  @override
  _DateDayPickerState createState() => _DateDayPickerState();
}

class _DateDayPickerState extends State<DateDayPicker> {
  DateTime nowDateTime = DateTime.now();
  late DateTime tempDateTime;

  @override
  void initState() {
    tempDateTime = widget.dateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = TrufiBaseLocalization.of(context);
    return Container(
      height: MediaQuery.of(context).size.height *
          (MediaQuery.of(context).orientation == Orientation.portrait
              ? 0.3
              : 0.5),
      color: theme.colorScheme.surface,
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
