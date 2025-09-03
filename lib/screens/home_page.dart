import 'package:flutter/material.dart';
import 'package:grene/models/planta.dart';
import 'package:grene/screens/login_page.dart';
import 'package:grene/screens/plants_page.dart';
import 'package:grene/services/planta_service.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:grene/widgets/plant_widget.dart';

// Página para exibir plantas

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
    PlantsPage(), //  2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final planta1 = HomePlantWidget(
    name: "Verdinha",
    plant: "Samambaia",
    img: "",
    onPressed: () {
    },
    );



  @override
  void initState() {
    super.initState();
    futurasPlantas = service.getPlantas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primary,
        type: BottomNavigationBarType.fixed, // Importante para mais de 3 itens sem shifting
        showSelectedLabels: false, // Oculta labels dos itens selecionados
        showUnselectedLabels: false, // Oculta labels dos itens não selecionados
        iconSize: 30, // Ajuste o tamanho dos ícones conforme necessário
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '', // Já está correto
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nature),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: AppColors.background, // Cor para ícones não selecionados
        onTap: _onItemTapped,
      ),
    );
  }
}
