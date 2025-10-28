//============================================================
// ARQUIVO: services/planta_service.dart
//============================================================
import 'dart:convert';
import '../models/planta.dart';
import 'api_service.dart';

//------------------------------------------------------------
// <PlantaService>
// -- Propósito: Orquestra a lógica de negócios para Vasos (Plantas).
// -- Responsabilidades:
//   -> Buscar vasos da API.
//   -> Buscar leituras de sensores.
//   -> Buscar ideais da espécie (com cache).
//   -> Calcular o 'estado' da planta (Feliz, Triste, etc.).
//   -> Gerenciar favoritos e histórico.
//------------------------------------------------------------
class PlantaService {
  //-- Cache <Map<String, Map>>: Armazena os ideais (temp, umidade, etc.) por espécie.
  final Map<String, Map<String, dynamic>> _cacheIdeais = {};

  //------------------------------------------------------------
  // <gerarSlug>
  // -- Descrição: Helper para criar um slug a partir do nome do vaso (fallback).
  //------------------------------------------------------------
  String gerarSlug(String nome) {
    return nome
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-') // substitui caracteres especiais
        .replaceAll(RegExp(r'^-+|-+$'), ''); // remove hífens no início/fim
  }

  //------------------------------------------------------------
  // <_buscarIdeaisPlanta> (Privado)
  // -- Descrição: Busca os parâmetros ideais (temp, umidade...) para uma espécie.
  // -- Lógica:
  //   1. Verifica o cache <_cacheIdeais>.
  //   2. Se não houver, busca na API (/api/plants/{name}/).
  //   3. Se a API falhar, usa um 'fallback' padrão.
  //------------------------------------------------------------
  Future<Map<String, dynamic>> _buscarIdeaisPlanta(String nomePlanta) async {
    if (_cacheIdeais.containsKey(nomePlanta)) return _cacheIdeais[nomePlanta]!;

    final res = await ApiService.get("plants/$nomePlanta/");
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      _cacheIdeais[nomePlanta] = Map<String, dynamic>.from(data);
      print("Ideais carregados de API para $nomePlanta: $data");
      return _cacheIdeais[nomePlanta]!;
    } else {
      print("Erro ao buscar ideais de $nomePlanta: ${res.statusCode}");
      //-- Fallback padrão em caso de erro na API --
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

  //------------------------------------------------------------
  // <getPlantas> (Método Principal)
  // -- Descrição: Orquestra a busca de todos os dados para montar a lista de <Planta>.
  // -- Fluxo:
  //   1. Busca a lista de vasos (/pots/).
  //   2. Busca a lista de favoritos (/favorite-pots/).
  //   3. Itera sobre cada vaso:
  //      a. Busca os ideais da espécie (via <_buscarIdeaisPlanta>).
  //      b. Busca a última leitura do sensor (/pots/{slug}/last-reading/).
  //      c. Calcula o estado (via <_calcularEstado>).
  //      d. Define a imagem (via <_getImageForEstado>).
  //      e. Monta o objeto <Planta>.
  //   4. Ordena a lista (favoritos primeiro).
  // -- Retorno: <Future<List<Planta>>>
  //------------------------------------------------------------
  Future<List<Planta>> getPlantas() async {
    final vasosRes = await ApiService.get("pots/");
    if (vasosRes.statusCode != 200) {
      throw Exception("Erro ao carregar vasos: ${vasosRes.statusCode} ${vasosRes.body}");
    }

    final List<dynamic> vasos = jsonDecode(vasosRes.body);

    List<Planta> lista = [];

    //-- Obtem lista de favoritos --
    List<String> favs = [];
    try {
      favs = await getFavoritePots();
    } catch (_) {}

    for (var vaso in vasos) {
      final slug = vaso["slug"] ?? vaso["pot_slug"] ?? gerarSlug(vaso["name"] ?? vaso["pot_name"] ?? "");
      final plantName = vaso["plant_name"] ?? vaso["plant_display"] ?? vaso["plant"]?.toString() ?? "Desconhecida";

      //-- Busca ideais (com cache) --
      final especie = await _buscarIdeaisPlanta(plantName);

      String estado = "Sem dados";

      //-- Busca última leitura --
      final readingsRes = await ApiService.get("pots/$slug/last-reading/");
      if (readingsRes.statusCode == 200) {
        final dynamic leitura = jsonDecode(readingsRes.body);
        Map<String, dynamic> readings = {};

        //-- Normaliza a resposta de 'last-reading' (pode vir aninhada) --
        if (leitura is Map<String, dynamic>) {
          final raw = (leitura["readings_json"] ?? leitura["readings"] ?? leitura) as Map<String, dynamic>;
          readings = (raw["readings_json"] ?? raw) as Map<String, dynamic>;
        } else if (leitura is List && leitura.isNotEmpty) {
          final raw = (leitura.last["readings_json"] ?? leitura.last["readings"] ?? {}) as Map<String, dynamic>;
          readings = (raw["readings_json"] ?? raw) as Map<String, dynamic>;
        }

        if (readings.isNotEmpty) {
          print("Leitura recebida para $slug: ${jsonEncode(readings)}");
          print("Ideais da planta $plantName: ${jsonEncode(especie)}");
          //-- Calcula o estado --
          estado = _calcularEstado(readings, especie);
        } else {
          estado = "Sem dados de sensores";
        }
      } else if (readingsRes.statusCode == 404) {
        estado = "Sem leituras";
      } else {
        estado = "Erro ao buscar sensores: ${readingsRes.statusCode}";
      }

      //-- Verifica se é favorito --
      bool favorito = favs.any((f) => f == slug || f == vaso["id"].toString());

      //-- Define a imagem com base no estado --
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
    
    //-- Ordena a lista para mostrar favoritos primeiro --
    lista.sort((a, b) {
      final favA = a.favorito ?? false;
      final favB = b.favorito ?? false;
      if (favA == favB) return 0;
      return favA ? -1 : 1; // true (favorito) vem antes
    });
    return lista;
  }

  //------------------------------------------------------------
  // <criarPlanta>
  // -- Descrição: Cria um novo vaso na API.
  //------------------------------------------------------------
  Future<void> criarPlanta(String nome, int plantId) async {
    final response = await ApiService.post("pots/", {"name": nome, "plant": plantId});
    if (response.statusCode != 201) {
      throw Exception("Erro ao criar planta: ${response.statusCode} ${response.body}");
    }
  }

  //------------------------------------------------------------
  // <favoritePot> / <unfavoritePot>
  // -- Descrição: Adiciona ou remove um vaso dos favoritos.
  //------------------------------------------------------------
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

  //------------------------------------------------------------
  // <getFavoritePots>
  // -- Descrição: Lista os slugs/IDs dos vasos favoritados.
  //------------------------------------------------------------
  Future<List<String>> getFavoritePots() async {
    final res = await ApiService.get("favorite-pots/");
    if (res.statusCode != 200) {
      throw Exception("Erro ao carregar favoritos: ${res.statusCode}");
    }
    final List<dynamic> favs = jsonDecode(res.body);
    //-- Normaliza a resposta (pode ser lista de string ou lista de map) --
    return favs.map<String>((f) {
      if (f is Map) {
        return f["slug"]?.toString() ?? f["id"]?.toString() ?? f["name"]?.toString() ?? "";
      }
      return f.toString();
    }).toList();
  }

  //------------------------------------------------------------
  // <getPotReadings> / <getPotLastReading>
  // -- Descrição: Busca o histórico de leituras ou apenas a última.
  //------------------------------------------------------------
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

  //------------------------------------------------------------
  // <_getImageForEstado> (Helper Privado)
  // -- Descrição: Retorna o caminho do asset de imagem (feliz, triste, etc.)
  //   baseado na string de estado.
  //------------------------------------------------------------
  String _getImageForEstado(String estado) {
    if (estado.toLowerCase().contains("feliz")) {
      return "lib/assets/img/feliz.png";
    } else if (estado.toLowerCase().contains("seca")) {
      return "lib/assets/img/seca.png";
    } else if (estado.toLowerCase().contains("triste")) {
      return "lib/assets/img/triste.png";
    } else {
      //-- Fallback para qualquer outro estado (Sem dados, Erro, etc.)
      return "lib/assets/img/triste.png";
    }
  }

  //------------------------------------------------------------
  // <_calcularEstado> (Helper Privado)
  // -- Descrição: Compara as leituras <readings> com os <ideais>
  //   e gera uma string de estado.
  // -- Retorno: "Feliz" ou "Triste: [motivos...]"
  //------------------------------------------------------------
  String _calcularEstado(Map<String, dynamic> readings, Map<String, dynamic> ideais) {
    List<String> motivos = [];

    //-- Helper para converter 'dynamic' (String ou num) para double --
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    //-- Leituras atuais --
    final temp = toDouble(readings["temperature"] ?? readings["temp"]);
    final hum = toDouble(readings["humidity"] ?? readings["hum"]);
    final soil = toDouble(readings["soil_moisture"] ?? readings["soil_moisture_percent"] ?? readings["soil"]);
    final light = toDouble(readings["light"] ?? readings["lux"]);

    //-- Parâmetros ideais --
    final tMin = toDouble(ideais["ideal_temperature_min"]);
    final tMax = toDouble(ideais["ideal_temperature_max"]);
    final hMin = toDouble(ideais["ideal_humidity_min"]);
    final hMax = toDouble(ideais["ideal_humidity_max"]);
    final sMin = toDouble(ideais["ideal_soil_moisture_min"]);
    final sMax = toDouble(ideais["ideal_soil_moisture_max"]);
    final lMin = toDouble(ideais["ideal_light_min"]);
    final lMax = toDouble(ideais["ideal_light_max"]);

    //-- Lógica de comparação --
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