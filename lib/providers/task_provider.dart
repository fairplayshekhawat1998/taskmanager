import 'package:flutter/material.dart';
import 'package:myraid_demo/modal_classes/task.dart';
import 'package:myraid_demo/service/api_services.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../themes/app_colors.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future addTask(
      {required bool isDone,
      required String description,
      required int deadline,
      required String taskName,
      required BuildContext context}) async {
    var body = {
      "isDone": isDone,
      "description": description,
      "deadline": deadline,
      "taskName": taskName
    };

    try {
      var resp = await ApiService.postRequest('/usertasks', body, context);
      debugPrint('response resp $resp');
      await refreshTasks(context);
      OverlayLoadingProgress.stop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    notifyListeners();
  }

  Future updateTask(
    Task task,
    BuildContext context,
  ) async {
    var body = {
      "isDone": task.isDone,
      "description": task.description,
      "deadline": task.deadline,
      "taskName": task.taskName
    };

    try {
      await ApiService.putRequest('/usertasks/${task.id}', body, context);
      await refreshTasks(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    notifyListeners();
  }

  Future deleteTask(String id, context) async {
    try {
      var resp = await ApiService.deleteRequest('usertasks/$id', context);
      debugPrint('deletePerformed');
      await refreshTasks(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    notifyListeners();
  }

/*  Future toggleStatus(Task task , BuildContext context , bool isDone) async{
    var body = {
      'isDone':isDone
    };
    await ApiService.putRequest('/${task.id!}', body, context);
    await refreshTasks(context);
    notifyListeners();
  }*/

  Future<void> refreshTasks(BuildContext context) async {
    try {
      var resp = await ApiService.getRequest('/usertasks', context, false);
      _tasks = (resp as List).map((task) => Task.fromJson(task)).toList();
      debugPrint('refreshAttempted $resp');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    notifyListeners();
  }


  Future<void> loadTasks(BuildContext context) async {
    try {
      var resp = await ApiService.getRequest('/usertasks', context, true);
      _tasks = (resp as List).map((task) => Task.fromJson(task)).toList();
      debugPrint('refreshAttempted $resp');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    notifyListeners();
  }

}
