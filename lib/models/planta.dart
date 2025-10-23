class Planta {
  final int id;
  final String nome;
  final String tipo;
  final String estado;
  final String? slug;     // ✅ novo campo opcional
  final bool? favorito;   // ✅ novo campo opcional

  Planta({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.estado,
    this.slug,
    this.favorito,
  });

  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      id: json['id'] ?? 0,
      nome: json['name'] ?? "Sem nome",
      tipo: json['plant_name'] ?? "Desconhecida",
      estado: json['estado'] ?? "Sem dados",
      slug: json['slug'],          // ✅ adicionado
      favorito: json['favorito'],  // ✅ adicionado
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nome,
      'plant_name': tipo,
      'estado': estado,
      'slug': slug,
      'favorito': favorito,
    };
  }

  @override
  String toString() {
    return 'Planta(id: $id, nome: $nome, tipo: $tipo, estado: $estado, slug: $slug, favorito: $favorito)';
  }
}
