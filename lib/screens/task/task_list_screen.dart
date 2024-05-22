import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/task_provider.dart';
import '../auth/sign_in.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'notifications.dart';
import 'share_task_users.dart';
import 'share_task_users_with_me.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void showError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    void redirect(String taskId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditTaskScreen(taskId: taskId),
        ),
      );
    }

    void redirectTaskNotifications() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const TaskNotifications(),
        ),
      );
    }

    void redirectTaskUsers(String taskId) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShareTaskUsers(taskId: taskId),
        ),
      );
    }

    void redirectUsersShare() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ShareTaskUsersWithMe(),
        ),
      );
    }

    var model = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.5),
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () async {
              await model.showMyNotificationsTasks();
              redirectTaskNotifications();
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 196, 193, 193)
                      .withOpacity(0.7)),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('images/bg4.jpg'),
              ),
              accountName: Text(sharedPre.getString("userName").toString()),
              accountEmail: Text(sharedPre.getString("userEmail").toString()),
            ),
            ListTile(
              leading: const Icon(Icons.work_rounded),
              iconColor: Colors.white,
              title: const Text('Users share'),
              textColor: Colors.white,
              onTap: () async {
                await model.showAllShareTasksWithMe();
                redirectUsersShare();
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              iconColor: Colors.white,
              title: const Text('Privacy policy'),
              textColor: Colors.white,
              onTap: () => debugPrint(''),
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              iconColor: Colors.white,
              title: const Text('Terms of use'),
              textColor: Colors.white,
              onTap: () => debugPrint(''),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              iconColor: Colors.white,
              title: const Text('Log Out'),
              textColor: Colors.white,
              onTap: () {
                sharedPre.clear();
                model.myTask.clear();
                model.allUsers.clear();
                model.shareTasksUsers.clear();
                model.myNotificationsTask.clear();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: ((context) {
                      return const SignIn();
                    }),
                  ),
                );
              },
            ),
          ],
        ),
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
          backgroundColor: Colors.blue.withOpacity(0.5),
          color: Colors.white,
          onRefresh: () async {
            await model.showMyTasks();
          },
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'All My Tasks',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) => taskProvider
                        .myTask.isEmpty
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
                        itemCount: taskProvider.myTask.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.myTask[index];

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
                              border: Border.all(color: Colors.blue),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) {
                return const AddTaskScreen();
              }),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
