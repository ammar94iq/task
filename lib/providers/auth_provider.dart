import 'package:flutter/material.dart';

import '../main.dart';
import 'crud.dart';
import 'links.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final Crud _crud = Crud();
  String resultMessage = '';

  Future<void> register() async {
    if (name.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty) {
      final responseBody = await _crud.postRequest(linkRegister, {
        "name": name.text,
        "email": email.text,
        "password": password.text,
      });
      if (responseBody['status'] == 'success') {
        var lastId = responseBody['lastId'];
        resultMessage = responseBody['status'];
        await sharedPre.setString("userName", name.text);
        await sharedPre.setString("userEmail", email.text);
        await sharedPre.setString("userId", lastId.toString());
      } else {
        resultMessage = responseBody['status'];
      }
    } else {
      resultMessage = "empty";
    }
  }

  Future<void> logIn() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      final responseBody = await _crud.postRequest(linkLogin, {
        "email": email.text,
        "password": password.text,
      });

      if (responseBody['status'] == 'success') {
        var data = responseBody['data'][0];
        resultMessage = responseBody['status'];
        await sharedPre.setString("userName", data['name']);
        await sharedPre.setString("userEmail", data['email']);
        await sharedPre.setString("userId", data['id'].toString());
      } else {
        resultMessage = responseBody['status'];
      }
    } else {
      resultMessage = "empty";
    }
  }
}
