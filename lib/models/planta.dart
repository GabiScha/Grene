class Planta {
  final int id;
  final String nome;

  Planta({required this.id, required this.nome});

  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? json['name'] ?? "Sem nome",
    );
  }
}
