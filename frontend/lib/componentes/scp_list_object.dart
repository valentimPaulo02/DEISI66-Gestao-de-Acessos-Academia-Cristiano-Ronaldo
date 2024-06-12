import 'package:flutter/material.dart';

class ScpListObject extends StatelessWidget {
  final String nome;
  final String numero;
  final String qqString;
  final VoidCallback onPressed;

  ScpListObject({
    required this.nome,
    required this.numero,
    required this.qqString,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 409,
      height: 73,
      decoration: BoxDecoration(
        color: Colors.green, //MUDAR COR DA LISTA DPS
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'lib/images/leaoPages.png', //ALTERAR ISTO PARA A IMAGEM CORRETA
                height: 73,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    numero,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                qqString,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                ),
                onPressed: onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
