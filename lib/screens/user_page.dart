import 'package:flutter/material.dart';

//Página do Usuario

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
