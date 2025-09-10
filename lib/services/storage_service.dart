// storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";

  static const String _favoritesKey = "favorites";
  static const String _groupsKey = "groups"; 

  static const String _themeKey = "is_dark_theme"; // 🔹 novo

  // ---------------------------
  // Tokens
  // ---------------------------
  static Future<void> saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, access);
    await prefs.setString(_refreshTokenKey, refresh);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  // ---------------------------
  // Tema
  // ---------------------------
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // false = claro padrão
  }

  // ---------------------------
  // Favoritos
  // ---------------------------
  static Future<void> toggleFavorite(String plantaId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    if (favorites.contains(plantaId)) {
      favorites.remove(plantaId);
    } else {
      favorites.add(plantaId);
    }

    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<bool> isFavorite(String plantaId) async {
    final favorites = await getFavorites();
    return favorites.contains(plantaId);
  }

  // ---------------------------
  // Grupos
  // ---------------------------
  static Future<List<String>> getAllGroups() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_groupsKey) ?? [];
  }

  static Future<void> createGroup(String groupName) async {
    final prefs = await SharedPreferences.getInstance();
    final groups = prefs.getStringList(_groupsKey) ?? [];

    if (!groups.contains(groupName)) {
      groups.add(groupName);
      await prefs.setStringList(_groupsKey, groups);
    }
  }

  static Future<void> deleteGroup(String groupName) async {
    final prefs = await SharedPreferences.getInstance();
    final groups = prefs.getStringList(_groupsKey) ?? [];
    groups.remove(groupName);
    await prefs.setStringList(_groupsKey, groups);

    // remove também plantas associadas a esse grupo
    await prefs.remove("group_$groupName");
  }

  static Future<void> addToGroup(String groupName, String plantaId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "group_$groupName";
    final plantas = prefs.getStringList(key) ?? [];

    if (!plantas.contains(plantaId)) {
      plantas.add(plantaId);
      await prefs.setStringList(key, plantas);
    }
  }

  static Future<void> removeFromGroup(String groupName, String plantaId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "group_$groupName";
    final plantas = prefs.getStringList(key) ?? [];

    plantas.remove(plantaId);
    await prefs.setStringList(key, plantas);
  }

  static Future<List<String>> getGroupPlants(String groupName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("group_$groupName") ?? [];
  }
}
