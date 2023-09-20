import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _username = "";

  String get username => _username;

  set username(String value) {
    _username = value;
    notifyListeners();
  }
}
