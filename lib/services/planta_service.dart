// services/planta_service.dart
import 'dart:convert';
import '../models/planta.dart';
import 'api_service.dart';

class PlantaService {
  /// Cache local para os ideais de cada planta
  final Map<String, Map<String, dynamic>> _cacheIdeais = {};

  /// Gera um slug a partir do nome do vaso (fallback)
  String gerarSlug(String nome) {
    return nome
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-') // substitui caracteres especiais
        .replaceAll(RegExp(r'^-+|-+$'), ''); // remove hífens no início/fim
  }

  /// Busca os ideais reais da planta via /api/plants/{name}/
  Future<Map<String, dynamic>> _buscarIdeaisPlanta(String nomePlanta) async {
    if (_cacheIdeais.containsKey(nomePlanta)) return _cacheIdeais[nomePlanta]!;

    final res = await ApiService.get("plants/$nomePlanta/");
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      _cacheIdeais[nomePlanta] = Map<String, dynamic>.from(data);
      print("🌱 Ideais carregados de API para $nomePlanta: $data");
      return _cacheIdeais[nomePlanta]!;
    } else {
      print("⚠️ Erro ao buscar ideais de $nomePlanta: ${res.statusCode}");
      // fallback padrão
      return {
        "ideal_temperature_min": 20,
        "ideal_temperature_max": 30,
        "ideal_humidity_min": 50,
        "ideal_humidity_max": 70,
        "ideal_soil_moisture_min": 40,
        "ideal_soil_moisture_max": 60,
        "ideal_light_min": 2000,
        "ideal_light_max": 4000,
      };
    }
  }

  /// Lista todos os pots do usuário e monta objetos Planta
  Future<List<Planta>> getPlantas() async {
    final vasosRes = await ApiService.get("pots/");
    if (vasosRes.statusCode != 200) {
      throw Exception("Erro ao carregar vasos: ${vasosRes.statusCode} ${vasosRes.body}");
    }

    final List<dynamic> vasos = jsonDecode(vasosRes.body);

    // Buscar catálogo de plantas (public)
    // final plantasRes = await ApiService.get("plantas/");
    // List<dynamic> plantasCatalogo = [];
    // if (plantasRes.statusCode == 200) {
    //   plantasCatalogo = jsonDecode(plantasRes.body);
    // }

    List<Planta> lista = [];

    // Obtem lista de favoritos
    List<String> favs = [];
    try {
      favs = await getFavoritePots();
    } catch (_) {}

        for (var vaso in vasos) {
      final slug = vaso["slug"] ?? vaso["pot_slug"] ?? gerarSlug(vaso["name"] ?? vaso["pot_name"] ?? "");
      final plantName = vaso["plant_name"] ?? vaso["plant_display"] ?? vaso["plant"]?.toString() ?? "Desconhecida";

      final especie = await _buscarIdeaisPlanta(plantName);

      String estado = "Sem dados";

      final readingsRes = await ApiService.get("pots/$slug/last-reading/");
      if (readingsRes.statusCode == 200) {
        final dynamic leitura = jsonDecode(readingsRes.body);
        Map<String, dynamic> readings = {};

        if (leitura is Map<String, dynamic>) {
          final raw = (leitura["readings_json"] ?? leitura["readings"] ?? leitura) as Map<String, dynamic>;
          readings = (raw["readings_json"] ?? raw) as Map<String, dynamic>;
        } else if (leitura is List && leitura.isNotEmpty) {
          final raw = (leitura.last["readings_json"] ?? leitura.last["readings"] ?? {}) as Map<String, dynamic>;
          readings = (raw["readings_json"] ?? raw) as Map<String, dynamic>;
        }

        if (readings.isNotEmpty) {
          print("🔍 Leitura recebida para $slug: ${jsonEncode(readings)}");
          print("🔍 Ideais da planta $plantName: ${jsonEncode(especie)}");
          estado = _calcularEstado(readings, especie);
        } else {
          estado = "Sem dados de sensores";
        }
      } else if (readingsRes.statusCode == 404) {
        estado = "Sem leituras";
      } else {
        estado = "Erro ao buscar sensores: ${readingsRes.statusCode}";
      }

      bool favorito = favs.any((f) => f == slug || f == vaso["id"].toString());

    final imgPath = _getImageForEstado(estado);

      lista.add(Planta(
        id: vaso["id"],
        nome: vaso["name"] ?? vaso["pot_name"] ?? "Sem nome",
        tipo: plantName,
        estado: estado,
        slug: slug,
        favorito: favorito,
        img: imgPath, 
      ));
    }
        lista.sort((a, b) {
          final favA = a.favorito ?? false;
          final favB = b.favorito ?? false;
          if (favA == favB) return 0;
          return favA ? -1 : 1;
        });
    return lista;
  }


  /// Cria um novo vaso
  Future<void> criarPlanta(String nome, int plantId) async {
    final response = await ApiService.post("pots/", {"name": nome, "plant": plantId});
    if (response.statusCode != 201) {
      throw Exception("Erro ao criar planta: ${response.statusCode} ${response.body}");
    }
  }

  /// Favoritar / desfavoritar vaso
  Future<void> favoritePot(String slug) async {
    final res = await ApiService.post("pots/$slug/favorite/", {});
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Erro ao favoritar vaso: ${res.statusCode} ${res.body}");
    }
  }

  Future<void> unfavoritePot(String slug) async {
    final res = await ApiService.post("pots/$slug/unfavorite/", {});
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Erro ao remover favorito: ${res.statusCode} ${res.body}");
    }
  }

  /// Lista vasos favoritos
  Future<List<String>> getFavoritePots() async {
    final res = await ApiService.get("favorite-pots/");
    if (res.statusCode != 200) {
      throw Exception("Erro ao carregar favoritos: ${res.statusCode}");
    }
    final List<dynamic> favs = jsonDecode(res.body);
    return favs.map<String>((f) {
      if (f is Map) {
        return f["slug"]?.toString() ?? f["id"]?.toString() ?? f["name"]?.toString() ?? "";
      }
      return f.toString();
    }).toList();
  }

  /// Histórico de leituras
  Future<List<Map<String, dynamic>>> getPotReadings(String slug) async {
    final res = await ApiService.get("pots/$slug/readings/");
    if (res.statusCode != 200) {
      throw Exception("Erro ao carregar leituras: ${res.statusCode}");
    }
    final List<dynamic> readings = jsonDecode(res.body);
    return readings.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getPotLastReading(String slug) async {
    final res = await ApiService.get("pots/$slug/readings/");
    if (res.statusCode == 200) {
      final List<dynamic> sensores = jsonDecode(res.body);
      if (sensores.isNotEmpty) {
        return sensores.last as Map<String, dynamic>;
      }
      return null;
    } else if (res.statusCode == 404) {
      return null;
    } else {
      throw Exception("Erro ao carregar última leitura: ${res.statusCode}");
    }
  }

// ---------------------------
// Lógica de imagem por estado
// ---------------------------
String _getImageForEstado(String estado) {
  if (estado.toLowerCase().contains("feliz")) {
    return "lib/assets/img/feliz.png";
  } else if (estado.toLowerCase().contains("seca")) {
    return "lib/assets/img/seca.png";
  } else if (estado.toLowerCase().contains("triste")) {
    return "lib/assets/img/triste.png";
  } else {
    return "lib/assets/img/triste.png";
  }
}


  // ---------------------------
  // Lógica de estado
  // ---------------------------
  String _calcularEstado(Map<String, dynamic> readings, Map<String, dynamic> ideais) {
    List<String> motivos = [];

    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    final temp = toDouble(readings["temperature"] ?? readings["temp"]);
    final hum = toDouble(readings["humidity"] ?? readings["hum"]);
    final soil = toDouble(readings["soil_moisture"] ?? readings["soil_moisture_percent"] ?? readings["soil"]);
    final light = toDouble(readings["light"] ?? readings["lux"]);

    final tMin = toDouble(ideais["ideal_temperature_min"]);
    final tMax = toDouble(ideais["ideal_temperature_max"]);
    final hMin = toDouble(ideais["ideal_humidity_min"]);
    final hMax = toDouble(ideais["ideal_humidity_max"]);
    final sMin = toDouble(ideais["ideal_soil_moisture_min"]);
    final sMax = toDouble(ideais["ideal_soil_moisture_max"]);
    final lMin = toDouble(ideais["ideal_light_min"]);
    final lMax = toDouble(ideais["ideal_light_max"]);

    if (temp != null) {
      if (tMin != null && temp < tMin) motivos.add("estou com frio, preciso de mais calor");
      if (tMax != null && temp > tMax) motivos.add("estou com calor demais");
    }

    if (hum != null) {
      if (hMin != null && hum < hMin) motivos.add("estou seco, me dê água");
      if (hMax != null && hum > hMax) motivos.add("água demais, estou encharcada");
    }

    if (soil != null) {
      if (sMin != null && soil < sMin) motivos.add("minha terrinha está seca, rega por favor");
      if (sMax != null && soil > sMax) motivos.add("minha terrinha está molhada demais");
    }

    if (light != null) {
      if (lMin != null && light < lMin) motivos.add("preciso de mais sol");
      if (lMax != null && light > lMax) motivos.add("sol demais, me proteja");
    }


    return motivos.isEmpty ? "Feliz" : "Triste: ${motivos.join(', ')}";

    
  }
}




