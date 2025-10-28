//============================================================
// ARQUIVO: views/login_page.dart
//============================================================
import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Alterado de AuthController para ApiService
import '../theme/colors/app_colors.dart';
import '../widgets/green_button.dart';
import '../widgets/text_field.dart';
import 'package:google_fonts/google_fonts.dart';

//------------------------------------------------------------
// <LoginPage> (View)
// -- Propósito: Tela de login para autenticação do usuário.
// -- Layout: Responsivo (Mobile/Desktop).
//------------------------------------------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //-- Controladores para os campos de texto --
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool loading = false; // Estado de carregamento

  //------------------------------------------------------------
  // <_login> (Ação)
  // -- Descrição: Tenta autenticar o usuário via <ApiService>.
  // -- Fluxo:
  //   1. Define <loading> = true.
  //   2. Chama <ApiService.login>.
  //   3. Se sucesso -> Navega para "/home".
  //   4. Se falha   -> Mostra <SnackBar> de erro.
  //   5. Define <loading> = false.
  //------------------------------------------------------------
  void _login() async {
    setState(() => loading = true);

    // Chama o service diretamente
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
    //-- <LayoutBuilder> decide entre layout Mobile ou Desktop --
    return LayoutBuilder(
      builder: (context, constraints) {
        
        //----------------------------------
        // <Layout Desktop> (constraints.maxWidth > 950)
        // -- Layout em Row (Formulário | Imagem)
        //----------------------------------
        if (constraints.maxWidth > 950) {
          // PC
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                children: [
                  //-- Formulário (Esquerda) --
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
                  //-- Imagem (Direita) --
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
        
        //----------------------------------
        // <Layout Mobile> (else)
        // -- Layout em Column (Formulário centrado)
        //----------------------------------
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