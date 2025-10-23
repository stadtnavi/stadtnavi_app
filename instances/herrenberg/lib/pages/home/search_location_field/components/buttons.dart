import 'package:flutter/material.dart';

class SwapButton extends StatelessWidget {
  const SwapButton({
    super.key,
    required this.orientation,
    required this.onSwap,
    required this.color,
  });
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
  const ResetButton({super.key, required this.onReset, required this.color});
  final void Function() onReset;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: IconButton(
        icon: Icon(Icons.clear, color: color),
        onPressed: onReset,
      ),
    );
  }
}
