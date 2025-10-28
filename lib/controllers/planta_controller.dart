//============================================================
// ARQUIVO: controllers/planta_controller.dart
//============================================================
import 'package:grene/models/planta.dart';
import 'package:grene/services/planta_service.dart';

//------------------------------------------------------------
// <PlantaController>
// -- Propósito: Gerenciar as operações de plantas (vasos) do usuário.
// -- Interage com: <PlantaService>
//------------------------------------------------------------
class PlantaController {
  final PlantaService _service = PlantaService();

  //------------------------------------------------------------
  // <carregarPlantas>
  // -- Descrição: Carrega a lista completa de plantas do usuário.
  // -- Retorno: <Future<List<Planta>>> -> Lista de plantas com estados calculados.
  //------------------------------------------------------------
  Future<List<Planta>> carregarPlantas() async {
    return await _service.getPlantas();
  }

  //------------------------------------------------------------
  // <adicionarPlanta>
  // -- Descrição: Cria um novo vaso para o usuário.
  // -- Parâmetros:
  //   -> nome: Nome do novo vaso.
  //   -> plantId: ID da espécie da planta (do catálogo).
  //------------------------------------------------------------
  Future<void> adicionarPlanta(String nome, int plantId) async {
    await _service.criarPlanta(nome, plantId);
  }
}