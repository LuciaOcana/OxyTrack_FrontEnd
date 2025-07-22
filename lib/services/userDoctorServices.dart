// lib/services/userDoctorServices.dart

import 'package:dio/dio.dart';
import 'package:oxytrack_frontend/models/userDoctor.dart';

class UserDoctorServices {
final String baseUrl = "http://192.168.1.66:5000/api/doctors"; // Para Android Emulator
  //final String baseUrl = "http://10.0.2.2:5000/api/users"; // Para Android Emulator
    //*final String baseUrl = "http://0.0.0.0:5000/api/users"; // Para Android Emulator

   final Dio dio = Dio(BaseOptions(
    validateStatus: (status) => status! < 500,
    followRedirects: true,
    maxRedirects: 5,
  ));

  // Crear doctor
  /*Future<int> createDoctor(UserDoctorModel newDoctor) async {
    try {
      Response response = await dio.post(
        '$baseUrl/doctorRegister',
        data: newDoctor.toJson(),
      );


      print('Respuesta completa del servidor: ${response.data}');
      print('Respuesta del servidor: ${response.statusCode}');
      if (response.statusCode == 201) {
        print('Doctor creado.');
        return 201;
      } else {
        print('Error en creación: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Excepción en creación: $e');
      return -1;
    }
  }*/

  // Login de doctor
  Future<int> logInDoctor(logInDoctor) async {
    try {
      print('Enviando solicitud de LogIn Doctor');
      Response response = await dio.post(
        '$baseUrl/doctorLogin',
        data: logInDoctorJson(logInDoctor)
      );

      if (response.statusCode == 200) {
        return 200;
      } else {
        print('Error en logInDoctor: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Error en logInDoctor: $e');
      return -1;
    }
  }

   Map<String, dynamic> logInDoctorJson(logInDoctor) => {
        'username': logInDoctor.username,
        'password': logInDoctor.password,
      };
}
