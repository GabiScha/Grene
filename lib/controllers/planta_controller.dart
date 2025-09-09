// controllers/planta_controller.dart
import 'package:grene/models/planta.dart';
import 'package:grene/services/planta_service.dart';

/// Controller responsável por gerenciar plantas.
/// 
/// Encapsula chamadas ao [PlantaService] e é utilizado pelas views.
class PlantaController {
  final PlantaService _service = PlantaService();

  /// Carrega todas as plantas do usuário com seus estados calculados.
  Future<List<Planta>> carregarPlantas() async {
    return await _service.getPlantas();
  }

  /// Adiciona uma nova planta ao backend.
  Future<void> adicionarPlanta(String nome, int plantId) async {
    await _service.criarPlanta(nome, plantId);
  }
}
