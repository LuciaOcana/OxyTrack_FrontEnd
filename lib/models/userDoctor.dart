// userDoctor.dart

class UserDoctorModel {
  final String username;
  final String email;
  final String name;
  final String lastname;
  final String password;

  UserDoctorModel({
    required this.username,
    required this.email,
    required this.name,
    required this.lastname,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'name': name,
      'lastname': lastname,
      'password': password
    };
  }

  factory UserDoctorModel.fromJson(Map<String, dynamic> json) {
    return UserDoctorModel(
      username: json['username'],
      email: json['email'],
      name: json['name'],
      lastname: json['lastname'],
      password: json['password'],
    );
  }
}
