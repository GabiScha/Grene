//============================================================
// ARQUIVO: services/grupo_service.dart
//============================================================
import 'dart:convert';
import 'api_service.dart';

//------------------------------------------------------------
// <GrupoService>
// -- Propósito: Gerencia a lógica de negócios e API para 'Grupos de Plantas'.
//------------------------------------------------------------
class GrupoService {
  
  //------------------------------------------------------------
  // <listarGrupos>
  // -- Descrição: Busca a lista de grupos do usuário.
  // -- Tratamento: Lida com resposta paginada (com 'results') ou lista simples.
  //------------------------------------------------------------
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

  //------------------------------------------------------------
  // <criarGrupo>
  // -- Descrição: Cria um novo grupo na API.
  //------------------------------------------------------------
  Future<void> criarGrupo(String nome, [String? descricao]) async {
    final res = await ApiService.post("pot-groups/", {
      "name": nome,
      if (descricao != null && descricao.isNotEmpty) "description": descricao,
    });

    if (res.statusCode != 201 && res.statusCode != 200) { // 201 = Created
      throw Exception("Erro ao criar grupo: ${res.statusCode} ${res.body}");
    }
  }

  //------------------------------------------------------------
  // <deletarGrupo>
  // -- Descrição: Remove um grupo pelo ID.
  //------------------------------------------------------------
  Future<void> deletarGrupo(int grupoId) async {
    final res = await ApiService.delete("pot-groups/$grupoId/");
    if (res.statusCode != 204 && res.statusCode != 200) { // 204 = No Content
      throw Exception("Erro ao deletar grupo: ${res.statusCode} ${res.body}");
    }
  }

  //------------------------------------------------------------
  // <adicionarPlantaAoGrupo>
  // -- Descrição: Associa um 'pot_id' a um 'grupoId'.
  //------------------------------------------------------------
  Future<void> adicionarPlantaAoGrupo(int grupoId, int potId) async {
    final res = await ApiService.post("pot-groups/$grupoId/add-pot/", {
      "pot_id": potId,
    });

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Erro ao adicionar planta: ${res.statusCode} ${res.body}");
    }
  }

  //------------------------------------------------------------
  // <removerPlantaDoGrupo>
  // -- Descrição: Remove a associação de um 'pot_id' de um 'grupoId'.
  //------------------------------------------------------------
  Future<void> removerPlantaDoGrupo(int grupoId, int potId) async {
    final res = await ApiService.post("pot-groups/$grupoId/remove-pot/", {
      "pot_id": potId,
    });

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Erro ao remover planta: ${res.statusCode} ${res.body}");
    }
  }
}