import 'package:flutter/material.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';

class RoundOutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? borderRadius;
  final Color? color;
  const RoundOutlineButton({Key? key, required this.onPressed, required this.child, this.borderRadius, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? buttonForegroundColor = color;
    buttonForegroundColor ??= AppColors.primaryRed;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: OutlinedButton(
              onPressed: onPressed,
              child: child,
              style: ButtonStyle(
                shape: MaterialStateProperty.all(borderRadius != null ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius!)) : const StadiumBorder()),
                foregroundColor: MaterialStateProperty.all(onPressed != null ? buttonForegroundColor : buttonForegroundColor.withOpacity(0.5)),
                side: MaterialStateProperty.all(BorderSide(color: onPressed != null ? buttonForegroundColor : buttonForegroundColor.withOpacity(0.5))),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
