import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myraid_demo/providers/auth_provider.dart';
import 'package:myraid_demo/screens/auth/signup_screen.dart';
import 'package:myraid_demo/utils/custom_widgets/custom_button.dart';
import 'package:myraid_demo/utils/custom_widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../utils/padding.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();
final TextEditingController email = TextEditingController();
final TextEditingController pass = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return Form(
              key: formKey,
              child: ListView(
                padding: CustomPadding.defaultPadding,
                children: [
                  CustomPadding.blankHeight(60.h),
                  Image.asset(
                    'assets/images/logo.png',
                  ),
                  CustomPadding.blankHeight(40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        /*'WELCOME \n */
                        'LOGIN',
                        style: TextStyle(
                            color: AppColors.subTextColor,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  CustomPadding.blankHeight(80.h),
                  CustomTextFormField(
                    controller: email,
                    hint: 'Email',
                  ),
                  CustomPadding.blankHeight(20.h),
                  CustomTextFormField(
                    controller: pass,
                    hint: 'Password',
                  ),
                  CustomPadding.blankHeight(10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Forgot password tapped");
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: AppColors.subTextColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomPadding.blankHeight(70.h),
                  CustomButton(
                      onTap: () async {
                        if (validateForm(formKey)) {
                          await provider.loginUser(
                              email: email.text,
                              password: pass.text,
                              context: context);
                        }
                      },
                      btnText: 'LOGIN'),
                  CustomPadding.blankHeight(40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                        },
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                            color: AppColors.subTextColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
