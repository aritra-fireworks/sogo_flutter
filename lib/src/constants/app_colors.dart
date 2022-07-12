import 'dart:ui';

class AppColors {
  static Color primaryRed = "#BE223C".toColor();
  static const Color secondaryRed = Color(0xFFE13856);
  static const Color yellow = Color(0xFFFDDB68);
  static const Color greyBackground = Color(0xFF2E133C);
  static const Color textBlack = Color(0xFF333333);
  static const Color lightBlack = Color(0xFF363636);
  static const Color textGrey = Color(0xFF9A9696);
  static const Color grey = Color(0xFF707070);
}


extension on String {
  Color toColor() {
    String hexColorString = replaceAll('#', '');
    if(hexColorString.length == 6) {
      hexColorString = 'FF' + hexColorString;
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}