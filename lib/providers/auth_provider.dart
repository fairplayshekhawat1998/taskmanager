import 'package:flutter/material.dart';
import 'package:myraid_demo/modal_classes/user.dart';
import 'package:myraid_demo/service/api_services.dart';
import 'package:myraid_demo/utils/padding.dart';

import '../screens/home/home_screen.dart';

class AuthProvider extends ChangeNotifier {
  Future<List<User>> getUsers(BuildContext context) async {
    List<User> userList = [];

    try {
      var resp = await ApiService.getRequest('/users', context, true);

      userList = (resp as List).map((task) => User.fromJson(task)).toList();
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return userList;
  }

  Future createUser(
      {required BuildContext context,
      required String name,
      required String password,
      required String email}) async {
    List<User> users = await getUsers(context);
    if (users.any(
      (element) => element.email == email,
    )) {
      showSnackBar(context, 'Email already registered.');
    } else {
      var body = {
        "name": name,
        "email": email,
        "password": password,
      };
      var response = await ApiService.postRequest('users', body, context);
      debugPrint('addUserResponse $response');
    }
  }

  Future loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      var resp = await ApiService.getRequest(
          '/users?email=$email&password=$password', context, true);
      if (resp != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(),));

      }else{

      }
    } catch (e) {
      showSnackBar(context, 'Incorrect email or password.');
    }
  }
}
