// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'package:stadtnavi_app/custom_layers/services/models_otp/stoptime.dart';

// class TimeTableScreen extends StatefulWidget {
//   const TimeTableScreen({
//     Key key,
//     @required this.stoptimesByDay,
//   }) : super(key: key);

//   final Map<String, List<Stoptime>> stoptimesByDay;

//   @override
//   _TimeTableScreenState createState() => _TimeTableScreenState();
// }

// class _TimeTableScreenState extends State<TimeTableScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return ListView.builder(
//       itemCount: widget.stoptimesByDay.length,
//       itemBuilder: (contextBuilde, index) {
//         final stopTimeKey = (widget.stoptimesByDay.keys.toList())[index];
//         final now = DateTime.now();
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (index == 0)
//                 Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       child: Text(
//                         "Departures by hour (minutes/route)",
//                         style: theme.textTheme.bodyText1.copyWith(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 100,
//                       child: CupertinoDatePicker(
//                         onDateTimeChanged: (picked) {
//                           // tempDateConf = tempDateConf.copyWith(date: picked);
//                         },
//                         use24hFormat: true,
//                         mode: CupertinoDatePickerMode.date,
//                         initialDateTime: now,
//                         minimumDate: now,
//                         maximumDate: now.add(const Duration(days: 30)),
//                         // minuteInterval: 15,
//                       ),
//                     ),
//                   ],
//                 ),
//               Text(
//                 stopTimeKey,
//                 style: theme.textTheme.bodyText1
//                     .copyWith(fontSize: 20, fontWeight: FontWeight.w700),
//               ),
//               const SizedBox(height: 5),
//               Wrap(
//                 children: [
//                   ...widget.stoptimesByDay[stopTimeKey]
//                       .map((e) => Padding(
//                             padding: const EdgeInsets.only(right: 15),
//                             child: Text(
//                               "${DateFormat('mm').format(e.dateTime)}/${e.trip.route.shortName}",
//                               style: theme.textTheme.bodyText1.copyWith(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ))
//                       .toList(),
//                 ],
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
