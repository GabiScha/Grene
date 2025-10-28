//============================================================
// ARQUIVO: views/user_page.dart
//============================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/profile_icon.dart';
import '../widgets/config_button.dart';
import '../widgets/exit_button.dart';
import 'term_page.dart';

//-- Importa os textos estáticos dos termos --
import 'package:grene/assets/texts/termo_uso.dart';
import 'package:grene/assets/texts/termo_consentimento.dart';

//------------------------------------------------------------
// <UserPage> (View)
// -- Propósito: Tela de perfil do usuário e acesso aos termos legais.
// -- Layout: Responsivo (Mobile/Desktop).
// -- Padrão Desktop: Master-Detail (Menu | Visualizador de Termo).
// -- Padrão Mobile: ListView (Menu) com navegação para <TermPage>.
//------------------------------------------------------------
class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  //-- Estado (Desktop): Controla qual termo está sendo exibido no painel --
  String? _selectedTerm; // 'uso' ou 'consentimento'

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;

        //----------------------------------
        // <Layout Desktop> (isDesktop)
        // -- Layout em Row (Master-Detail)
        //----------------------------------
        if (isDesktop) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5DC),
            body: Row(
              children: [
                const SizedBox(width: 150),

                //-- MASTER (Coluna de Botões) --
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
                      text: 'Termo de Uso',
                      onPressed: () {
                        //-- Atualiza o estado para exibir o termo no painel --
                        setState(() => _selectedTerm = 'uso');
                      },
                    ),

                    ConfigButton(
                      text: 'Termo de Consentimento',
                      onPressed: () {
                        //-- Atualiza o estado para exibir o termo no painel --
                        setState(() => _selectedTerm = 'consentimento');
                      },
                    ),

                    ExitButton(
                      text: 'Sair da Conta',
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(width: 60),

                //-- DETAIL (Painel Verde) --
                Expanded(
                  child: Container(
                    height: 500,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCEBD0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    //-- Exibe o texto do termo selecionado --
                    child: _selectedTerm == null
                        ? Center(
                            child: Text(
                              '',
                              style: GoogleFonts.quicksand(fontSize: 18),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: TextField(
                                controller: TextEditingController(
                                  text: _selectedTerm == 'uso'
                                      ? termoUsoText
                                      : termoConsentimentoText,
                                ),
                                readOnly: true,
                                maxLines: null,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(12),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),

                const SizedBox(width: 100),
              ],
            ),
          );
        }

        //----------------------------------
        // <Layout Mobile> (else)
        // -- Layout em Column (Navegação)
        //----------------------------------
        else {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F5DC),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
                        text: 'Termo de Uso',
                        onPressed: () {
                          //-- Navega para a <TermPage> --
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TermPage(
                                title: 'Termo de Uso',
                                content: termoUsoText,
                                pdfAsset: 'assets/docs/TERMO DE USO.pdf',
                              ),
                            ),
                          );
                        },
                      ),

                      ConfigButton(
                        text: 'Termo de Consentimento',
                        onPressed: () {
                          //-- Navega para a <TermPage> --
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TermPage(
                                title: 'Termo de Consentimento',
                                content: termoConsentimentoText,
                                pdfAsset: 'assets/docs/TERMO DE CONSENTIMENTO.pdf',
                              ),
                            ),
                          );
                        },
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