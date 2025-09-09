// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço responsável por autenticação e gerenciamento de tokens.
/// Centraliza o login e o armazenamento de tokens em [SharedPreferences].
class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  /// Realiza login do usuário e salva o accessToken e refreshToken localmente.
  ///
  /// Retorna `true` se o login foi bem-sucedido, `false` caso contrário.
  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/autenticar/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken", data["access"]);
      await prefs.setString("refreshToken", data["refresh"]);
      return true;
    } else {
      return false;
    }
  }

  /// Recupera o token salvo no [SharedPreferences].
  ///
  /// Retorna `null` se o usuário não estiver autenticado.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }
}
