import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_page.dart';
import 'screens/plantas_page.dart';

void main() {
  runApp(const GreneApp());
}

class GreneApp extends StatelessWidget {
  const GreneApp({super.key});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grene App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // 🔑 Verifica login antes de decidir a tela inicial
      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data! ? const PlantasPage() : LoginPage();
        },
      ),
      routes: {
        "/login": (context) => LoginPage(),
        "/home": (context) => const PlantasPage(),
      },
    );
  }
}
