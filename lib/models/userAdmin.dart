// ======================================================
// UserAdminModel: Modelo de administrador
// Maneja: datos de login de admin y serialización JSON
// ======================================================

import 'package:flutter/material.dart';

class UserAdminModel with ChangeNotifier {
  // ------------------------------
  // Campos privados
  // ------------------------------
  String _username;
  String _password;

  // ------------------------------
  // Constructor
  // ------------------------------
  UserAdminModel({
    required String username,
    required String password,
  })  : _username = username,
        _password = password;

  // ------------------------------
  // Getters
  // ------------------------------
  String get username => _username;
  String get password => _password;

  // ------------------------------
  // Creación desde JSON
  // ------------------------------
  factory UserAdminModel.fromJson(Map<String, dynamic> json) {
    return UserAdminModel(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }

  // ------------------------------
  // Serialización a JSON
  // ------------------------------
  Map<String, dynamic> toJson() {
    return {
      'username': _username,
      'password': _password,
    };
  }
}
