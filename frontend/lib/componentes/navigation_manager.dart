import 'package:flutter/material.dart';

class NavigationManager {
  final BuildContext context;
  int currentPage;

  NavigationManager(this.context, this.currentPage);

  void navigateToPage(int index) {
    String routeName = _getRouteName(index);
    Navigator.pop(context);
    Navigator.of(context).pushNamed(routeName);
    currentPage = index;
  }

  String _getRouteName(int index) {
    switch (index) {
      case 1:
        return '/home';
      case 2:
        return '/fazer_pedido';
      case 3:
        return '/consultar_pedido';
      case 4:
        return '/lista_de_Atletas';
      case 5:
        return '/lista_de_supervisores';
      default:
        return '/';
    }
  }
}
