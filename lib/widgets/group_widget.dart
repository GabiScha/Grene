// Função: Exibe um card representando um grupo de plantas, incluindo nome, descrição e uma lista/grade das plantas contidas.
// Recebe:
// - name: Nome do grupo.
// - description: Descrição do grupo.
// - plants: Lista de objetos Planta pertencentes ao grupo.
// - onPressed: Função chamada ao pressionar o botão de gerenciar grupo.
// - onPlantSelected: (Opcional) Função chamada ao selecionar uma planta dentro do grupo (usado no layout desktop).
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/views/plant_detail_page.dart';

// Função: Widget auxiliar para exibir um item de planta individual dentro do GroupWidget.
// Recebe:
// - planta: O objeto Planta a ser exibido.
// - onTap: (Opcional) Função chamada quando o item da planta é pressionado.
class _GroupPlantItem extends StatelessWidget {
  final Planta planta;
  final void Function()? onTap;

  const _GroupPlantItem({required this.planta, this.onTap});

  @override
  Widget build(BuildContext context) {
    final nome = planta.nome ?? "Planta";

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: AppColors.backGreen.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.backGreen.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.asset(
                    planta.img,
                    fit: BoxFit.contain,
                  ),
                ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 80,
            child: Text(
              nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 12,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupWidget extends StatelessWidget {
  final String name;
  final String description;
  final List<Planta> plants;
  final VoidCallback onPressed;
  final void Function(Planta)? onPlantSelected;

  const GroupWidget({
    super.key,
    required this.name,
    required this.description,
    required this.plants,
    required this.onPressed,
    this.onPlantSelected,
  });

  bool _isUsingWideLayout(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return constraints.width > 950;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = _isUsingWideLayout(context);
    final double containerWidth = isWide ? 360 : 320;

    return Container(
      width: containerWidth,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                IconButton(
                  icon: const Icon(Icons.groups, color: Colors.white),
                  onPressed: onPressed,
                  tooltip: "Gerenciar grupo",
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

            if (plants.isNotEmpty)
              Flexible(
                child: SingleChildScrollView(
                  child: isWide
                      ? Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: plants.map((planta) {
                            return _GroupPlantItem(
                              planta: planta,
                              onTap: () {
                                if (onPlantSelected != null) {
                                  onPlantSelected!(planta);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlantDetailPage(planta: planta),
                                    ),
                                  );
                                }
                              },
                            );
                          }).toList(),
                        )
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: plants.length,
                          itemBuilder: (context, index) {
                            final planta = plants[index];
                            return _GroupPlantItem(
                              planta: planta,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlantDetailPage(planta: planta),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
            if (plants.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    "Nenhuma planta neste grupo.",
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}