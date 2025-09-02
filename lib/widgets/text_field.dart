import 'package:flutter/material.dart';
import 'package:grene/theme/colors/app_colors.dart';

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
        hoverColor: Colors.white,
        labelText: label,
        filled: true,
        fillColor: AppColors.primary.withValues(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(color: Colors.blueGrey)
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
