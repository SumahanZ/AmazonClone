import 'package:amazon_app/models/responses/user.dart';
import 'package:flutter/material.dart';

class UserNotifier with ChangeNotifier {
  User _user = User(id: "", name: "", password: "", address: "", type: "", token: "", cart: []);

  User get user => _user;

  set setUser(String userJSON) {
    _user = User.fromJson(userJSON);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}