// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api"; //web
//  static const String baseUrl = "http://10.0.2.2:8000/api"; //Android


  /// Realiza login do usuário e salva tokens localmente
  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/autenticar/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await StorageService.saveTokens(data["access"], data["refresh"]);
      return true;
    }
    return false;
  }

  /// Retorna o access token salvo
  static Future<String?> getToken() async {
    return await StorageService.getAccessToken();
  }

  /// Retorna o refresh token salvo
  static Future<String?> getRefreshToken() async {
    return await StorageService.getRefreshToken();
  }

  /// Tenta renovar o access token usando o refresh token
  static Future<bool> refreshToken() async {
    final refresh = await getRefreshToken();
    if (refresh == null) return false;

    final response = await http.post(
      Uri.parse("$baseUrl/autenticar/refresh/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refresh": refresh}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccess = data["access"];
      final newRefresh = data["refresh"] ?? refresh;
      await StorageService.saveTokens(newAccess, newRefresh);
      return true;
    }
    return false;
  }

  /// Função genérica para requisições GET/POST com refresh automático
  static Future<http.Response> request(
    Uri uri, {
    String method = "GET",
    Map<String, String>? headers,
    dynamic body,
  }) async {
    String? token = await getToken();

    headers ??= {};
    headers["Authorization"] = "Bearer $token";
    if (body != null) headers["Content-Type"] = "application/json";

    http.Response response;
    if (method == "GET") {
      response = await http.get(uri, headers: headers);
    } else {
      response = await http.post(uri, headers: headers, body: jsonEncode(body));
    }

    // Se der 401/403/404, tenta refresh
    if ([401, 403, 404].contains(response.statusCode)) {
      final refreshed = await refreshToken();
      if (refreshed) {
        token = await getToken();
        headers["Authorization"] = "Bearer $token";

        if (method == "GET") {
          response = await http.get(uri, headers: headers);
        } else {
          response = await http.post(uri, headers: headers, body: jsonEncode(body));
        }
      }
    }

    return response;
  }

  /// GET usando a função genérica
  static Future<http.Response> get(String endpoint) async {
    return await request(Uri.parse("$baseUrl/$endpoint"));
  }

  /// POST usando a função genérica
  static Future<http.Response> post(String endpoint, dynamic body) async {
    return await request(Uri.parse("$baseUrl/$endpoint"), method: "POST", body: body);
  }
}
