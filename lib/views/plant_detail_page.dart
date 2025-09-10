// plant_detail.page.dart
import 'package:flutter/material.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grene/widgets/plant_animated.dart';
import 'package:grene/services/storage_service.dart';

class PlantDetailPage extends StatefulWidget {
  final Planta planta;
  const PlantDetailPage({super.key, required this.planta});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final fav = await StorageService.isFavorite(widget.planta.id.toString());
    setState(() {
      _isFavorited = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    await StorageService.toggleFavorite(widget.planta.id.toString());
    final fav = await StorageService.isFavorite(widget.planta.id.toString());
    setState(() {
      _isFavorited = fav;
    });
  }

  Future<void> _addToGroup() async {
    // exemplo simples: adiciona sempre no grupo "Minhas Plantas"
    await StorageService.addToGroup("Minhas Plantas", widget.planta.id.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.planta.nome} adicionada a Minhas Plantas")),
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
