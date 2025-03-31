import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String _username;
  String _email;
  String _name;
  String _lastname;
  String _birthDate;
  String? _age;
  String _height;
  String _weight;
  List<String> _medication;
  String _password;

  // Constructor
  UserModel({
    required String username,
    required String email,
    required String name,
    required String lastname,
    required String birthDate,
    String? age,
    required String height,
    required String weight,
    List<String>? medication,
    required String password,
  })  : _username = username,
        _email = email,
        _name = name,
        _lastname = lastname,
        _birthDate = birthDate,
        _age = age,
        _height = height,
        _weight = weight,
        _medication = medication ?? [],
        _password = password;

  // Getters
  String get username => _username;
  String get email => _email;
  String get name => _name;
  String get lastname => _lastname;
  String get birthDate => _birthDate;
  String? get age => _age;
  String get height => _height;
  String get weight => _weight;
  List<String> get medication => _medication;
  String get password => _password;

  // Método para actualizar el usuario
  void updateUser({
    required String username,
    required String email,
    required String name,
    required String lastname,
    required String birthDate,
    String? age,
    required String height,
    required String weight,
    List<String>? medication,
    required String password,
  }) {
    _username = username;
    _email = email;
    _name = name;
    _lastname = lastname;
    _birthDate = birthDate;
    _age = age;
    _height = height;
    _weight = weight;
    _medication = medication ?? [];
    _password = password;

    notifyListeners();
  }

  // Método fromJson para crear una instancia desde un Map (JSON)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      birthDate: json['birthDate'] ?? '',
      age: json['age'],
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      medication: List<String>.from(json['medication'] ?? []),
      password: json['password'] ?? '',
    );
  }

  // Método toJson para convertir la instancia en un Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'username': _username,
      'email': _email,
      'name': _name,
      'lastname': _lastname,
      'birthDate': _birthDate,
      'age': _age,
      'height': _height,
      'weight': _weight,
      'medication': _medication,
      'password': _password,
    };
  }
}
