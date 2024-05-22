import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();

    var model = Provider.of<TaskProvider>(context);
    void showError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    //Selected Date
    DateTime dateTime = DateTime.parse(model.taskDate.toString());
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("images/bg4.jpg"),
          ),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Text(
              'Title',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: model.title,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.title),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: model.description,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.title),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Task Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: model.taskDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != model.taskDate) {
                  model.selectTaskDate(pickedDate);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(
                    formattedDate,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Task Time',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: model.taskTime,
                );
                if (pickedTime != null && pickedTime != model.taskTime) {
                  model.selectTaskTime(pickedTime);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: Text(
                    model.formattedTime,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Priority',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: DropdownButton<String>(
                value: model.taskPriority,
                onChanged: (newValue) {
                  model.selectTaskPriority(newValue);
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: '1',
                    child: Text('low'),
                  ),
                  DropdownMenuItem<String>(
                    value: '2',
                    child: Text('medium'),
                  ),
                  DropdownMenuItem<String>(
                    value: '3',
                    child: Text('high'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white),
              onPressed: () async {
                await model.insertMyTask();
                if (model.resultMessage == 'success') {
                  await model.showMyTasks();

                  showError('Your Task Added With Successfully');
                } else if (authProvider.resultMessage == 'failed') {
                  showError('Failed To Add Your Task');
                } else {
                  showError('All Fields Must Be Filled In');
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
