import 'package:grene/models/planta.dart';
import 'package:grene/services/planta_service.dart';

class PlantaController {
  final PlantaService _service = PlantaService();

  Future<List<Planta>> carregarPlantas() async {
    return await _service.getPlantas();
  }

  Future<void> adicionarPlanta(String nome, int plantId) async {
    await _service.criarPlanta(nome, plantId);
  }
}
