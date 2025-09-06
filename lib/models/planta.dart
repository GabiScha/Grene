// Representa uma Planta (Model)
class Planta {
  final int id;       
  final String nome;  
  final String tipo;  
  final String estado; // estado da planta

  Planta({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.estado,
  });

  factory Planta.fromJson(Map<String, dynamic> json) {
    final List<dynamic> recs = json['recommendations'] ?? json['recomendations'] ?? [];

    return Planta(
      id: json['id'] ?? 0,                 
      nome: json['name'] ?? "Sem nome",    
      tipo: json['plant_name'] ?? "Desconhecida", 
      estado: recs.isEmpty ? "Feliz" : "Triste", // agora pega do backend
    );
  }
}