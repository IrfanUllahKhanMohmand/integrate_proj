import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int _userId = 0;

  get userId => _userId;

  void set(int id) {
    _userId = id;
    notifyListeners();
  }
}
