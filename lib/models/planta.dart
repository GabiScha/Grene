/// Representa uma planta cadastrada pelo usuário.
/// 
/// Contém informações básicas como:
/// - [id]: identificador único do vaso/planta.
/// - [nome]: nome atribuído pelo usuário ao vaso.
/// - [tipo]: espécie da planta (vindo do catálogo).
/// - [estado]: estado atual calculado a partir de sensores e valores ideais.
class Planta {
  final int id;
  final String nome;
  final String tipo;
  final String estado;

  Planta({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.estado,
  });

  /// Cria uma instância de [Planta] a partir de um JSON.
  /// 
  /// Se algum campo vier `null`, valores padrões são usados.
  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      id: json['id'] ?? 0,
      nome: json['name'] ?? "Sem nome",
      tipo: json['plant_name'] ?? "Desconhecida",
      estado: json['estado'] ?? "Sem dados",
    );
  }

  /// Converte o objeto [Planta] em um `Map<String, dynamic>`.
  /// 
  /// Útil para salvar localmente ou enviar para o backend.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nome,
      'plant_name': tipo,
      'estado': estado,
    };
  }

  @override
  String toString() {
    return 'Planta(id: $id, nome: $nome, tipo: $tipo, estado: $estado)';
  }
}
