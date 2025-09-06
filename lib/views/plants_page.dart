// views/plants_page.dart
import 'package:flutter/material.dart';
import '../models/planta.dart';
import '../services/planta_service.dart';
import '../widgets/plant_widget.dart';
import 'plant_detail_page.dart';

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
    futurasPlantas = service.getPlantas(); // chama o service corretamente
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
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
                  Expanded(
                    flex: 2,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 250,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.9),
                      itemCount: plantas.length,
                      itemBuilder: (context, index) {
                        final planta = plantas[index];
                        return HomePlantWidget(
                          name: planta.nome,
                          plant: planta.tipo,
                          img: "",
                          onPressed: () {
                            setState(() {
                              plantaSelecionada = planta;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: plantaSelecionada == null
                        ? const Center(child: Text("Selecione uma planta"))
                        : PlantDetailPage(planta: plantaSelecionada!),
                  ),
                ],
              );
            });
      } else {
        // MOBILE
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
                          plant: planta.tipo,
                          img: "",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlantDetailPage(planta: planta),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  });
            });
      }
    });
  }
}
