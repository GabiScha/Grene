//============================================================
// ARQUIVO: views/home_page.dart
//============================================================
import 'package:flutter/material.dart';
import 'package:grene/views/config_page.dart';
import 'package:grene/views/plants_page.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:grene/views/user_page.dart';

//------------------------------------------------------------
// <HomePage> (View)
// -- Propósito: Container principal da navegação (Shell).
// -- Gerencia a troca entre as páginas: User, Plants e Config.
// -- Layout: Responsivo (Mobile/Desktop).
//------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //-- Estado: Controla a aba/página selecionada --
  int _selectedIndex = 1; // Inicia na página de Plantas
  final List<Widget> _pages = [UserPage(), PlantsPage(), ConfigPage()];

  //-- Ação: Atualiza o índice da página selecionada --
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //-- <LayoutBuilder> decide a navegação (AppBar vs BottomNavBar) --
    return LayoutBuilder(
      builder: (context, constraints) {
        
        //----------------------------------
        // <Layout Desktop> (constraints.maxWidth > 800)
        // -- Navegação via <AppBar> com TextButtons.
        //----------------------------------
        if (constraints.maxWidth > 800) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => _onItemTapped(0),
                    child: const Text(
                      "Conta",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 40),
                  TextButton(
                    onPressed: () => _onItemTapped(1),
                    child: const Text(
                      "Plantas",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 40),
                  TextButton(
                    onPressed: () => _onItemTapped(2),
                    child: const Text(
                      "Opções",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            //-- Exibe a página selecionada --
            body: _pages[_selectedIndex],
          );
        
        //----------------------------------
        // <Layout Mobile> (else)
        // -- Navegação via <BottomNavigationBar>.
        //----------------------------------
        } else {
          return Scaffold(
            backgroundColor: AppColors.background,
            //-- Exibe a página selecionada --
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: AppColors.primary,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              iconSize: 30,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.nature), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.black,
              unselectedItemColor: AppColors.background,
              onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}