import 'package:flutter/material.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final Widget label;
  final Color? color;
  final AlignmentGeometry alignment;
  const AppCheckbox({Key? key, required this.value, required this.onChanged, required this.label, required this.alignment, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          onChanged(!value);
        },
        child: Align(
          alignment: alignment,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image.asset(
              //   value ? 'assets/images/checked_square.png' : 'assets/images/unchecked_square.png',
              //   height: 20,
              //   color: color ?? AppColors.primaryRed,
              //   fit: BoxFit.fitHeight,
              // ),
              value ? Stack(
                children: [
                  const Icon(Icons.check_box_outlined, color: AppColors.lightBlack,),
                  Icon(Icons.check_box_outline_blank, color: AppColors.primaryRed,),
                ],
              ) : Icon(Icons.check_box_outline_blank, color: AppColors.primaryRed,),
              const SizedBox(
                width: 10,
              ),
              Flexible(child: label),
            ],
          ),
        ),
      ),
    );
  }
}
