import 'package:flutter/material.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/services/planta_service.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:grene/widgets/plant_widget.dart';
import 'package:grene/screens/plant_detail_page.dart';

// Página para exibir plantas
class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  final PlantaService service = PlantaService();
  late Future<List<Planta>> futurasPlantas;
  Planta? plantaSelecionada;

  @override
  void initState() {
    super.initState();
    futurasPlantas = service.getPlantas();
  }

  @override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 950) {
        // PC
        return FutureBuilder<List<Planta>>(
          future: futurasPlantas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erro: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Nenhuma planta cadastrada"));
            }

            final plantas = snapshot.data!;
            plantaSelecionada ??= plantas[0];

            return Row(
              children: [
                // Esquerda: grid de plantas (2/3 da tela)
                Expanded(
                  flex: 2, // <-- 2/3
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250, // largura máxima de cada card
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.9, // ajusta proporção altura/largura
                      ),
                    itemCount: plantas.length,
                    itemBuilder: (context, index) {
                      final planta = plantas[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            plantaSelecionada = planta;
                          });
                        },
                        child: HomePlantWidget(
                          name: planta.nome,
                          plant: "Samambaia",
                          img: "",
                          onPressed: () {
                            setState(() {
                              plantaSelecionada = planta;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Direita: detalhes da planta (1/3 da tela)
                Expanded(
                  flex: 1, // <-- 1/3
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // padding ao redor dos detalhes
                    child: plantaSelecionada == null
                        ? const Center(child: Text("Selecione uma planta"))
                        : PlantDetailPage(planta: plantaSelecionada!),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        // Mobile
        return FutureBuilder<List<Planta>>(
          future: futurasPlantas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erro: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Nenhuma planta cadastrada"));
            }

            final plantas = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: plantas.length,
              itemBuilder: (context, index) {
                final planta = plantas[index];
                return Column(
                  children: [
                    HomePlantWidget(
                      name: planta.nome,
                      plant: "Samambaia",
                      img: "",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantDetailPage(planta: planta),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            );
          },
        );
      }
    },
  );
}
}