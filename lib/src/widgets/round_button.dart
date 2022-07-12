import 'package:flutter/material.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';

class RoundButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? borderRadius;
  final Color? color;
  const RoundButton({Key? key, required this.onPressed, required this.child, this.borderRadius, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? buttonColor = color;
    buttonColor ??= AppColors.primaryRed;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextButton(
              onPressed: onPressed,
              child: child,
              style: ButtonStyle(
                shape: MaterialStateProperty.all(borderRadius != null ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius!)) : const StadiumBorder()),
                backgroundColor: MaterialStateProperty.all(onPressed != null ? buttonColor : buttonColor.withOpacity(0.5)),
                foregroundColor: MaterialStateProperty.all(onPressed != null ? Colors.white : Colors.white.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
