import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grene/theme/colors/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PlantAnimated extends StatefulWidget {
  final String estado;

  const PlantAnimated({super.key, required this.estado});

  @override
  State<PlantAnimated> createState() => _PlantAnimatedState();
}

class _PlantAnimatedState extends State<PlantAnimated> {
  bool _down = true;
  bool _blinkDown = false; // controla o piscar
  bool _olhada = false;

  @override
  void initState() {
    super.initState();
    // animação de "balanço"
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _down = !_down;
      });
    });

    // animação de piscar
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _blinkDown = true;
      });

      // volta o olho depois de 300ms (tempo do piscar)
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _blinkDown = false;
          });
        }
      });
    });

    //animação triste
    Timer.periodic(const Duration(seconds: 15), (timer) {
      setState(() {
        _olhada = true;
      });

      // volta o olho depois de 300ms (tempo do piscar)
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _olhada = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.estado == "Feliz") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 70),
          Center(
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(top: _down ? 100 : 107),
              height: 320,
              width: 200,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  Positioned(
                    bottom: 145,
                    right: 26,
                    child: Container(
                      height: 10,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 150, 185),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 120,
                    right: -15,
                    child: Container(
                      height: 10,
                      width: 28,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(100),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 40,
                    right: -15,
                    child: Container(
                      height: 10,
                      width: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(100),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 50,
                    left: -15,
                    child: Container(
                      height: 10,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(0),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 170,
                    left: -10,
                    child: Container(
                      height: 10,
                      width: 20,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(0),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: -15,
                    left: 50,
                    child: Container(
                      height: 25,
                      width: 10,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                      ),
                    ),
                  ),

                  


                  Positioned(
                    bottom: 120,
                    right: 80,
                    child: Container(
                      height: 30,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 120,
                    right: 82.5,
                    child: Container(
                      height: 30,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 145,
                    left: 26,
                    child: Container(
                      height: 10,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 150, 185),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                      ),
                    ),
                  ),


                  Positioned(
                    bottom: 145,
                    right: 26,
                    child: Container(
                      height: 10,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 150, 185),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                      ),
                    ),
                  ),


                  Positioned(
                    bottom: 160,
                    left: 35,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      height: _blinkDown ? 20 : 70,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: _blinkDown
                          ? null
                          : Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  right: 5,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape:
                                          BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  Positioned(
                    bottom: 160,
                    right: 35,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      height: _blinkDown ? 20 : 70,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: _blinkDown
                          ? null
                          : Stack(
                              children: [
                                Positioned(
                                  top: 10, // ajusta pra onde você quer
                                  right: 5, // ajusta também
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape:
                                          BoxShape.circle, // bolinha perfeita
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: Container(
              height: 250,
              width: 310,
              decoration: BoxDecoration(
                color: AppColors.pot_color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Center(
                child: Text(
                  widget.estado,
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
          ),
        ],
      );







    } else if (widget.estado == "Triste: minha terrinha está seca, rega por favor"){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 70),
          Center(
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(top: _down ? 100 : 107),
              height: 320,
              width: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 187, 192, 120),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  

                  Positioned(
                    bottom: 120,
                    right: -15,
                    child: Container(
                      height: 10,
                      width: 28,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(100),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 40,
                    right: -15,
                    child: Container(
                      height: 10,
                      width: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(100),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 50,
                    left: -15,
                    child: Container(
                      height: 10,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(0),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 170,
                    left: -10,
                    child: Container(
                      height: 10,
                      width: 20,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(0),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: -15,
                    left: 50,
                    child: Container(
                      height: 25,
                      width: 10,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                      ),
                    ),
                  ),

                  


                  Positioned(
                    bottom: 140,
                    right: 82.5,
                    child: Container(
                      height: 20,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 150,
                    left: 46,
                    child: AnimatedContainer(
                     duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      height: _down ? 70 : 60,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                      ),
                    ),
                  ),


                  Positioned(
                    top: 150,
                    right: 46,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      height: _down ? 70 : 60,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                      ),
                    ),
                  ),


                  Positioned(
                    bottom: 160,
                    left: 35,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      height: _olhada ? 70 : 20,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: _olhada
                          ? Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  right: 5,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape:
                                          BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : null
                    ),
                  ),

                  Positioned(
                    bottom: 160,
                    right: 35,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      height: _olhada ? 70 : 20,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: _olhada
                          ? Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  right: 5,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape:
                                          BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : null
                    ),
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: Container(
              height: 250,
              width: 310,
              decoration: BoxDecoration(
                color: AppColors.pot_color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Center(
                child: Text(
                  widget.estado,
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 70),
          Center(
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(top: _down ? 100 : 107),
              height: 320,
              width: 200,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  

                  Positioned(
                    bottom: 120,
                    right: -15,
                    child: Container(
                      height: 10,
                      width: 28,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(100),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 40,
                    right: -15,
                    child: Container(
                      height: 10,
                      width: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(100),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 50,
                    left: -15,
                    child: Container(
                      height: 10,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(0),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 170,
                    left: -10,
                    child: Container(
                      height: 10,
                      width: 20,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(0),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: -15,
                    left: 50,
                    child: Container(
                      height: 25,
                      width: 10,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                      ),
                    ),
                  ),

                  


                  Positioned(
                    bottom: 140,
                    right: 82.5,
                    child: Container(
                      height: 20,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 150,
                    left: 46,
                    child: AnimatedContainer(
                     duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      height: _down ? 70 : 60,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                      ),
                    ),
                  ),


                  Positioned(
                    top: 150,
                    right: 46,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      height: _down ? 70 : 60,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                      ),
                    ),
                  ),


                  Positioned(
                    bottom: 160,
                    left: 35,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      height: _olhada ? 70 : 20,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: _olhada
                          ? Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  right: 5,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape:
                                          BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : null
                    ),
                  ),

                  Positioned(
                    bottom: 160,
                    right: 35,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      height: _olhada ? 70 : 20,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: _olhada
                          ? Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  right: 5,
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape:
                                          BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : null
                    ),
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: Container(
              height: 250,
              width: 310,
              decoration: BoxDecoration(
                color: AppColors.pot_color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Center(
                child: Text(
                  widget.estado,
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
