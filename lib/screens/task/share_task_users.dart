import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';

class ShareTaskUsers extends StatelessWidget {
  final String taskId;
  const ShareTaskUsers({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    void showError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    var model = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.5),
        title: const Text('Share My Tasks'),
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
            await model.showAllUsers();
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
                    'Share My Tasks With Users',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) => taskProvider
                        .allUsers.isEmpty
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
                        itemCount: taskProvider.allUsers.length,
                        itemBuilder: (context, index) {
                          final user = taskProvider.allUsers[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title: Text(user['name']),
                              trailing: IconButton(
                                onPressed: () async {
                                  await taskProvider.shareTask(
                                      taskId, user['id'].toString());

                                  if (taskProvider.resultMessage == 'find') {
                                    showError(
                                        'This task has already been shared with this user');
                                  } else if (taskProvider.resultMessage ==
                                      'success') {
                                    showError(
                                        'The task was shared successfully');
                                  } else {
                                    showError('Task sharing failed');
                                  }
                                },
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.blue,
                                ),
                              ),
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
