import 'package:flutter/material.dart';

class ScpListObject extends StatelessWidget {
  final Color color;
  final String nome;
  final String qqString;
  final VoidCallback onPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final String? textoOpcional;
  final String? numeroString;

  ScpListObject({
    required this.color,
    required this.nome,
    required this.qqString,
    required this.onPressed,
    this.numeroString,
    this.onEditPressed,
    this.onDeletePressed,
    this.textoOpcional,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 73,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'lib/images/just_lion.png',
                height: 73,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (numeroString != null)
                    Text(
                      numeroString!,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    qqString,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (textoOpcional != null)
                    Text(
                      textoOpcional!,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEditPressed != null)
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: onEditPressed,
                    ),
                  if (onDeletePressed != null)
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: onDeletePressed,
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                    onPressed: onPressed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
