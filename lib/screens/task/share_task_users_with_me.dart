import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import 'add_task_screen.dart';

class ShareTaskUsersWithMe extends StatelessWidget {
  const ShareTaskUsersWithMe({super.key});

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.5),
        title: const Text('Users Share'),
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
            await model.showAllShareTasksWithMe();
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
                    'All Users Task Share',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) => taskProvider
                        .shareTasksUsers.isEmpty
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
                        itemCount: taskProvider.shareTasksUsers.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.shareTasksUsers[index];

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
                                  title: const Text('Share By'),
                                  subtitle: Text(task['shareByName']),
                                ),
                                ListTile(
                                  isThreeLine: true,
                                  title: const Text('Task Title'),
                                  subtitle: Text(task['title']),
                                ),
                                ListTile(
                                  isThreeLine: true,
                                  title: const Text('Task Description'),
                                  subtitle: Text(task['description']),
                                ),
                                ListTile(
                                  isThreeLine: true,
                                  title: const Text('Task Priority'),
                                  subtitle: Text(priority),
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
