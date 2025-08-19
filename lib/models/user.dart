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
  String _doctor;
  String _password;

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
    String? doctor,
    required String password,
  })  : _username = username,
        _email = email,
        _name = name,
        _lastname = lastname,
        _birthDate = birthDate,
        _age = age ?? _calculateAge(birthDate),
        _height = height,
        _weight = weight,
        _medication = medication ?? [],
        _doctor = doctor ?? '',
        _password = password;

  /// 🔄 Calcula la edad como String
  static String _calculateAge(String birthDateStr) {
    try {
      final birthDate = DateTime.parse(birthDateStr);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return ''; // Por si la fecha está mal
    }
  }

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
  String? get doctor => _doctor;
  String get password => _password;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      birthDate: json['birthDate'] ?? '',
      age: json['age']?.toString(), // ⬅️ asegúrate de que sea String
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      medication: List<String>.from(json['medication'] ?? []),
      doctor: json['doctor']?.toString(), 
      password: json['password'] ?? '',
    );
  }

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
      'doctor': _doctor,
      'password': _password,
    };
  }
}
