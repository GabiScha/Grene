// Função: Um botão estilizado especificamente para ações de sair ou logout.
// Recebe:
// - text: O rótulo exibido no botão.
// - onPressed: A função a ser chamada quando o botão é pressionado.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExitButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ExitButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 800 ? 22 : 18;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6FD8A3),
          foregroundColor: const Color(0xFFF7F5DC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(450, 60),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w400,
                fontSize: fontSize,
                color: const Color(0xFFF7F5DC),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFF7F5DC),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}