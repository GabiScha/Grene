// import 'package:flutter/material.dart';
// class NovaPlantaPage extends StatefulWidget {
//   const NovaPlantaPage({super.key});

//   @override
//   State<NovaPlantaPage> createState() => _NovaPlantaPageState();
// }

// class _NovaPlantaPageState extends State<NovaPlantaPage> {
//   final TextEditingController nomeController = TextEditingController();

//   Future<void> criarPlanta() async {
//     final response = await http.post(
//       Uri.parse("http://127.0.0.1:8000/api/plantas/"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "nome": nomeController.text,
//       }),
//     );

//     if (response.statusCode == 201) {
//       Navigator.pop(context); // volta pra lista
//     } else {
//       print("Erro ao criar planta: ${response.body}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Nova Planta")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: nomeController,
//               decoration: const InputDecoration(labelText: "Nome da Planta"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: criarPlanta,
//               child: const Text("Salvar"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
