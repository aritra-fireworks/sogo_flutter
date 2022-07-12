import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';

class CustomDatePickerField extends StatefulWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime?, String?)? onPicked;
  const CustomDatePickerField({Key? key, this.height, this.label='', this.onPicked, required this.selectedDate, this.width, this.borderRadius})
      : super(key: key);

  @override
  _CustomDatePickerFieldState createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  DateTime? selectedDate;

  String? selectedTextDate;
  bool selected = false;

  @override
  void initState() {
    super.initState();
    if(widget.selectedDate != null){
      selectedDate = widget.selectedDate;
      selected = true;
    }else{
      selectedDate = DateTime(DateTime.now().year - 11, DateTime.now().month, DateTime.now().day);
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryRed, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.lightBlack, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.primaryRed, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: selectedDate!, // Refer step 1
      firstDate: DateTime(DateTime.now().year - 70),
      lastDate: DateTime(DateTime.now().year - 11, DateTime.now().month, DateTime.now().day),
    );
    if (picked != null) {
      setState(() {
        selected = true;
        selectedDate = picked;
        selectedTextDate = DateFormat("dd/MM/yyyy").format(selectedDate!);
        widget.onPicked!(selectedDate, selectedTextDate);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: widget.height??40,
        width: widget.width,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp))
        ),
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(child: Text(selected ? DateFormat("dd/MM/yyyy").format(selectedDate!) : widget.label, style: TextStyle(fontFamily: "GothamRegular", fontSize: 16.sp, color: selected ? AppColors.lightBlack : const Color(0xFF919191)))),
            Icon(Icons.calendar_today_rounded, color: AppColors.lightBlack, size: 26.sp,)
          ],
        ),
      ),
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        _selectDate(context);
      },
    );
  }
}
