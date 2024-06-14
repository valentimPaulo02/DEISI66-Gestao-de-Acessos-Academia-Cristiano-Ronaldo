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
        routeName = '/pedido_saida_temporaria';
        break;
      case 3:
        routeName = '/pedido_saida_fim_de_semana';
        break;
      case 4:
        routeName = '/consultar_pedidos';
        break;
      case 5:
        routeName = '/lista_de_atletas';
        break;
      case 6:
        routeName = '/lista_de_supervisores';
        break;
      case 7:
        routeName = 'lista_de_presenças';
      default:
        routeName = '/';
    }

    Navigator.pop(context);
    Navigator.of(context).pushNamed(routeName);
    currentPage = index;
  }
}
