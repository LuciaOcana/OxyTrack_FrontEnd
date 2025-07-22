import 'package:flutter/material.dart';

class UserAdminModel with ChangeNotifier {
  String _username;
  String _password;

  UserAdminModel({
    required String username,
    required String password,
  })  : _username = username,
        _password = password;


  // Getters
  String get username => _username;
  String get password => _password;

  factory UserAdminModel.fromJson(Map<String, dynamic> json) {
    return UserAdminModel(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': _username,
      'password': _password,
    };
  }
}
