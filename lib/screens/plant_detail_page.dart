import 'package:flutter/material.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grene/widgets/plant_animated.dart';


//Tela que mostra os Detalhes da Planta

class PlantDetailPage extends StatefulWidget {
  final Planta planta;

  const PlantDetailPage({super.key, required this.planta});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.planta.nome, style: GoogleFonts.quicksand(fontSize: 24, color: Colors.white),),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: PlantAnimated(estado: "Triste")
        )
      ),
    );
  }
}
