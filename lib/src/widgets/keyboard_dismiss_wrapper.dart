import 'package:flutter/material.dart';

class KeyboardDismissWrapper extends StatelessWidget {
  final Widget child;
  final bool dismissOnScroll;
  const KeyboardDismissWrapper({Key? key, required this.child, this.dismissOnScroll = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (onTapDown) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onVerticalDragDown: (details) {
        if(dismissOnScroll) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}