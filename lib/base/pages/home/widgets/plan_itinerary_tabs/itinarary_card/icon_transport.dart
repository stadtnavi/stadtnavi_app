import 'package:flutter/material.dart';

class IconTransport extends StatelessWidget {
  final Color color;
  final Color bacgroundColor;
  final Color? borderColor;
  final String text;
  final Widget icon;
  final Widget? secondaryIcon;

  const IconTransport({
    Key? key,
    required this.color,
    required this.bacgroundColor,
    this.borderColor,
    required this.text,
    required this.icon,
    this.secondaryIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: bacgroundColor,
        border: borderColor != null ? Border.all(color: borderColor!) : null,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 30,
            width: 22,
            child: Center(
              child: icon,
            ),
          ),
          if (secondaryIcon != null)
            SizedBox(
              height: 22,
              width: 22,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                child: secondaryIcon,
              ),
            ),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}
