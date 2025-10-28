//============================================================
// ARQUIVO: views/plant_detail_page.dart
//============================================================
import 'package:flutter/material.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grene/widgets/plant_animated.dart';
import 'package:grene/services/planta_service.dart';
import 'package:grene/widgets/group_dialog.dart';

//------------------------------------------------------------
// <PlantDetailPage> (View)
// -- Propósito: Exibe os detalhes de UMA planta específica.
// -- Recebe: <Planta> via construtor.
// -- Funções:
//   -> Favoritar/Desfavoritar a planta.
//   -> Adicionar a planta a um grupo.
//   -> Exibir a animação de estado (<PlantAnimated>).
//------------------------------------------------------------
class PlantDetailPage extends StatefulWidget {
  final Planta planta;
  const PlantDetailPage({super.key, required this.planta});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  final PlantaService _service = PlantaService();

  //-- Estado: Controla se a planta está favoritada --
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    //-- Carrega o status inicial de favorito --
    _loadFavoriteStatus();
  }

  //------------------------------------------------------------
  // <_loadFavoriteStatus>
  // -- Descrição: Verifica na API (via service) se esta planta
  //   está na lista de favoritos do usuário.
  //------------------------------------------------------------
  Future<void> _loadFavoriteStatus() async {
    try {
      final favs = await _service.getFavoritePots(); // retorna lista de slugs/ids
      final slug = widget.planta.slug ?? widget.planta.id.toString();
      final fav = favs.any((f) => f == slug || f == widget.planta.id.toString());
      if (!mounted) return;
      setState(() {
        _isFavorited = fav;
      });
    } catch (e) {
      // se falhar, mantemos false e não quebramos a UI
      if (!mounted) return;
      setState(() => _isFavorited = false);
    }
  }

  //------------------------------------------------------------
  // <_toggleFavorite> (Ação)
  // -- Descrição: Alterna o estado de favorito (local e na API).
  //------------------------------------------------------------
  Future<void> _toggleFavorite() async {
    try {
      final slug = widget.planta.slug ?? widget.planta.id.toString();
      if (_isFavorited) {
        await _service.unfavoritePot(slug);
      } else {
        await _service.favoritePot(slug);
      }

      if (!mounted) return;
      setState(() {
        _isFavorited = !_isFavorited;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao alterar favorito: $e")),
      );
    }
  }

  //------------------------------------------------------------
  // <_addToGroup> (Ação)
  // -- Descrição: Abre o <GroupDialog> para adicionar esta planta
  //   (potId) a um grupo.
  //------------------------------------------------------------
  Future<void> _addToGroup() async {
    showDialog(
      context: context,
      builder: (context) => GroupDialog(potId: widget.planta.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.planta.nome,
          style: GoogleFonts.quicksand(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          //-- Botão de Favoritar --
          IconButton(
            icon: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
          //-- Botão de Adicionar a Grupo --
          IconButton(
            icon: const Icon(Icons.group_add, color: Colors.white),
            onPressed: _addToGroup,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          //-- Widget de Animação --
          child: PlantAnimated(
            estado: widget.planta.estado,
          ),
        ),
      ),
    );
  }
}