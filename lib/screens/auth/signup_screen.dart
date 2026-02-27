import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myraid_demo/providers/auth_provider.dart';
import 'package:myraid_demo/utils/custom_widgets/custom_button.dart';
import 'package:myraid_demo/utils/custom_widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../utils/padding.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();
final TextEditingController email = TextEditingController();
final TextEditingController pass = TextEditingController();
final TextEditingController name = TextEditingController();

class _SignUpScreenState extends State<SignUpScreen> {
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
                        'SIGN UP',
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
                    controller: name,
                    hint: 'Name',
                  ),
                  CustomPadding.blankHeight(20.h),
                  CustomTextFormField(
                    controller: email,
                    hint: 'Email',
                  ),
                  CustomPadding.blankHeight(20.h),
                  CustomTextFormField(
                    controller: pass,
                    hint: 'Password',
                  ),
                  CustomPadding.blankHeight(70.h),
                  CustomButton(
                      onTap: () async {
                        if (validateForm(formKey)) {
                          await provider.createUser(
                              context: context,
                              name: name.text,
                              password: pass.text,
                              email: email.text);
                        }
                      },
                      btnText: 'Register'),
                  CustomPadding.blankHeight(40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                        },
                        child: Text(
                          "Login",
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
