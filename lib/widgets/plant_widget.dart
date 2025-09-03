import 'package:flutter/material.dart';

class HomePlantWidget extends StatelessWidget {
  final String name;
  final String plant;
  final String img;
  final VoidCallback onPressed;

  const HomePlantWidget({
    super.key, 
    required this.name, 
    required this.plant,
    required this.img, 
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 200,
        width: 320,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // Imagem com tamanho ajustado
              Container(
                width: 130, // Largura fixa para a imagem
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  img, 
                  fit: BoxFit.cover, // Ajusta a imagem ao espaço disponível
                ), 
              ), 
              Expanded( // Usa Expanded para ocupar o espaço restante
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis, // Evita overflow de texto
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plant,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}