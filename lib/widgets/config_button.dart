import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfigButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ConfigButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7BBF8C),
          foregroundColor: const Color(0xFFF7F5DC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(500, 60), 
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: const Color(0xFFF7F5DC),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: const Color(0xFFF7F5DC),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}