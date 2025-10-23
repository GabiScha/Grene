import 'package:flutter/material.dart';
import '../services/grupo_service.dart';

class GroupDialog extends StatefulWidget {
  final int? potId;

  const GroupDialog({super.key, this.potId});

  @override
  State<GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  final GrupoService _service = GrupoService();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  late Future<List<Map<String, dynamic>>> _grupos;

  @override
  void initState() {
    super.initState();
    _grupos = _service.listarGrupos();
  }

    Future<void> _criarGrupo() async {
    if (_nameCtrl.text.isEmpty) return;
    try {
      await _service.criarGrupo(_nameCtrl.text, _descCtrl.text);

      // Espera os grupos antes de chamar setState
      final novos = await _service.listarGrupos();

      if (!mounted) return;
      setState(() {
        _grupos = Future.value(novos);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Grupo criado com sucesso!")),
      );

      _nameCtrl.clear();
      _descCtrl.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro: $e")));
    }
  }


    Future<void> _alternarPlantaNoGrupo(Map<String, dynamic> grupo) async {
    if (widget.potId == null) return;

    final grupoId = grupo["id"];

    // ✅ Corrigido: trata tanto lista de IDs quanto lista de objetos
    final pots = ((grupo["pots"] as List?) ?? [])
        .map((p) => p is Map<String, dynamic> ? p["id"] as int : p as int)
        .toList();

    final contem = pots.contains(widget.potId);

    try {
      if (contem) {
        await _service.removerPlantaDoGrupo(grupoId, widget.potId!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Planta removida do grupo!")),
        );
      } else {
        await _service.adicionarPlantaAoGrupo(grupoId, widget.potId!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Planta adicionada ao grupo!")),
        );
      }

      // 🔹 Atualiza grupos após a alteração (sem async dentro do setState)
      final novos = await _service.listarGrupos();
      if (!mounted) return;
      setState(() {
        _grupos = Future.value(novos);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao atualizar grupo: $e")),
      );
    }
  }


  Future<void> _apagarGrupo(int id) async {
  try {
    await _service.deletarGrupo(id);

    // primeiro aguarda o resultado
    final novos = await _service.listarGrupos();

    // depois atualiza o estado (sem async dentro do setState)
    if (!mounted) return;
    setState(() {
      _grupos = Future.value(novos);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Grupo apagado.")),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro ao apagar grupo: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Gerenciar Grupos"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Nome do grupo"),
            ),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _criarGrupo,
              child: const Text("Criar grupo"),
            ),
            const Divider(height: 24),
            FutureBuilder(
              future: _grupos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Erro: ${snapshot.error}");
                }

                final grupos = snapshot.data ?? [];
                if (grupos.isEmpty) {
                  return const Text("Nenhum grupo criado ainda");
                }

                return Column(
                  children: grupos.map<Widget>((g) {
                    // ✅ Converte lista de objetos/IDs em lista de ints
                    final pots = ((g["pots"] as List?) ?? [])
                        .map((p) => p is Map<String, dynamic> ? p["id"] as int : p as int)
                        .toList();

                    final contem = widget.potId != null && pots.contains(widget.potId);

                    return Container(
                      decoration: BoxDecoration(
                        color: contem
                            ? Colors.green.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ListTile(
                        title: Text(g["name"]),
                        subtitle: Text(g["description"] ?? ""),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.potId != null)
                              IconButton(
                                icon: Icon(contem ? Icons.close : Icons.add),
                                color: contem ? Colors.red : Colors.green,
                                onPressed: () => _alternarPlantaNoGrupo(g),
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () {
                                  _apagarGrupo(g["id"]);
                                },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
