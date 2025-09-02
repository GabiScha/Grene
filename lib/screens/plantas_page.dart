import 'package:flutter/material.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/services/planta_service.dart';

class PlantasPage extends StatefulWidget {
  const PlantasPage({super.key});

  @override
  State<PlantasPage> createState() => _PlantasPageState();
}

class _PlantasPageState extends State<PlantasPage> {
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
      appBar: AppBar(title: const Text("PLANTAS")),
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
            itemCount: plantas.length,
            itemBuilder: (context, index) {
              final planta = plantas[index];
              return ListTile(
                title: Text(planta.nome),
              );
            },
          );
        },
      ),
    );
  }
}
