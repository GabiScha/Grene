//============================================================
// ARQUIVO: lib/views/plants_page.dart
//============================================================
import 'package:flutter/material.dart';
import '../models/planta.dart';
import '../services/planta_service.dart';
import '../services/grupo_service.dart';
import '../widgets/plant_widget.dart';
import '../widgets/group_widget.dart';
import 'plant_detail_page.dart';
import '../widgets/group_dialog.dart';
import 'package:grene/theme/colors/app_colors.dart';

//------------------------------------------------------------
// <PlantsPage> (View)
// -- Propósito: Tela principal que exibe a lista de plantas e grupos.
// -- Layout: Responsivo (Mobile/Desktop).
// -- Padrão Desktop: Master-Detail (Grid à esquerda, Detalhe à direita).
// -- Padrão Mobile: ListView (Navegação para página de detalhe).
//------------------------------------------------------------
class PlantsPage extends StatefulWidget {
  const PlantsPage({super.key});

  @override
  State<PlantsPage> createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  final PlantaService service = PlantaService();
  final GrupoService grupoService = GrupoService();

  //-- Estado: Controla os dados assíncronos (plantas e grupos) --
  late Future<List<dynamic>> futurasItens;
  //-- Estado (Desktop): Controla qual planta está selecionada no Master-Detail --
  Planta? plantaSelecionada;

  @override
  void initState() {
    super.initState();
    futurasItens = _carregarItens();
  }

  //------------------------------------------------------------
  // <_carregarItens>
  // -- Descrição: Orquestra a busca e organização de plantas e grupos.
  // -- Fluxo:
  //   1. Busca plantas e grupos simultaneamente (Future.wait).
  //   2. Processa grupos para anexar objetos <Planta> reais.
  //   3. Separa plantas favoritas.
  //   4. Separa plantas "soltas" (nem favoritas, nem em grupos).
  //   5. Constrói a lista final:
  //      a. Favoritas primeiro.
  //      b. Intercala plantas soltas e grupos restantes.
  // -- Retorno: <Future<List<dynamic>>> (Lista mista de <Planta> e <Map<String, dynamic>>)
  //------------------------------------------------------------
  Future<List<dynamic>> _carregarItens() async {
    final plantasFuture = service.getPlantas();
    final gruposFuture = grupoService.listarGrupos();
    final results = await Future.wait([plantasFuture, gruposFuture]);

    final List<Planta> plantas = results[0] as List<Planta>;
    final List<Map<String, dynamic>> gruposRaw =
        (results[1] as List).cast<Map<String, dynamic>>();

    //-- Mapa de plantas por id para lookup rápido --
    final Map<int, Planta> plantasById = {for (var p in plantas) p.id: p};

    //-- Limpa grupos inválidos e anexa lista real de Plantas (campo "plants") --
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

    //-- 1. Separa favoritos --
    final favoritos = plantas.where((p) => (p.favorito ?? false)).toList();

    //-- 2. Pega todas as plantas que estão dentro de grupos --
    final Set<int> plantasEmGrupos = {};
    for (var g in grupos) {
      final List<int> ids = (g["pot_ids"] as List<int>);
      plantasEmGrupos.addAll(ids);
    }

    //-- 3. Plantas que não são favoritas e NÃO estão em grupos (aparecem "soltas") --
    final restantesSoltos = plantas.where((p) {
      final isFav = (p.favorito ?? false);
      final inGroup = plantasEmGrupos.contains(p.id);
      return !isFav && !inGroup;
    }).toList();

    //-- 4. Constrói lista final --
    final List<dynamic> finalItems = [];
    final seenIds = <int>{}; // Evita duplicatas se favorita também estiver em grupo

    //-- Adiciona favoritas primeiro --
    for (var f in favoritos) {
      if (!seenIds.contains(f.id)) {
        finalItems.add(f);
        seenIds.add(f.id);
      }
    }

    //-- Intercala plantas soltas e grupos --
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

  //------------------------------------------------------------
  // <_refreshAll> (Ação)
  // -- Descrição: Dispara uma nova chamada de <_carregarItens>
  //   e atualiza o <FutureBuilder>.
  //------------------------------------------------------------
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
      //-- Ponto de quebra para o layout Master-Detail --
      final isWide = constraints.maxWidth > 1270;

      return FutureBuilder<List<dynamic>>(
        future: futurasItens,
        builder: (context, snapshot) {
          //-- Estados de Carregamento e Erro --
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text("Erro: ${snapshot.error}")));
          }

          final items = snapshot.data ?? [];
          
          //-- Seleciona a primeira planta (para Desktop) se nenhuma estiver selecionada --
          if (plantaSelecionada == null && items.isNotEmpty) {
            final firstPlant = items.firstWhere(
              (it) => it is Planta,
              orElse: () => null,
            );
            if (firstPlant is Planta) {
              plantaSelecionada = firstPlant;
            }
          }

          //-- Estado Vazio --
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
          
          //----------------------------------
          // <Layout Desktop> (isWide)
          // -- Master-Detail (Grid | Detalhe)
          //----------------------------------
          if (isWide) {
            body = Row(
              children: [
                //-- MASTER (Grid de Itens) --
                Expanded(
                  flex: 2,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final it = items[index];
                      //-- Renderiza <Planta> --
                      if (it is Planta) {
                        return HomePlantWidget(
                          name: it.nome,
                          plant: it.tipo,
                          img: it.img,
                          onPressed: () {
                            setState(() {
                              plantaSelecionada = it;
                            });
                          },
                        );
                      //-- Renderiza <Grupo> --
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
                          onPlantSelected: (planta) {
                            setState(() {
                              plantaSelecionada = planta;
                            });
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                //-- DETAIL (Página de Detalhe) --
                Expanded(
                  flex: 1,
                  child: plantaSelecionada == null
                      ? const Center(child: Text("Selecione uma planta"))
                      : PlantDetailPage(
                          //-- <ValueKey> força o widget a reconstruir
                          //   quando a planta selecionada muda.
                          key: ValueKey(plantaSelecionada!.id),
                          planta: plantaSelecionada!,
                        ),
                ),
              ],
            );
          
          //----------------------------------
          // <Layout Mobile> (else)
          // -- Lista Vertical (Navegação)
          //----------------------------------
          } else {
            body = ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final it = items[index];
                //-- Renderiza <Planta> --
                if (it is Planta) {
                  return Column(
                    children: [
                      HomePlantWidget(
                        name: it.nome,
                        plant: it.tipo,
                        img: it.img,
                        onPressed: () {
                          //-- Navega para a página de detalhe --
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlantDetailPage(planta: it)),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                //-- Renderiza <Grupo> --
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

          //-- Scaffold final com FAB --
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