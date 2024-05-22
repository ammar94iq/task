import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import 'edit_task_screen.dart';
import 'share_task_users.dart';

class TaskNotifications extends StatelessWidget {
  const TaskNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    void showError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    void redirectTaskUsers(String taskId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShareTaskUsers(taskId: taskId),
        ),
      );
    }

    void redirect(String taskId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditTaskScreen(taskId: taskId),
        ),
      );
    }

    var model = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.5),
        title: const Text('Notifications'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("images/bg4.jpg"),
          ),
        ),
        child: RefreshIndicator(
          backgroundColor: Colors.red.withOpacity(0.5),
          color: Colors.white,
          onRefresh: () async {
            await model.showMyNotificationsTasks();
          },
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'These Tasks Will End Tomorrow',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) => taskProvider
                        .myNotificationsTask.isEmpty
                    ? Column(
                        children: [
                          Image.asset(
                            "images/not_found2.png",
                            fit: BoxFit.fill,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15.0),
                            margin:
                                const EdgeInsets.only(bottom: 10.0, top: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              taskProvider.resultMessage,
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: taskProvider.myNotificationsTask.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.myNotificationsTask[index];

                          String priority = task['priority'] == '1'
                              ? 'low'
                              : task['priority'] == '2'
                                  ? 'medium'
                                  : 'high';

                          DateTime dateTime = DateTime.parse(task['taskDate']);
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(dateTime);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  isThreeLine: true,
                                  title: const Text('Task Title'),
                                  subtitle: Text(task['title']),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await taskProvider
                                          .viewTask(task['id'].toString());
                                      redirect(task['id'].toString());
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  isThreeLine: true,
                                  title: const Text('Task Description'),
                                  subtitle: Text(task['description']),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await taskProvider
                                          .deleteTask(task['id'].toString());
                                      if (taskProvider.resultMessage ==
                                          'success') {
                                        showError('Delete Task Successfully');
                                        taskProvider.showMyTasks();
                                      } else {
                                        showError('Failed To Delete Task');
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  isThreeLine: true,
                                  title: const Text('Task Priority'),
                                  subtitle: Text(priority),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await taskProvider.showAllUsers();
                                      redirectTaskUsers(task['id'].toString());
                                    },
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(formattedDate),
                                  subtitle: Text(task['taskTime']),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await taskProvider.completeMyTask(
                                          task['id'].toString());
                                    },
                                    icon: task['status'] == 1
                                        ? const Icon(
                                            Icons.check_box,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.check_box_outline_blank,
                                            color: Colors.amber,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
