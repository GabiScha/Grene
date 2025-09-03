import 'package:flutter/material.dart';
import 'package:grene/services/api_service.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:grene/widgets/green_button.dart';
import 'package:grene/widgets/text_field.dart';

//Página de Login

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool loading = false;

  void _login() async {
    setState(() => loading = true);
    bool success = await ApiService.login(
      _userController.text,
      _passController.text,
    );
    setState(() => loading = false);

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuário ou senha inválidos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 40),

              CustomTextField(
                label: "Email",
                controller: _userController,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Senha",
                controller: _passController,
                obscureText: true,
              ),
              const SizedBox(height: 20),

              CustomButton(
                text: "Entrar",
                onPressed: _login,
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Esqueceu a senha?",
                  style: TextStyle(color: AppColors.text),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Não tem os nossos produtos?"),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Compre aqui!",
                  style: TextStyle(color: AppColors.accent),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

