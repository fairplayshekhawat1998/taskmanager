import 'package:flutter/material.dart';
import 'package:myraid_demo/providers/auth_provider.dart';
import 'package:myraid_demo/providers/task_provider.dart';
import 'package:myraid_demo/screens/auth/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myraid_demo/screens/auth/signup_screen.dart';
import 'package:myraid_demo/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScreenUtilInit(
        designSize: size,
        minTextAdapt: true,
        splitScreenMode: true,
        child: const MaterialApp(
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          title: 'Task Manager',
          home: LoginScreen(),
        ));
  }
}
