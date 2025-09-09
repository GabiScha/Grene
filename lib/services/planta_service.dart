// services/planta_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planta.dart';
import 'api_service.dart';

/// Serviço responsável por lidar com operações relacionadas às plantas e vasos.
/// Faz requisições ao backend e monta objetos [Planta].
class PlantaService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  /// Gera um slug a partir do nome do vaso, útil para buscar histórico de sensores.
  String gerarSlug(String nome) {
    return nome
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-') // substitui caracteres especiais
        .replaceAll(RegExp(r'^-+|-+$'), ''); // remove hífens no início/fim
  }

  /// Busca todos os vasos do usuário, consulta catálogo de plantas
  /// e calcula o estado de cada planta com base nos sensores.
  ///
  /// Retorna uma lista de [Planta].
  Future<List<Planta>> getPlantas() async {
    final token = await ApiService.getToken();
    if (token == null) throw Exception("Usuário não autenticado");

    // 1. Buscar vasos do usuário
    final vasosRes = await http.get(
      Uri.parse("$baseUrl/vasos/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (vasosRes.statusCode != 200) {
      throw Exception("Erro ao carregar vasos: ${vasosRes.body}");
    }
    final List<dynamic> vasos = jsonDecode(vasosRes.body);

    // 2. Buscar catálogo de plantas
    final plantasRes = await http.get(
      Uri.parse("$baseUrl/plantas/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (plantasRes.statusCode != 200) {
      throw Exception("Erro ao carregar catálogo de plantas: ${plantasRes.body}");
    }
    final List<dynamic> plantasCatalogo = jsonDecode(plantasRes.body);

    // 3. Montar lista final
    List<Planta> lista = [];
    for (var vaso in vasos) {
      final slug = gerarSlug(vaso["pot_name"] ?? vaso["name"] ?? "");
      final plantId = vaso["plant"];
      final plantName = vaso["plant_name"] ?? "Desconhecida";

      // Fallback caso a planta não esteja no catálogo
      final especie = plantasCatalogo.firstWhere(
        (p) => p["id"] == plantId,
        orElse: () => {
          "ideal_temperature_min": 20,
          "ideal_temperature_max": 30,
          "ideal_humidity_min": 50,
          "ideal_humidity_max": 70,
          "ideal_soil_moisture_min": 40,
          "ideal_soil_moisture_max": 60,
          "ideal_light_min": 2000,
          "ideal_light_max": 4000,
        },
      );

      // Buscar último sensor do vaso
      final sensorRes = await http.get(
        Uri.parse("$baseUrl/vasos/$slug/historico-sensores/"),
        headers: {"Authorization": "Bearer $token"},
      );

      String estado = "Sem dados";
      if (sensorRes.statusCode == 200) {
        final List<dynamic> sensores = jsonDecode(sensorRes.body);
        if (sensores.isNotEmpty) {
          final readings = sensores.last["readings_json"] as Map<String, dynamic>;
          estado = _calcularEstado(readings, especie);
        } else {
          estado = "Sensores está vazio";
        }
      } else {
        estado = "Erro ao buscar sensores: ${sensorRes.statusCode}";
      }

      lista.add(
        Planta(
          id: vaso["id"],
          nome: vaso["name"] ?? "Sem nome",
          tipo: plantName,
          estado: estado,
        ),
      );
    }

    return lista;
  }

  /// Cria um novo vaso/planta no backend.
  Future<void> criarPlanta(String nome, int plantId) async {
    final token = await ApiService.getToken();
    if (token == null) throw Exception("Usuário não autenticado");

    final response = await http.post(
      Uri.parse("$baseUrl/vasos/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"name": nome, "plant": plantId}),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao criar planta: ${response.body}");
    }
  }

  /// Calcula o estado da planta comparando leituras dos sensores com valores ideais.
  String _calcularEstado(
    Map<String, dynamic> readings,
    Map<String, dynamic> ideais,
  ) {
    List<String> motivos = [];

    final temp = readings["temperature"];
    final hum = readings["humidity"];
    final soil = readings["soil_moisture"];
    final light = readings["light"];

    if (temp != null) {
      if (temp < ideais["ideal_temperature_min"]) motivos.add("estou com frio, preciso de mais calor");
      if (temp > ideais["ideal_temperature_max"]) motivos.add("estou com calor demais");
    }

    if (hum != null) {
      if (hum < ideais["ideal_humidity_min"]) motivos.add("estou seco, me dê água");
      if (hum > ideais["ideal_humidity_max"]) motivos.add("água demais, estou encharcada");
    }

    if (soil != null) {
      if (soil < ideais["ideal_soil_moisture_min"]) motivos.add("minha terrinha está seca, rega por favor");
      if (soil > ideais["ideal_soil_moisture_max"]) motivos.add("minha terrinha está molhada demais");
    }

    if (light != null) {
      if (light < ideais["ideal_light_min"]) motivos.add("preciso de mais sol");
      if (light > ideais["ideal_light_max"]) motivos.add("sol demais, me proteja");
    }

    return motivos.isEmpty ? "Feliz" : "Triste: ${motivos.join(', ')}";
  }
}
