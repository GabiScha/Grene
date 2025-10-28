//============================================================
// ARQUIVO: services/storage_service.dart
//============================================================
import 'package:shared_preferences/shared_preferences.dart';

//------------------------------------------------------------
// <StorageService>
// -- Propósito: Gerencia o armazenamento local persistente (SharedPreferences).
// -- Responsabilidades:
//   -> Salvar/Ler/Limpar Tokens de Autenticação.
//   -> Salvar/Ler Preferência de Tema (Dark/Light).
//------------------------------------------------------------
class StorageService {
  //-- Chaves de Armazenamento --
  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";

  static const String _themeKey = "is_dark_theme";
  
  // ---------------------------
  // <TÓPICO: Tokens>
  // ---------------------------
  
  //-- Salva ambos os tokens no storage --
  static Future<void> saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, access);
    await prefs.setString(_refreshTokenKey, refresh);
  }

  //-- Lê o Access Token --
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  //-- Lê o Refresh Token --
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  //-- Remove ambos os tokens (usado no Logout ou Exceção) --
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  // ---------------------------
  // <TÓPICO: Tema>
  // ---------------------------
  
  //-- Salva a preferência de tema (true = Dark) --
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  //-- Lê a preferência de tema (Padrão: false = Light) --
  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // false = claro padrão
  }
}