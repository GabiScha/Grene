// lib/views/plants_page.dart
import 'package:flutter/material.dart';
import '../models/planta.dart';
import '../services/planta_service.dart';
import '../services/grupo_service.dart';
import '../widgets/plant_widget.dart';
import '../widgets/group_widget.dart';
import 'plant_detail_page.dart';
import '../widgets/group_dialog.dart';
import 'package:grene/theme/colors/app_colors.dart';

class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  final PlantaService service = PlantaService();
  final GrupoService grupoService = GrupoService();

  late Future<List<dynamic>> futurasItens;
  Planta? plantaSelecionada;

  @override
  void initState() {
    super.initState();
    futurasItens = _carregarItens();
  }

  Future<List<dynamic>> _carregarItens() async {
    final plantasFuture = service.getPlantas();
    final gruposFuture = grupoService.listarGrupos();
    final results = await Future.wait([plantasFuture, gruposFuture]);

    final List<Planta> plantas = results[0] as List<Planta>;
    final List<Map<String, dynamic>> gruposRaw =
        (results[1] as List).cast<Map<String, dynamic>>();

    // mapa de plantas por id para lookup rápido
    final Map<int, Planta> plantasById = {for (var p in plantas) p.id: p};

    // limpa grupos inválidos e anexa lista real de Plantas (campo "plants")
    final List<Map<String, dynamic>> grupos = [];
    for (var g in gruposRaw) {
      final rawPots = (g["pots"] as List?) ?? [];
      final potIds = rawPots
          .map<int?>((p) {
            if (p is int) return p;
            if (p is Map && p["id"] != null) return (p["id"] as num).toInt();
            if (p is Map && p["pot"] != null) return (p["pot"] as num).toInt();
            if (p is String) return int.tryParse(p);
            return null;
          })
          .whereType<int>()
          .where((id) => plantasById.containsKey(id))
          .toList();

      if (potIds.isNotEmpty) {
        final List<Planta> plantObjs = potIds.map((id) => plantasById[id]!).toList();
        final copy = Map<String, dynamic>.from(g);
        copy["pot_ids"] = potIds;
        copy["plants"] = plantObjs; // adiciona lista de Plantas reais
        grupos.add(copy);
      }
    }

    // separa favoritos
    final favoritos = plantas.where((p) => (p.favorito ?? false)).toList();

    // pega todas as plantas que estão dentro de grupos
    final Set<int> plantasEmGrupos = {};
    for (var g in grupos) {
      final List<int> ids = (g["pot_ids"] as List<int>);
      plantasEmGrupos.addAll(ids);
    }

    // plantas que não são favoritas e NÃO estão em grupos (aparecem "soltas")
    final restantesSoltos = plantas.where((p) {
      final isFav = (p.favorito ?? false);
      final inGroup = plantasEmGrupos.contains(p.id);
      return !isFav && !inGroup;
    }).toList();

    // constrói lista final (favoritas primeiro, depois intercalar plantas e grupos)
    final List<dynamic> finalItems = [];
    final seenIds = <int>{};

    // adiciona favoritas primeiro (mantendo ordem)
    for (var f in favoritos) {
      if (!seenIds.contains(f.id)) {
        finalItems.add(f);
        seenIds.add(f.id);
      }
    }

    // intercala plantas soltas e grupos
    final List<Planta> plantsToInterleave = List.from(restantesSoltos);
    final List<Map<String, dynamic>> groupsToInterleave = List.from(grupos);

    final maxLen = (plantsToInterleave.length > groupsToInterleave.length)
        ? plantsToInterleave.length
        : groupsToInterleave.length;

    for (int i = 0; i < maxLen; i++) {
      if (i < plantsToInterleave.length) {
        finalItems.add(plantsToInterleave[i]);
      }
      if (i < groupsToInterleave.length) {
        finalItems.add(groupsToInterleave[i]);
      }
    }

    return finalItems;
  }

  Future<void> _refreshAll() async {
    try {
      setState(() {
        futurasItens = _carregarItens();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro ao recarregar: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 950;

      return FutureBuilder<List<dynamic>>(
        future: futurasItens,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text("Erro: ${snapshot.error}")));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return Scaffold(
              backgroundColor: AppColors.background,
              body: const Center(child: Text("Nenhuma planta ou grupo disponível")),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showDialog(context: context, builder: (_) => const GroupDialog())
                      .then((_) => _refreshAll());
                },
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                child: const Icon(Icons.group),
              ),
            );
          }

          Widget body;
          if (isWide) {
            // DESKTOP: grid à esquerda + detalhe à direita
            body = Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final it = items[index];
                      if (it is Planta) {
                        return HomePlantWidget(
                          name: it.nome,
                          plant: it.tipo,
                          img: "",
                          onPressed: () {
                            setState(() {
                              plantaSelecionada = it;
                            });
                          },
                        );
                      } else if (it is Map<String, dynamic>) {
                        final g = it;
                        final List<Planta> groupPlants =
                            (g["plants"] as List<dynamic>? ?? []).whereType<Planta>().toList();

                        return GroupWidget(
                          name: g["name"] ?? "Grupo",
                          description: g["description"] ?? "",
                          plants: groupPlants,
                          onPressed: () {
                            showDialog(context: context, builder: (_) => const GroupDialog())
                                .then((_) => _refreshAll());
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: plantaSelecionada == null
                      ? const Center(child: Text("Selecione uma planta"))
                      : PlantDetailPage(
                          key: ValueKey(plantaSelecionada!.id),
                          planta: plantaSelecionada!,
                        ),
                ),
              ],
            );
          } else {
            // MOBILE: lista vertical intercalada
            body = ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final it = items[index];
                if (it is Planta) {
                  return Column(
                    children: [
                      HomePlantWidget(
                        name: it.nome,
                        plant: it.tipo,
                        img: "",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlantDetailPage(planta: it)),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                } else if (it is Map<String, dynamic>) {
                  final g = it;
                  final List<Planta> groupPlants =
                      (g["plants"] as List<dynamic>? ?? []).whereType<Planta>().toList();

                  return Column(
                    children: [
                      GroupWidget(
                        name: g["name"] ?? "Grupo",
                        description: g["description"] ?? "",
                        plants: groupPlants,
                        onPressed: () {
                          showDialog(context: context, builder: (_) => const GroupDialog())
                              .then((_) => _refreshAll());
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          }

          return Scaffold(
            body: body,
            backgroundColor: AppColors.background,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(context: context, builder: (_) => const GroupDialog())
                    .then((_) => _refreshAll());
              },
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
              child: const Icon(Icons.group),
            ),
          );
        },
      );
    });
  }
}
