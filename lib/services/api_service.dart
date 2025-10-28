//============================================================
// ARQUIVO: services/api_service.dart
//============================================================
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

//------------------------------------------------------------
// <TokenExpiredException>
// -- Propósito: Exceção customizada lançada quando o 'refresh token'
//   falha ou expira, forçando o logout.
//------------------------------------------------------------
class TokenExpiredException implements Exception {
  final String message;
  TokenExpiredException([this.message = "Token expirado"]);

  @override
  String toString() => message;
}

//------------------------------------------------------------
// <ApiService>
// -- Propósito: Classe estática central para todas as comunicações
//   com a API backend.
// -- Features:
//   -> Gerenciamento de tokens (login, refresh).
//   -> Lógica de 'Retry' automático com 'refresh token'.
//   -> Métodos helper (get, post, etc.)
//------------------------------------------------------------
class ApiService {
  //-- URL Base da API --
  static const String baseUrl = "http://127.0.0.1:8000/api"; //web
//  static const String baseUrl = "http://10.0.2.2:8000/api"; //Android

  //------------------------------------------------------------
  // <login>
  // -- Descrição: Autentica o usuário e salva os tokens (access, refresh).
  // -- Retorno: <bool> -> true se sucesso.
  //------------------------------------------------------------
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

  //------------------------------------------------------------
  // <getToken> / <getRefreshToken>
  // -- Descrição: Helpers para buscar os tokens do <StorageService>.
  //------------------------------------------------------------
  static Future<String?> getToken() async {
    return await StorageService.getAccessToken();
  }

  static Future<String?> getRefreshToken() async {
    return await StorageService.getRefreshToken();
  }

  //------------------------------------------------------------
  // <refreshToken>
  // -- Descrição: Tenta obter um novo 'access token' usando o 'refresh token'.
  // -- Retorno: <bool> -> true se a renovação foi bem-sucedida.
  //------------------------------------------------------------
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
      final newRefresh = data["refresh"] ?? refresh; // Reusa o refresh antigo se um novo não for enviado
      await StorageService.saveTokens(newAccess, newRefresh);
      return true;
    }
    return false;
  }

  //------------------------------------------------------------
  // <request> (Método Principal)
  // -- Descrição: Função genérica para executar requisições (GET, POST, etc.).
  // -- Lógica de Refresh:
  //   1. Tenta a requisição com o token atual.
  //   2. Se falhar (401/403), chama <refreshToken>.
  //   3. Se <refreshToken> funcionar, repete a requisição original.
  //   4. Se <refreshToken> falhar, lança <TokenExpiredException>.
  //------------------------------------------------------------
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

    //-- Executa a requisição HTTP --
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
      final refreshed = await refreshToken(); // Tenta renovar
      
      if (refreshed) {
        //-- SUCESSO NO REFRESH: Repete a requisição --
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

  //------------------------------------------------------------
  // <Helpers: get, post, put, patch, delete>
  // -- Descrição: Atalhos para o método <request>.
  //------------------------------------------------------------
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