import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class CustomDatePickerTheme extends StatelessWidget {
  const CustomDatePickerTheme({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: Constant.colorSelectedIndicator, // <-- SEE HERE
          onPrimary: Constant.cWhite, // <-- SEE HERE
          onSurface: Constant.cBlack, // <-- SEE HERE
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Constant.cBlack, // button text color
          ),
        ),
      ),
      child: child,
    );
  }
}
