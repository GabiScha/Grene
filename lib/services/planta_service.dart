import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planta.dart';
import 'api_service.dart';

class PlantaService {
  final String baseUrl = "http://127.0.0.1:8000/api/vasos/"; // <- vasos do usuário

  // Pega todos os vasos do usuário
  Future<List<Planta>> getPlantas() async {
    final token = await ApiService.getToken();
    if (token == null) throw Exception("Usuário não autenticado");

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((v) => Planta.fromJson(v)).toList();
    } else {
      throw Exception("Erro ao carregar plantas: ${response.body}");
    }
  }

  // Criar vaso/planta nova
  Future<void> criarPlanta(String nome, int plantId) async {
    final token = await ApiService.getToken();
    if (token == null) throw Exception("Usuário não autenticado");

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "nome": nome,
        "plant": plantId // id da planta selecionada do catálogo
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao criar planta: ${response.body}");
    }
  }
  
}
