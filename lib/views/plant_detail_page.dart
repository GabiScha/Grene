// plant_detail_page.dart
import 'package:flutter/material.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grene/widgets/plant_animated.dart';
import 'package:grene/services/planta_service.dart';
import 'package:grene/widgets/group_dialog.dart';


class PlantDetailPage extends StatefulWidget {
  final Planta planta;
  const PlantDetailPage({super.key, required this.planta});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  final PlantaService _service = PlantaService();

  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

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
          IconButton(
            icon: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.group_add, color: Colors.white),
            onPressed: _addToGroup,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: PlantAnimated(
            estado: widget.planta.estado,
          ),
        ),
      ),
    );
  }
}
