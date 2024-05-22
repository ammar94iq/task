import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../task/task_list_screen.dart';
import 'sign_up.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();

    void redirect() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const TaskListScreen(),
        ),
      );
    }

    void showError(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("images/bg4.jpg"),
              ),
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 20.0),
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.7),
                  radius: 80,
                  child: Image.asset("images/logo.png"),
                ),
                const SizedBox(height: 50.0),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: authProvider.email,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: authProvider.password,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                const SizedBox(height: 50.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.withOpacity(0.7),
                  ),
                  onPressed: () async {
                    await authProvider.logIn();
                    if (authProvider.resultMessage == 'success') {
                      var model =
                          Provider.of<TaskProvider>(context, listen: false);
                      await model.showMyTasks();
                      redirect();
                    } else if (authProvider.resultMessage == 'failed') {
                      showError('Log In failed. email or Password Is Wrong');
                    } else {
                      showError('All Fields Must Be Filled In');
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 50.0),
                Row(
                  children: [
                    const Text(
                      "I don't have an account",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) {
                              return const SignUp();
                            }),
                          ),
                        );
                      },
                      child: const Text(
                        'Create Now',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
