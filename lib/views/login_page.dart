// views/login_page.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/colors/app_colors.dart';
import '../widgets/green_button.dart';
import '../widgets/text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool loading = false;

  // Função de login
  void _login() async {
    setState(() => loading = true);

    // Chama o service corretamente
    bool success = await ApiService.login(
      _userController.text,
      _passController.text,
    );

    setState(() => loading = false);

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Usuário ou senha inválidos"),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 950) {
          // PC
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Login",
                              style: GoogleFonts.quicksand(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent)),
                          const SizedBox(height: 40),
                          CustomTextField(
                              label: "Email", controller: _userController),
                          const SizedBox(height: 16),
                          CustomTextField(
                              label: "Senha",
                              controller: _passController,
                              obscureText: true),
                          const SizedBox(height: 20),
                          CustomButton(text: "Entrar", onPressed: _login),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter, // encosta no chão
                      child: Image.asset(
                        "lib/assets/img/potplant-nobackground-removebg-preview.png",
                        fit: BoxFit.contain,
                        height: 700, // ajusta o tamanho da planta
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // MOBILE
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Login",
                        style: GoogleFonts.quicksand(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent)),
                    const SizedBox(height: 40),
                    CustomTextField(label: "Email", controller: _userController),
                    const SizedBox(height: 16),
                    CustomTextField(
                        label: "Senha",
                        controller: _passController,
                        obscureText: true),
                    const SizedBox(height: 20),
                    CustomButton(text: "Entrar", onPressed: _login),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
