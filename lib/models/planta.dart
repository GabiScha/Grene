//============================================================
// ARQUIVO: models/planta.dart
//============================================================

//------------------------------------------------------------
// <Planta> (Modelo)
// -- Propósito: Representa a entidade 'Planta' (vaso) no aplicativo.
// -- Contém os dados principais do vaso e seu estado.
//------------------------------------------------------------
class Planta {
  //-- Propriedades --
  final int id;
  final String nome;
  final String tipo; // Espécie (ex: "Samambaia")
  final String estado; // Estado calculado (ex: "Feliz", "Triste: ...")
  final String? slug;
  final bool? favorito;
  final String img; // Caminho do asset da imagem (ex: "lib/assets/img/feliz.png")

  //------------------------------------------------------------
  // <Construtor>
  // -- Descrição: Cria uma instância de Planta.
  //------------------------------------------------------------
  Planta({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.estado,
    required this.img, // 🆕
    this.slug,
    this.favorito,
  });

  //------------------------------------------------------------
  // <Planta.fromJson> (Factory)
  // -- Descrição: Converte um Map (JSON) em um objeto <Planta>.
  // -- Utilizado para desserializar dados da API.
  //------------------------------------------------------------
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

  //------------------------------------------------------------
  // <toJson>
  // -- Descrição: Converte o objeto <Planta> em um Map (JSON).
  // -- Utilizado para serializar dados (se necessário enviar à API).
  //------------------------------------------------------------
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

  //------------------------------------------------------------
  // <toString> (Override)
  // -- Descrição: Representação textual do objeto para debug.
  //------------------------------------------------------------
  @override
  String toString() {
    return 'Planta(id: $id, nome: $nome, tipo: $tipo, estado: $estado, slug: $slug, favorito: $favorito, img: $img)';
  }
}