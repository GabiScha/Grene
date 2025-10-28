// Função: Um campo de entrada de texto estilizado.
// Recebe:
// - label: O rótulo exibido acima ou dentro do campo.
// - obscureText: (Opcional) Se o texto deve ser ocultado (para senhas). Padrão é falso.
// - controller: O controlador para gerenciar o texto do campo.
import 'package:flutter/material.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        focusColor: Colors.white,
        hoverColor: AppColors.backLightGreen,
        labelText: label,
        filled: true,
        // fillColor: AppColors.primary.withValues(), // .withValues() não existe, ajuste necessário
        fillColor: AppColors.primary, // Usando a cor primária diretamente
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: GoogleFonts.quicksand(color: Colors.blueGrey)
      ),
      style: GoogleFonts.quicksand(color: Colors.white),
    );
  }
}