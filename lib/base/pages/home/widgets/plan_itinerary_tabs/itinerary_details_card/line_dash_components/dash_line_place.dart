import 'package:flutter/material.dart';

class DashLinePlace extends StatelessWidget {
  final String date;
  final String? delayedDate;
  final bool? isDelayed;
  final String location;
  final String? subtitle;
  final Widget? child;
  final Color? color;
  final Widget? alertSeverityIcon;

  const DashLinePlace({
    Key? key,
    required this.date,
    this.delayedDate,
    this.isDelayed,
    required this.location,
    this.subtitle,
    this.child,
    this.color,
    this.alertSeverityIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 45 * textScaleFactor,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        isDelayed == null
                            ? Colors.black
                            : isDelayed!
                            ? Colors.red
                            : Color(0xFF3a7f00),
                  ),
                  maxLines: 1,
                ),
                if (delayedDate != null)
                  Positioned(
                    top: 18,
                    child: Text(
                      delayedDate!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                      maxLines: 1,
                    ),
                  ),
              ],
            ),
          ),
          if (child == null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              child: Icon(Icons.circle, size: 18, color: color),
            )
          else
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                child!,
                Expanded(
                  child: Container(width: 4, color: color ?? Colors.black),
                ),
              ],
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        location,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (alertSeverityIcon != null)
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        child: alertSeverityIcon,
                      ),
                  ],
                ),
                if (subtitle != null)
                  Text(subtitle!, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
