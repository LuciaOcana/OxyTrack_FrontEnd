import 'package:oxytrack_frontend/models/user.dart';
import 'package:dio/dio.dart';  // Importa la librería Dio


class UserServices {
  final String baseUrl = "http://localhost:5000/api/users";
  // Crear una instancia de Dio
  final Dio dio = Dio();  // Aquí está la instancia de Dio

  // Crear usuario
  Future<int> createUser(UserModel newUser) async {
    try {
      Response response = await dio.post(
        '$baseUrl/create',
        data: newUser.toJson(),
      );

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

  Future<int> logIn (logIn) async{
    try{
      print('Enviando solicitud de LogIn');
      Response response =
          await dio.post('$baseUrl/user/login', data: logInToJson(logIn));
if (response.statusCode == 200) {
        String token = response.data['token'];
        if (token == null) {
          return -1; // Si el token es null, no se puede continuar
        }
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

  Map<String, dynamic> logInToJson(logIn) {
    return {'username': logIn.username, 'password': logIn.password};
  
  }
}