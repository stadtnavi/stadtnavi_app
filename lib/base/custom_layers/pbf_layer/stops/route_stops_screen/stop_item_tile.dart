import 'package:flutter/material.dart';
import 'package:stadtnavi_core/base/custom_layers/services/models_otp/stop.dart';

class StopItemTile extends StatelessWidget {
  final Stop stop;
  final Color? color;
  final bool? isLastElement;

  const StopItemTile({
    Key? key,
    required this.stop,
    this.color,
    this.isLastElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: color ?? Colors.red, width: 3.5),
                  shape: BoxShape.circle),
            ),
            if (!(isLastElement ?? false))
              Container(
                width: 4,
                height: 30,
                color: color ?? Colors.red,
              )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: SizedBox(
            height: !(isLastElement ?? false) ? 20 : 50,
            child: Row(
              crossAxisAlignment: !(isLastElement ?? false)
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:
                      Text(stop.name ?? '', style: theme.textTheme. bodyLarge),
                ),
                Text(
                  '${stop.stopTimesForPattern![0].timeDiffInMinutes} ',
                  style: theme.textTheme. bodyLarge,
                ),
                Text(
                  '${stop.stopTimesForPattern![0].stopTimeAsString} ',
                  style: theme.textTheme. bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
