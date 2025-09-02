import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  // 🔑 Login
  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/autenticar/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
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

  // 🔑 Pegar token salvo
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  // 🌱 Listar plantas
  static Future<List<dynamic>> getPlantas() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/plantas/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao carregar plantas");
    }
  }

  // 🪴 Criar vaso
  static Future<Map<String, dynamic>> criarVaso(String name, int plantId) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse("$baseUrl/vasos/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "name": name,
        "plant": plantId,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao criar vaso");
    }
  }
}
