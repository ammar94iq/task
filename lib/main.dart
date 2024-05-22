import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'screens/auth/sign_in.dart';
import 'screens/task/task_list_screen.dart';

late SharedPreferences sharedPre;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPre = await SharedPreferences.getInstance();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: sharedPre.getString("userId") != null
            ? const TaskListScreen()
            : const SignIn(),
      ),
    );
  }
}
