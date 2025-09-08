import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planta.dart';
import 'api_service.dart';

class PlantaService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  /// Gera slug a partir do nome do vaso
  String gerarSlug(String nome) {
    return nome
        .toLowerCase()
        .replaceAll(
          RegExp(r'[^a-z0-9]+'),
          '-',
        ) // substitui espaços e caracteres especiais por '-'
        .replaceAll(RegExp(r'^-+|-+$'), ''); // remove '-' no início/fim
  }

  /// Pega todos os vasos do usuário com estado calculado
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

    // 2. Buscar catálogo de plantas (valores ideais)
    final plantasRes = await http.get(
      Uri.parse("$baseUrl/plantas/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (plantasRes.statusCode != 200) {
      throw Exception(
        "Erro ao carregar catálogo de plantas: ${plantasRes.body}",
      );
    }

    final List<dynamic> plantasCatalogo = jsonDecode(plantasRes.body);

    // 3. Montar lista de Planta (do app)
    List<Planta> lista = [];
    for (var vaso in vasos) {
      final slug = gerarSlug(vaso["pot_name"] ?? vaso["name"] ?? "");
      final plantId = vaso["plant"];
      final plantName = vaso["plant_name"] ?? "Desconhecida";

      // fallback de valores ideais caso não exista a planta no catálogo
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

      // buscar último sensor do vaso usando o slug
      final sensorRes = await http.get(
        Uri.parse("$baseUrl/vasos/$slug/historico-sensores/"),
        headers: {"Authorization": "Bearer $token"},
      );

      String estado = "Sem dados";
      if (sensorRes.statusCode == 200) {
        final List<dynamic> sensores = jsonDecode(sensorRes.body);
        if (sensores.isNotEmpty) {
          final readings =
              sensores.last["readings_json"] as Map<String, dynamic>;
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

  /// Criar vaso/planta nova
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

  /// Função que compara sensores com ideais
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
      if (temp < ideais["ideal_temperature_min"])
        motivos.add("estou com frio, preciso de mais calor");
      if (temp > ideais["ideal_temperature_max"])
        motivos.add("estou com calor demais");
    }

    if (hum != null) {
      if (hum < ideais["ideal_humidity_min"])
        motivos.add("estou seco, me dê água");
      if (hum > ideais["ideal_humidity_max"])
        motivos.add("agua demais, estou encharcada");
    }

    if (soil != null) {
      if (soil < ideais["ideal_soil_moisture_min"])
        motivos.add("minha terrinha está seca, rega por favor");
      if (soil > ideais["ideal_soil_moisture_max"])
        motivos.add("minha terrinha está molhada demais");
    }

    if (light != null) {
      if (light < ideais["ideal_light_min"]) motivos.add("preciso de mais sol");
      if (light > ideais["ideal_light_max"])
        motivos.add("sol demais, me proteja");
    }

    if (motivos.isEmpty) {
      return "Feliz";
    } else {
      return "Triste: ${motivos.join(', ')}";
    }
  }
}
