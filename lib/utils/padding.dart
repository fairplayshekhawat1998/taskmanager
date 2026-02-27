import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPadding {
  static EdgeInsets defaultPadding =
      EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w);

  static SizedBox blankHeight(double height) {
    return SizedBox(
      height: height,
    );
  }
}

bool validateForm(GlobalKey<FormState> key) {
  if (key.currentState!.validate()) {
    return true;
  } else {
    return false;
  }
}

showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}
