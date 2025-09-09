import 'package:flutter/material.dart';
import 'package:grene/views/config_page.dart';
import 'package:grene/views/plants_page.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:grene/views/user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  final List<Widget> _pages = [UserPage(), PlantsPage(), ConfigPage()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
            body: _pages[_selectedIndex],
          );
        } else {
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
