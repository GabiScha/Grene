import 'package:flutter/material.dart';
import 'package:grene/services/api_service.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:grene/widgets/green_button.dart';
import 'package:grene/widgets/text_field.dart';
import 'package:google_fonts/google_fonts.dart';

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
        const SnackBar(content: Text("Usuário ou senha inválidos"),
        backgroundColor: AppColors.primary,),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 950) {


        //PC


        return Scaffold(
          backgroundColor: AppColors.background,
          body: Padding(
            padding: EdgeInsetsGeometry.directional(start: 60, end: 60),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsetsGeometry.directional(start: 90, end: 90, top: 24, bottom: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: GoogleFonts.quicksand(
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
                            child: Text(
                              "Esqueceu a senha?",
                              style: GoogleFonts.quicksand(color: AppColors.text),
                            ),
                          ),
                          const SizedBox(height: 20),
            
                          Text(
                            "Não tem os nossos produtos?",
                            style: GoogleFonts.quicksand(),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Compre aqui!",
                              style: GoogleFonts.quicksand(color: AppColors.accent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            
                // Lado da Imagem
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.black,
                    child: Image.asset(
                      "assets/imagem.png", // substitua pelo caminho certo
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }






    else {



      //MOBILE



      return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: GoogleFonts.quicksand(
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
                child: Text(
                  "Esqueceu a senha?",
                  style: GoogleFonts.quicksand(color: AppColors.text),
                ),
              ),
              const SizedBox(height: 20),

              Text("Não tem os nossos produtos?", style: GoogleFonts.quicksand(),),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Compre aqui!",
                  style: GoogleFonts.quicksand(color: AppColors.accent),
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
  );
 }
}
