// Função: Um diálogo para gerenciar grupos de plantas (criar, listar, adicionar/remover plantas).
// Recebe:
// - potId: (Opcional) O ID da planta que está sendo adicionada/removida de um grupo.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grene/theme/colors/app_colors.dart';
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
      final novos = await _service.listarGrupos();
      if (!mounted) return;
            if (!mounted) return;
      setState(() {
        _grupos = Future.value(novos);
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Grupo criado com sucesso!")));
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
    final pots = ((grupo["pots"] as List?) ?? [])
        .map((p) => p is Map<String, dynamic> ? p["id"] as int : p as int)
        .toList();
    final contem = pots.contains(widget.potId);

    try {
      if (contem) {
        await _service.removerPlantaDoGrupo(grupoId, widget.potId!);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Planta removida do grupo!")));
      } else {
        await _service.adicionarPlantaAoGrupo(grupoId, widget.potId!);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Planta adicionada ao grupo!")));
      }
      final novos = await _service.listarGrupos();
      if (!mounted) return;
      if (!mounted) return;
        setState(() {
          _grupos = Future.value(novos);
        });

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro ao atualizar grupo: $e")));
    }
  }

  Future<void> _apagarGrupo(int id) async {
    try {
      await _service.deletarGrupo(id);
      final novos = await _service.listarGrupos();
      if (!mounted) return;
      if (!mounted) return;
      setState(() {
        _grupos = Future.value(novos);
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Grupo apagado.")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro ao apagar grupo: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 700;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isWide ? 480 : 360),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.backLightGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 48),
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Gerenciar Grupos",
                                style: GoogleFonts.quicksand(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white, size: 22),
                        splashRadius: 22,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _buildTextField(controller: _nameCtrl, label: "Nome do grupo"),
                  const SizedBox(height: 10),
                  _buildTextField(controller: _descCtrl, label: "Descrição"),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _criarGrupo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backGreen.withOpacity(0.8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 2,
                      ),
                      child: Text(
                        "Criar grupo",
                        style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.withOpacity(0.4), height: 24),

                  Flexible(
                    child: FutureBuilder(
                      future: _grupos,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text("Erro: ${snapshot.error}");
                        }

                        final grupos = snapshot.data ?? [];
                        if (grupos.isEmpty) {
                          return Text(
                            "Nenhum grupo criado ainda",
                            style: GoogleFonts.quicksand(color: Colors.grey[700]),
                          );
                        }

                        return SingleChildScrollView(
                          child: Column(
                            children: grupos.map<Widget>((g) {
                              final pots = ((g["pots"] as List?) ?? [])
                                  .map((p) => p is Map<String, dynamic>
                                      ? p["id"] as int
                                      : p as int)
                                  .toList();
                              final contem = widget.potId != null &&
                                  pots.contains(widget.potId);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: contem
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.white.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 3,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  title: Text(
                                    g["name"],
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  subtitle: g["description"] != null &&
                                          g["description"].toString().isNotEmpty
                                      ? Text(
                                          g["description"],
                                          style: GoogleFonts.quicksand(
                                              color: Colors.grey[700]),
                                        )
                                      : null,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (widget.potId != null)
                                        IconButton(
                                          icon: Icon(
                                            contem ? Icons.close : Icons.add,
                                            color: contem
                                                ? Colors.redAccent
                                                : Colors.green,
                                          ),
                                          onPressed: () =>
                                              _alternarPlantaNoGrupo(g),
                                        ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.grey),
                                        onPressed: () => _apagarGrupo(g["id"]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    final borderColor = AppColors.backGreen.withOpacity(0.5);
    return TextField(
      controller: controller,
      style: GoogleFonts.quicksand(fontSize: 14),
      cursorColor: AppColors.backGreen,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.quicksand(color: Colors.grey[700]),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: AppColors.backGreen, width: 1.5),
        ),
      ),
    );
  }
}