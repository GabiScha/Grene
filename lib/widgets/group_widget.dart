import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/views/plant_detail_page.dart';

class GroupWidget extends StatelessWidget {
  final String name;
  final String description;
  final List<Planta> plants; // lista real de plantas do grupo
  final VoidCallback onPressed;

  const GroupWidget({
    super.key,
    required this.name,
    required this.description,
    required this.plants,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 210, // ligeiramente mais alto que o HomePlantWidget
        width: 320,
        decoration: BoxDecoration(
          color: AppColors.backGreen,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.backLightGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Cabeçalho com nome e ícone
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              if (description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    color: Colors.grey[800],
                  ),
                ),
              ],

              const SizedBox(height: 10),

              // 🔹 Miniaturas das plantas
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    final planta = plants[index];
                    final nome = planta.nome ?? "Planta";

                    return GestureDetector(
                      onTap: () {
                        // 👉 abre a tela de detalhes da planta
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlantDetailPage(planta: planta),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          // 🔸 Placeholder para imagem futura
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: AppColors.backGreen.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.local_florist,
                              color: Colors.white70,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
