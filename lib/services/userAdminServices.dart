import 'package:oxytrack_frontend/models/userAdmin.dart';
import 'package:dio/dio.dart';
import 'package:oxytrack_frontend/models/userDoctor.dart';
import 'package:oxytrack_frontend/others/urlFile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAdminServices {
  final Dio dio = Dio(
    BaseOptions(
      validateStatus: (status) => status! < 500,
      followRedirects: true,
      maxRedirects: 5,
    ),
  );

  String? _token; // 🔐 Token en memoria

  // Método privado que asegura que el token está cargado
  Future<void> _ensureTokenInitialized() async {
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('jwt_token');
      if (_token == null) {
        // Si quieres que devuelva un error explícito, sino omite esta línea
        throw Exception("Token no encontrado, por favor loguearse");
      }
    }
  }

  // Guardar token (memoria + SharedPreferences)
  Future<void> _setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  Future<int> logIn(logIn) async {
    try {
      print('Enviando solicitud de LogIn');
      Response response = await dio.post(
        '$baseUrl/admin/logInAdmin',
        data: logInJson(logIn),
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _setToken(token); // Guarda token automáticamente
        print('TOKEN: ${token}');

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

  // Crear doctor
  Future<int> createDoctor(UserDoctorModel newDoctor) async {
    try {
      await _ensureTokenInitialized();

      Response response = await dio.post(
        '$baseUrl/admin/createDoctor',
        data: newDoctor.toJson(),
        options: Options(
          headers: {
            'Token': _token!, // 🔐 Token desde memoria
          },
        ),
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
  }

  //usuarios paginados
  Future<List<UserDoctorModel>> getDoctors({
    int page = 1,
    int limit = 20,
    bool connectedOnly = false,
  }) async {
    try {
      await _ensureTokenInitialized();

      // Obtener usuarios con paginación
      print('Obteniendo doctores desde el backend con paginación');
      var res = await dio.get(
        '$baseUrl/admin/getDoctors/$page/$limit',
        options: Options(
          headers: {
            'Token': _token!, // 🔐 Token desde memoria
          },
        ),
      );
      final List<dynamic> responseData = res.data['doctors'];
      // Convertir los datos en una lista de objetos UserModel
      print("🔍 Respuesta completa del servidor: ${res.data}");

      return responseData
          .map((data) => UserDoctorModel.fromJson(data))
          .toList();
    } catch (e) {
      print("Error al obtener doctores: $e");
      throw e;
    }
  }
}
