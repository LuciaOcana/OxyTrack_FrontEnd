import 'package:oxytrack_frontend/models/user.dart';
import 'package:dio/dio.dart';

class UserServices {
  final String baseUrl = "http://192.168.1.46:5000/api/users"; // Para Android Emulator
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

  //usuarios paginados
  Future<List<UserModel>> getUsers(
      {int page = 1, int limit = 20, bool connectedOnly = false}) async {
    try {
        // Obtener usuarios con paginación
        print('Obteniendo usuarios desde el backend con paginación');
        var res = await dio.get('$baseUrl/getUser/$page/$limit');
         final List<dynamic> responseData = res.data['users'];
        // Convertir los datos en una lista de objetos UserModel
        print("🔍 Respuesta completa del servidor: ${res.data}");

        return responseData.map((data) => UserModel.fromJson(data)).toList();
        } catch (e) {
      print("Error al obtener usuarios: $e");
      throw e;
    }
  }

    Map<String, dynamic> logInJson(logIn) => {
        'username': logIn.username,
        'password': logIn.password,
      };
}
