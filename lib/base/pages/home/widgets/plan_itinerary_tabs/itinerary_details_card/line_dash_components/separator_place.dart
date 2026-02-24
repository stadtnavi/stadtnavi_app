import 'package:flutter/material.dart';

class SeparatorPlace extends StatelessWidget {
  final Widget child;
  final Widget? separator;
  final double? height;
  final Color? color;

  const SeparatorPlace({
    Key? key,
    required this.child,
    this.separator,
    this.color,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: (45 * textScaleFactor) + 2),
          if (separator != null)
            SizedBox(
              height: height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(width: 4, color: color ?? Colors.black),
                  ),
                  SizedBox(width: 20, child: separator),
                  Expanded(
                    child: Container(width: 4, color: color ?? Colors.black),
                  ),
                ],
              ),
            )
          else
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 7.5),
              width: 5,
              color: color ?? Colors.black,
            ),
          const SizedBox(width: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
