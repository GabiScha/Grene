import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/views/plant_detail_page.dart';

// Widget auxiliar para as plantas dentro do grupo
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
        mainAxisSize: MainAxisSize.min, // Garante que a coluna ocupe o mínimo de espaço
        children: [
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
          // Usamos Flexible e Text.rich para lidar com nomes muito longos 
          // sem quebrar o layout, mas preferimos maxLines e overflow: ellipsis
          // para manter a consistência com o design original de 1 linha.
          SizedBox(
            width: 80, // Largura fixa para o texto, igual à do _GroupPlantItem original
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
      // Removido height fixo ou BoxConstraints. Adicionaremos rolagem interna.
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
        // Usamos um Column e SingleChildScrollView aqui para garantir que 
        // todo o conteúdo do card (cabeçalho, descrição, lista de plantas)
        // possa rolar se o espaço for insuficiente, prevenindo overflows.
        child: Column(
          mainAxisSize: MainAxisSize.min, // Garante que a coluna não ocupe mais espaço que o necessário
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Cabeçalho com nome e botão do grupo
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

            // 🔹 Se houver plantas, mostramos a lista.
            // O Flexible/Expanded aqui permite que a lista de plantas ocupe
            // o espaço restante, e se precisar de mais, o SingleChildScrollView
            // externo (do card todo) vai lidar com a rolagem.
            if (plants.isNotEmpty)
              Flexible( // Usamos Flexible para que a lista de plantas possa encolher se necessário
                child: SingleChildScrollView( // Rolagem interna para a lista de plantas
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
                          physics: const NeverScrollableScrollPhysics(), // Desativa a rolagem do GridView
                          shrinkWrap: true, // Faz o GridView ocupar o espaço mínimo necessário
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
            // Se não houver plantas, talvez queiramos exibir uma mensagem ou um placeholder
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

