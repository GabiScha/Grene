import 'package:flutter/material.dart';

//Página de Configurações

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {



        //PC



        if (constraints.maxWidth > 800) {
          return Scaffold(

            //front aq

          );
    }






    else {



      //MOBILE



      return Scaffold(

            //front aq

      );
    }
  }
  );
 }
}
