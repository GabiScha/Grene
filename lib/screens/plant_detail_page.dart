import 'package:flutter/material.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';


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
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 70,),
            Center(
              child: Container(
              height: 320,
              width: 200,
              color: AppColors.primary,
            ),
            ),
            Center(
            child: Container(
              height: 250,
              width: 310,
              decoration: BoxDecoration(
                color: AppColors.pot_color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), 
                  topRight: Radius.circular(20), 
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: 
              Center(
                child: Text("Estado", style: GoogleFonts.quicksand(fontSize: 24, color: AppColors.background),),
              )
              
            )
            )
          ],
        ),
        )
      ),
    );
  }
}
