class Planta {
  final int id;
  final String nome;
  final String tipo;
  final String estado;
  final String? slug;
  final bool? favorito;
  final String img; // 🆕 Caminho da imagem

  Planta({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.estado,
    required this.img, // 🆕
    this.slug,
    this.favorito,
  });

  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      id: json['id'] ?? 0,
      nome: json['name'] ?? "Sem nome",
      tipo: json['plant_name'] ?? "Desconhecida",
      estado: json['estado'] ?? "Sem dados",
      img: json['img'] ?? "lib/assets/img/feliz.png", // 🆕 valor padrão
      slug: json['slug'],
      favorito: json['favorito'],
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
      'img': img,
    };
  }

  @override
  String toString() {
    return 'Planta(id: $id, nome: $nome, tipo: $tipo, estado: $estado, slug: $slug, favorito: $favorito, img: $img)';
  }
}
