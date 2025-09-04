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

  @override
  void initState() {
    super.initState();
    futurasPlantas = service.getPlantas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<Planta>>(
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
      ),
    );
  }
}
