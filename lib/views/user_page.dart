import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/profile_icon.dart';
import '../widgets/config_button.dart';
import '../widgets/exit_button.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5DC),
            body: Row(
              children: [
                const SizedBox(width: 150),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ProfileIcon(),
                    const SizedBox(height: 30),
                    ConfigButton(
                      text: 'Meu Cadastro',
                      onPressed: () {},
                    ),
                    ConfigButton(
                      text: 'Privacidade e Segurança',
                      onPressed: () {},
                    ),
                    ConfigButton(
                      text: 'Política de privacidade',
                      onPressed: () {},
                    ),
                    ExitButton(
                      text: 'Sair da Conta',
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
                      color: const Color(0xFFCCEBD0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(width: 100),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F5DC),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ProfileIcon(),
                      const SizedBox(height: 10),
                      Text(
                        'Usuário',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 9),
                      ConfigButton(
                        text: 'Meu Cadastro',
                        onPressed: () {},
                      ),
                      ConfigButton(
                        text: 'Privacidade e Segurança',
                        onPressed: () {},
                      ),
                      ConfigButton(
                        text: 'Política de privacidade',
                        onPressed: () {},
                      ),
                      ExitButton(
                        text: 'Sair da Conta',
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