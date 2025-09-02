import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grene/models/planta.dart';

class PlantaService {
final String baseUrl = "http://127.0.0.1:8000/api/plantas/";


// Pegar Plantas
  Future<List<Planta>> getPlantas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((p) => Planta.fromJson(p)).toList();
    } else {
      throw Exception("Erro ao carregar plantas: ${response.body}");
    }
  }


// Criar Planta
  Future<void> criarPlanta(String nome) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"nome": nome}),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao criar planta: ${response.body}");
    }
  }
}
