import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myraid_demo/themes/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String btnText;
  const CustomButton({super.key, required this.onTap, required this.btnText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10.h)),
        child: Center(
            child: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        )),
      ),
    );
  }
}
