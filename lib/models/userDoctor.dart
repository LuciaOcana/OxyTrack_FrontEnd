// ======================================================
// UserDoctorModel: Modelo de Doctor
// Maneja: datos de login, pacientes asignados y serialización JSON
// ======================================================

class UserDoctorModel {
  // ------------------------------
  // Campos del modelo
  // ------------------------------
  final String username;
  final String email;
  final String name;
  final String lastname;
  final List<String> patients; // Lista de pacientes asignados
  final String password;

  // ------------------------------
  // Constructor
  // ------------------------------
  UserDoctorModel({
    required this.username,
    required this.email,
    required this.name,
    required this.lastname,
    List<String>? patients, // opcional
    required this.password,
  }) : patients = patients ?? []; // si no se pasa, lista vacía

  // ------------------------------
  // Serialización a JSON
  // ------------------------------
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'name': name,
      'lastname': lastname,
      'patients': patients,
      'password': password,
    };
  }

  // ------------------------------
  // Creación desde JSON
  // ------------------------------
  factory UserDoctorModel.fromJson(Map<String, dynamic> json) {
    return UserDoctorModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      patients: json['patients'] != null
          ? List<String>.from(json['patients'])
          : [],
      password: json['password'] ?? '',
    );
  }
}
