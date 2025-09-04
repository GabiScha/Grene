import 'package:flutter/material.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/screens/config_page.dart';
import 'package:grene/screens/login_page.dart';
import 'package:grene/screens/plants_page.dart';
import 'package:grene/services/planta_service.dart';
import 'package:grene/theme/colors/app_colors.dart';

// Página para exibir a pagina atual, e a appbar



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PlantaService service = PlantaService();
  late Future<List<Planta>> futurasPlantas;


  int _selectedIndex = 1;

  // Lista de páginas correspondentes a cada item da navegação
  final List<Widget> _pages = [
    LoginPage(), //  0
    PlantsPage(), //  1 
    ConfigPage(), //  2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  void initState() {
    super.initState();
    futurasPlantas = service.getPlantas();
  }

  @override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 800) {
        // PC -> AppBar em cima
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => _onItemTapped(0),
                  child: const Text("Conta", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 40),
                TextButton(
                  onPressed: () => _onItemTapped(1),
                  child: const Text("Plantas", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 40),
                TextButton(
                  onPressed: () => _onItemTapped(2),
                  child: const Text("Opções", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: _pages[_selectedIndex],
        );
      } else {
        // Mobile -> BottomNavigation
        return Scaffold(
          backgroundColor: AppColors.background,
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
