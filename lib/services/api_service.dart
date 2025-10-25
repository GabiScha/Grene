// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class TokenExpiredException implements Exception {
  final String message;
  TokenExpiredException([this.message = "Token expirado"]);

  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api"; //web
//  static const String baseUrl = "http://10.0.2.2:8000/api"; //Android

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

  static Future<String?> getToken() async {
    return await StorageService.getAccessToken();
  }

  static Future<String?> getRefreshToken() async {
    return await StorageService.getRefreshToken();
  }

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

  /// Função genérica para requisições com refresh automático
  static Future<http.Response> request(
    Uri uri, {
    String method = "GET",
    Map<String, String>? headers,
    dynamic body,
  }) async {
    String? token = await getToken();

    headers ??= {};
    if (token != null) headers["Authorization"] = "Bearer $token";
    if (body != null) headers["Content-Type"] = "application/json";

    http.Response response;

    switch (method.toUpperCase()) {
      case "GET":
        response = await http.get(uri, headers: headers);
        break;
      case "POST":
        response = await http.post(uri, headers: headers, body: jsonEncode(body));
        break;
      case "PUT":
        response = await http.put(uri, headers: headers, body: jsonEncode(body));
        break;
      case "PATCH":
        response = await http.patch(uri, headers: headers, body: jsonEncode(body));
        break;
      case "DELETE":
        response = await http.delete(uri, headers: headers);
        break;
      default:
        response = await http.get(uri, headers: headers);
    }

    // 🔹 Se token expirou (401) ou proibido (403)
    if ([401, 403].contains(response.statusCode)) {
      final refreshed = await refreshToken();
      if (refreshed) {
        token = await getToken();
        if (token != null) headers["Authorization"] = "Bearer $token";
        print("TOKEN [$token]");
        // refazer a requisição
        switch (method.toUpperCase()) {
          case "GET":
            response = await http.get(uri, headers: headers);
            break;
          case "POST":
            response = await http.post(uri, headers: headers, body: jsonEncode(body));
            break;
          case "PUT":
            response = await http.put(uri, headers: headers, body: jsonEncode(body));
            break;
          case "PATCH":
            response = await http.patch(uri, headers: headers, body: jsonEncode(body));
            break;
          case "DELETE":
            response = await http.delete(uri, headers: headers);
            break;
          default:
            response = await http.get(uri, headers: headers);
        }
      } else {
        // 🔹 Refresh falhou → limpar tokens e lançar exceção
        await StorageService.clearTokens();
        throw TokenExpiredException(); // lança exceção personalizada
      }
    }

    return response;
  }

  // Helpers
  static Future<http.Response> get(String endpoint) async {
    return await request(Uri.parse("$baseUrl/$endpoint"));
  }

  static Future<http.Response> post(String endpoint, dynamic body) async {
    return await request(Uri.parse("$baseUrl/$endpoint"), method: "POST", body: body);
  }

  static Future<http.Response> put(String endpoint, dynamic body) async {
    return await request(Uri.parse("$baseUrl/$endpoint"), method: "PUT", body: body);
  }

  static Future<http.Response> patch(String endpoint, dynamic body) async {
    return await request(Uri.parse("$baseUrl/$endpoint"), method: "PATCH", body: body);
  }

  static Future<http.Response> delete(String endpoint) async {
    return await request(Uri.parse("$baseUrl/$endpoint"), method: "DELETE");
  }
}
