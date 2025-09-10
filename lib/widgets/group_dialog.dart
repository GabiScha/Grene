import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class GroupDialog extends StatefulWidget {
  const GroupDialog({super.key});

  @override
  State<GroupDialog> createState() => _GroupDialogState();
}

class _GroupDialogState extends State<GroupDialog> {
  List<String> _groups = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final groups = await StorageService.getAllGroups();
    setState(() {
      _groups = groups;
    });
  }

  // Future<void> _createGroup() async {
  //   final name = _controller.text.trim();
  //   if (name.isNotEmpty) {
  //     await StorageService.createGroup(name);
  //     _controller.clear();
  //     _loadGroups();
  //   }
  // }

  // Future<void> _deleteGroup(String group) async {
  //   await StorageService.deleteGroup(group);
  //   _loadGroups();
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Gerenciar Grupos"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Novo grupo",
              suffixIcon: Icon(Icons.add),
            ),
            onSubmitted: (_) => (){},
          ),
          const SizedBox(height: 16),
          if (_groups.isEmpty)
            const Text("Nenhum grupo criado ainda"),
          if (_groups.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _groups.length,
                itemBuilder: (context, index) {
                  final group = _groups[index];
                  return ListTile(
                    title: Text(group),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {},
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Fechar"),
        ),
      ],
    );
  }
}
