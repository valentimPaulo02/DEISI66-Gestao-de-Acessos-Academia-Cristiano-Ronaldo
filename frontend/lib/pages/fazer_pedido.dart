import 'package:flutter/material.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';
import '../main.dart';

class FazerPedidoPage extends StatefulWidget {
  const FazerPedidoPage({Key? key}) : super(key: key);

  @override
  _FazerPedidoPageState createState() => _FazerPedidoPageState();
}

class _FazerPedidoPageState extends State<FazerPedidoPage> {
  int currentPage = 2;
  late NavigationManager navigationManager;

  @override
  void initState() {
    super.initState();
    navigationManager = NavigationManager(context, currentPage);
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPage = index;
    });

    navigationManager.navigateToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(191, 191, 191, 0.8),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: CustomAppBar(
            currentPage: currentPage,
            onMenuItemSelected: _navigateToPage,
          ),
        ),
        drawer: AppPages(
          menuItems: menuItems,
          currentPageTitle: menuItems[currentPage - 1],
          currentPageIndex: currentPage,
          onMenuItemSelected: _navigateToPage,
          pageIcons: pageIcons,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              menuItems[currentPage - 1],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ));
  }
}
