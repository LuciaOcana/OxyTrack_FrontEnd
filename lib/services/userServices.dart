import 'package:oxytrack_frontend/models/user.dart';
import 'package:dio/dio.dart';

class UserServices {
  final String baseUrl = "http://192.168.1.58:5000/api/users"; // Para Android Emulator
  //final String baseUrl = "http://10.0.2.2:5000/api/users"; // Para Android Emulator
    //*final String baseUrl = "http://0.0.0.0:5000/api/users"; // Para Android Emulator

  final Dio dio = Dio(BaseOptions(
    validateStatus: (status) => status! < 500,
    followRedirects: true,
    maxRedirects: 5,
  ));

// Método para registrarte
  Future<int> createUser(UserModel newUser) async {
    try {
      Response response = await dio.post(
        '$baseUrl/create',
        data: newUser.toJson(),
      );
      print('Respuesta completa del servidor: ${response.data}');
      print('Respuesta del servidor: ${response.statusCode}');
      
      if (response.statusCode == 201) {
        print('Usuario creado.');
        return 201;
      } else {
        print('Error en creación: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Excepción en creación: $e');
      return -1;
    }
  }

  Future<int> logIn(logIn) async {
    try {
      print('Enviando solicitud de LogIn');
      Response response = await dio.post(
        '$baseUrl/logIn',
        data: logInJson(logIn),
      );

      if (response.statusCode == 200) {
        return 200;
      } else {
        print('Error en logIn: ${response.statusCode}');
        return response.statusCode!;
      }
    } catch (e) {
      print('Error en logIn: $e');
      return -1;
    }
  }
    Map<String, dynamic> logInJson(logIn) => {
        'username': logIn.username,
        'password': logIn.password,
      };
}
