// Função: Exibe o ícone de configuração (imagem de engrenagem em um container estilizado).
// Recebe: Nada.
import 'package:flutter/material.dart';

class ConfigIcon extends StatelessWidget {
  const ConfigIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF40985E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            child: Image.asset(
              "lib/assets/img/engrenagem.png",
              width: 140,
              height: 140,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}