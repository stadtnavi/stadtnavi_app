import 'package:flutter/material.dart';

import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/widgets/utils/date_time_utils.dart';

class DurationComponent extends StatelessWidget {
  final Duration duration;
  final DateTime startTime;
  final DateTime endTime;
  final String futureText;

  const DurationComponent({
    Key? key,
    required this.duration,
    required this.startTime,
    required this.endTime,
    this.futureText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    return Row(
      children: [
        const Icon(Icons.timer_sharp),
        const SizedBox(width: 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateTimeUtils.durationToStringMinutes(duration),
              style: const TextStyle(
                // fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              futureText != ''
                  ? '$futureText\n${DateTimeUtils.durationToHHmm(startTime)} - ${DateTimeUtils.durationToHHmm(endTime)}'
                  : '${DateTimeUtils.durationToHHmm(startTime)} - ${DateTimeUtils.durationToHHmm(endTime)}',
              style: const TextStyle(
                // fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
