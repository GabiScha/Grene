import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/config_button.dart';
import '../widgets/config_icon.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Layout para PC
        if (constraints.maxWidth > 800) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5DC),
            body: Row(
              children: [
                const SizedBox(width: 150),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ConfigIcon(),
                    const SizedBox(height: 30),
                    ConfigButton(
                      text: 'Versão do aplicativo',
                      onPressed: () {},
                    ),
                    ConfigButton(
                      text: 'Modo Claro/Escuro',
                      onPressed: () {},
                    ),
                    ConfigButton(
                      text: 'Termos de Uso',
                      onPressed: () {},
                    ),
                    ConfigButton(
                      text: 'Central de ajuda/Fale Conosco',
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(width: 60),
                Expanded(
                  child: Container(
                    height: 500,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCDE7D8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(width: 100),
              ],
            ),
          );
        }

        // Layout para Mobile
        else {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F5DC),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ConfigIcon(),
                      const SizedBox(height: 10),
                      Text(
                        'Configurações',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w400,
                          fontSize: 30, 
                          color: Colors.black87, 
                        ),
                      ),
                      const SizedBox(height: 9),
                      ConfigButton(
                        text: 'Versão do aplicativo',
                        onPressed: () {},
                      ),
                      ConfigButton(
                        text: 'Modo Claro/Escuro',
                        onPressed: () {},
                      ),
                      ConfigButton(
                        text: 'Termos de Uso',
                        onPressed: () {},
                      ),
                      ConfigButton(
                        text: 'Central de ajuda/Fale Conosco',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}