//============================================================
// ARQUIVO: views/term_page.dart
//============================================================
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

//------------------------------------------------------------
// <TermPage> (View)
// -- Propósito: Tela reutilizável para exibir textos longos (Termos).
// -- Recebe: <title>, <content> (string) e <pdfAsset> (caminho).
// -- Obs: A variável <pdfAsset> não está sendo usada no build.
//------------------------------------------------------------
class TermPage extends StatelessWidget {
  final String title;
  final String content;
  final String pdfAsset;

  const TermPage({
    super.key,
    required this.title,
    required this.content,
    required this.pdfAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFCCEBD0),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          //-- <TextField> ReadOnly para permitir seleção e rolagem --
          child: TextField(
            controller: TextEditingController(text: content),
            readOnly: true,
            maxLines: null,
            style: const TextStyle(fontSize: 16, height: 1.5),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
      ),
    );
  }
}