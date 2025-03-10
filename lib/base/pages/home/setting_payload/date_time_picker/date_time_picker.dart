import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/translations/stadtnavi_base_localizations.dart';
import 'package:trufi_core/base/translations/trufi_base_localizations.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    Key? key,
    required this.dateConf,
  }) : super(key: key);

  final DateTimeConf dateConf;

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker>
    with SingleTickerProviderStateMixin {
  static const _styleOptions = TextStyle(fontSize: 16);
  final _nowDate = DateTime.now().copyWith(
    hour: 0,
    minute: 0,
    second: 0,
    millisecond: 0,
    microsecond: 0,
  );
  late TabController _controller;
  late DateTimeConf tempDateConf;
  late DateTime initialDateTime;

  @override
  void initState() {
    tempDateConf = widget.dateConf;
    initialDateTime =
        tempDateConf.date != null && tempDateConf.date!.isAfter(_nowDate)
            ? tempDateConf.date!.roundDown(delta: const Duration(minutes: 15))
            : DateTime.now().roundDown(delta: const Duration(minutes: 15));
    super.initState();
    _controller = TabController(
        length: 2, initialIndex: tempDateConf.isArriveBy ? 1 : 0, vsync: this);
    _controller.addListener(() {
      if (_controller.index == 0) {
        setState(() {
          tempDateConf = tempDateConf.copyWith(isArriveBy: false);
        });
      } else if (_controller.index == 1) {
        setState(() {
          tempDateConf = tempDateConf.copyWith(isArriveBy: true);
        });
      }
    });
    BackButtonInterceptor.add(myInterceptor, context: context);
  }

  @override
  void dispose() {
    _controller.dispose();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (!stopDefaultButtonEvent) {
      Navigator.of(context).pop();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationBase = TrufiBaseLocalization.of(context);
    final localization = StadtnaviBaseLocalization.of(context);
    return Container(
      height: MediaQuery.of(context).size.height *
          (MediaQuery.of(context).orientation == Orientation.portrait
              ? 0.35
              : 0.6),
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 18, bottom: 10),
                  child: InkWell(
                    onTap: () =>
                        Navigator.of(context).pop(const DateTimeConf(null)),
                    child: Text(
                      localization.commonLeavingNow,
                      style: _styleOptions.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TabBar(
                  labelPadding: const EdgeInsets.only(top: 18, bottom: 10),
                  controller: _controller,
                  indicatorWeight: 2,
                  indicatorColor: theme.primaryColor,
                  tabs: [
                    Text(
                      localization.commonDeparture,
                      style: _styleOptions.copyWith(
                        color: tempDateConf.isArriveBy
                            ? Colors.grey[700]
                            : theme.primaryColor,
                        fontWeight: tempDateConf.isArriveBy
                            ? FontWeight.w400
                            : FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      localization.commonArrival,
                      style: _styleOptions.copyWith(
                        color: tempDateConf.isArriveBy
                            ? theme.primaryColor
                            : Colors.grey[700],
                        fontWeight: !tempDateConf.isArriveBy
                            ? FontWeight.w400
                            : FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              child: CupertinoDatePicker(
                key: UniqueKey(),
                onDateTimeChanged: (picked) {
                  tempDateConf = tempDateConf.copyWith(date: picked);
                  initialDateTime = picked;
                },
                use24hFormat: true,
                initialDateTime: initialDateTime,
                minimumDate: _nowDate,
                maximumDate: _nowDate.add(const Duration(days: 30)),
                minuteInterval: 15,
              ),
            ),
          ),
          const Divider(height: 0, thickness: 1),
          IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SafeArea(
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        localizationBase.commonCancel.toUpperCase(),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  thickness: 1,
                ),
                Expanded(
                  child: SafeArea(
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.of(context).pop(
                          tempDateConf.copyWith(
                              date: tempDateConf.date ?? _nowDate),
                        );
                      },
                      child: Text(
                        localizationBase.commonOK.toUpperCase(),
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateTimeConf {
  const DateTimeConf(
    this.date, {
    this.isArriveBy = false,
  });

  final DateTime? date;
  final bool isArriveBy;

  DateTimeConf copyWith({
    DateTime? date,
    bool? isArriveBy,
  }) {
    return DateTimeConf(
      date ?? this.date,
      isArriveBy: isArriveBy ?? this.isArriveBy,
    );
  }
}

extension on DateTime {
  DateTime roundDown({Duration delta = const Duration(seconds: 15)}) {
    return DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds);
  }
}
