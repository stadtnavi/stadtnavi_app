import 'package:flutter/material.dart';

class SwapButton extends StatelessWidget {
  const SwapButton({
    Key? key,
    required this.orientation,
    required this.onSwap,
    required this.color,
  }) : super(key: key);
  final Orientation orientation;
  final void Function() onSwap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: IconButton(
        icon: Icon(
          orientation == Orientation.portrait
              ? Icons.swap_vert
              : Icons.swap_horiz,
          color: color,
        ),
        onPressed: onSwap,
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({
    Key? key,
    required this.onReset,
    required this.color,
  }) : super(key: key);
  final void Function() onReset;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: IconButton(
        icon: Icon(
          Icons.clear,
          color: color,
        ),
        onPressed: onReset,
      ),
    );
  }
}
