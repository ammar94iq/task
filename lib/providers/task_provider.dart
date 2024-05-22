import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import 'crud.dart';
import 'links.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider() {
    showMyTasks();
  }
  final Crud _crud = Crud();
  bool loading = false;
  String resultMessage = '';

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  DateTime? taskDate = DateTime.now();
  String formattedDate = '';
  void selectTaskDate(DateTime? date) {
    taskDate = date;

    DateTime dateTime = DateTime.parse(taskDate.toString());
    formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    notifyListeners();
  }

  TimeOfDay taskTime = TimeOfDay.now();
  String formattedTime = '';
  void selectTaskTime(TimeOfDay time) {
    taskTime = time;
    //Selected Time
    String dbTimeString = taskTime.toString();
    String timeString = dbTimeString.replaceAll(
        RegExp(r'TimeOfDay\(|\)'), ''); // Extracts '15:43'
    List<String> timeParts = timeString.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);
    formattedTime =
        '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';

    notifyListeners();
  }

  String? taskPriority = '1';
  void selectTaskPriority(String? priority) {
    taskPriority = priority;
    notifyListeners();
  }

  //Start Insert Task
  Future<void> insertMyTask() async {
    if (title.text.isNotEmpty &&
        description.text.isNotEmpty &&
        taskPriority!.isNotEmpty &&
        taskDate != null) {
      final responseBody = await _crud.postRequest(insertTask, {
        "userId": sharedPre.getString("userId"),
        "title": title.text,
        "description": description.text,
        "taskDate": taskDate.toString(),
        "taskTime": formattedTime.toString(),
        "taskPriority": taskPriority,
      });
      if (responseBody['status'] == 'success') {
        title.text = '';
        description.text = '';
      }
      resultMessage = responseBody['status'];
    } else {
      resultMessage = "empty";
    }
    notifyListeners();
  }
  //End Insert Task

  //Start Update Task
  Future<void> updateMyTask(String taskId) async {
    if (title.text.isNotEmpty &&
        description.text.isNotEmpty &&
        taskPriority!.isNotEmpty &&
        taskDate != null) {
      final responseBody = await _crud.postRequest(updateTask, {
        "title": title.text,
        "taskId": taskId,
        "description": description.text,
        "taskDate": taskDate.toString(),
        "taskTime": formattedTime.toString(),
        "taskPriority": taskPriority,
      });
      resultMessage = responseBody['status'];
    } else {
      resultMessage = "empty";
    }
    notifyListeners();
  }
  //End Update Task

  //Start Complete Task
  Future<void> completeMyTask(String taskId) async {
    final responseBody = await _crud.postRequest(completeTask, {
      "taskId": taskId,
    });
    if (responseBody['status'] == 'success') {
      await showMyTasks();
      await showMyNotificationsTasks();
      await showAllShareTasksWithMe();
    }

    notifyListeners();
  }
  //End Complete Task

  //Start Show My Tasks
  List<Map<String, dynamic>> myTask = [];
  Future<void> showMyTasks() async {
    loading = true;

    final responseBody = await _crud.postRequest(linkShowTasks, {
      "userId": sharedPre.getString("userId"),
    }).whenComplete(() => loading = false);

    if (responseBody['status'] == 'success') {
      myTask.clear();
      myTask.addAll(List<Map<String, dynamic>>.from(responseBody['data']));
    } else {
      myTask.clear();
      resultMessage = "There is no data on this page";
    }
    notifyListeners();
  }
  //End Show My Tasks

  //Start Show Users
  List<Map<String, dynamic>> allUsers = [];
  Future<void> showAllUsers() async {
    loading = true;

    final responseBody = await _crud.postRequest(linkShowAllUsers, {
      'userId': sharedPre.getString("userId"),
    }).whenComplete(() => loading = false);

    if (responseBody['status'] == 'success') {
      allUsers.clear();
      allUsers.addAll(List<Map<String, dynamic>>.from(responseBody['data']));
    } else {
      allUsers.clear();
      resultMessage = "There is no data on this page";
    }
    notifyListeners();
  }
  //End Show Users

  //Start Show Share Tasks For Me
  List<Map<String, dynamic>> shareTasksUsers = [];
  Future<void> showAllShareTasksWithMe() async {
    loading = true;

    final responseBody = await _crud.postRequest(linkShowAllShareTasksUsers, {
      'userId': sharedPre.getString("userId"),
    }).whenComplete(() => loading = false);

    if (responseBody['status'] == 'success') {
      shareTasksUsers.clear();
      shareTasksUsers
          .addAll(List<Map<String, dynamic>>.from(responseBody['data']));
    } else {
      shareTasksUsers.clear();
      resultMessage = "There is no data on this page";
    }
    notifyListeners();
  }
  //End Show Share Tasks For Me

  //Start Show My Notifications Task
  List<Map<String, dynamic>> myNotificationsTask = [];
  Future<void> showMyNotificationsTasks() async {
    loading = true;

    final responseBody = await _crud.postRequest(linkShowNotificationsTasks, {
      "userId": sharedPre.getString("userId"),
    }).whenComplete(() => loading = false);

    if (responseBody['status'] == 'success') {
      myNotificationsTask.clear();
      myNotificationsTask
          .addAll(List<Map<String, dynamic>>.from(responseBody['data']));
    } else {
      myNotificationsTask.clear();
      resultMessage = "There is no data on this page";
    }
    notifyListeners();
  }
  //End Show My Notifications Task

  //Start Delete Task By User
  Future<void> viewTask(String taskId) async {
    final responseBody = await _crud.postRequest(linkViewTask, {
      "taskId": taskId,
    });
    title.text = responseBody['data'][0]['title'];
    description.text = responseBody['data'][0]['description'];
    //Start Process Date
    DateTime dateTime = DateTime.parse(responseBody['data'][0]['taskDate']);
    formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    //Start Process Date

    //Start Process Time
    formattedTime = responseBody['data'][0]['taskTime'];
    List<String> timeParts = formattedTime.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    taskTime = TimeOfDay(hour: hour, minute: minute);
    taskPriority = responseBody['data'][0]['priority'].toString();
    //End Process Time

    notifyListeners();
  }
  //End Delete Task By User

  //Start Delete Task By User
  Future<void> deleteTask(String taskId) async {
    final responseBody = await _crud.postRequest(linkDeleteTask, {
      "taskId": taskId,
    });
    resultMessage = responseBody['status'];

    notifyListeners();
  }
  //End Delete Task By User

  //Start Share Task With Users
  Future<void> shareTask(String taskId, String userId) async {
    final responseBody = await _crud.postRequest(linkShareTask, {
      "userId": userId,
      "taskId": taskId,
      "shareById": sharedPre.getString("userId"),
    });
    resultMessage = responseBody['status'];

    notifyListeners();
  }
  //End Share Task With Users
}
