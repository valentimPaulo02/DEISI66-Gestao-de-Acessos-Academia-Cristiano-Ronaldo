import 'package:deisi66/main.dart';
import 'package:flutter/material.dart';

class NavigationManager {
  final BuildContext context;
  int currentPage;

  NavigationManager(this.context, {required this.currentPage});

  void navigateToPage(int index) {
    String routeName;

    switch (index) {
      case 1:
        routeName = '/home';
        break;
      case 2:
        routeName = '/fazer_pedido_temporario';
        break;
      case 3:
        routeName = '/fazer_pedido_fim_de_semana';
        break;
      case 4:
        routeName = '/consultar_pedido';
        break;
      case 5:
        routeName = '/lista_de_atletas';
        break;
      case 6:
        routeName = '/lista_de_supervisores';
        break;
      default:
        routeName = '/';
    }

    Navigator.pop(context);
    Navigator.of(context).pushNamed(routeName);
    currentPage = index;
  }
}
