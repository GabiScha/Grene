// Função: Exibe um card para uma única planta na tela principal de lista/grade.
// Recebe:
// - name: O nome dado ao vaso/planta.
// - plant: O tipo/espécie da planta.
// - img: O caminho do asset da imagem de estado da planta.
// - onPressed: A função a ser chamada quando o card é pressionado.
import 'package:flutter/material.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePlantWidget extends StatelessWidget {
  final String name;
  final String plant;
  final String img;
  final VoidCallback onPressed;

  const HomePlantWidget({
    super.key,
    required this.name,
    required this.plant,
    required this.img,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 200,
        width: 320,
        decoration: BoxDecoration(
          color: AppColors.backGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.backLightGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 130,
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  img,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),


                      const SizedBox(height: 8),
                      Text(
                        plant,
                        style: GoogleFonts.quicksand(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}