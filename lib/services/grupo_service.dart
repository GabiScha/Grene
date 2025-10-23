import 'dart:convert';
import 'api_service.dart';

class GrupoService {
  Future<List<Map<String, dynamic>>> listarGrupos() async {
    final res = await ApiService.get("pot-groups/");
    if (res.statusCode != 200) {
      throw Exception("Erro ao listar grupos: ${res.statusCode}");
    }

    final decoded = jsonDecode(res.body);
    if (decoded is List) {
      return decoded.cast<Map<String, dynamic>>();
    } else if (decoded is Map && decoded["results"] is List) {
      return (decoded["results"] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception("Formato inesperado: ${res.body}");
    }
  }

  Future<void> criarGrupo(String nome, [String? descricao]) async {
    final res = await ApiService.post("pot-groups/", {
      "name": nome,
      if (descricao != null && descricao.isNotEmpty) "description": descricao,
    });

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception("Erro ao criar grupo: ${res.statusCode} ${res.body}");
    }
  }

  Future<void> deletarGrupo(int grupoId) async {
    final res = await ApiService.delete("pot-groups/$grupoId/");
    if (res.statusCode != 204 && res.statusCode != 200) {
      throw Exception("Erro ao deletar grupo: ${res.statusCode} ${res.body}");
    }
  }

  Future<void> adicionarPlantaAoGrupo(int grupoId, int potId) async {
    final res = await ApiService.post("pot-groups/$grupoId/add-pot/", {
      "pot_id": potId,
    });

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Erro ao adicionar planta: ${res.statusCode} ${res.body}");
    }
  }

  Future<void> removerPlantaDoGrupo(int grupoId, int potId) async {
    final res = await ApiService.post("pot-groups/$grupoId/remove-pot/", {
      "pot_id": potId,
    });

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Erro ao remover planta: ${res.statusCode} ${res.body}");
    }
  }
}
