import 'package:flutter/material.dart';
import './add_player_page.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';
import '../main.dart';

class ListaAtletasPage extends StatefulWidget {
  const ListaAtletasPage({Key? key}) : super(key: key);

  @override
  _ListaAtletasPageState createState() => _ListaAtletasPageState();
}

class _ListaAtletasPageState extends State<ListaAtletasPage> {
  int currentPage = 4;
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Lista de Atletas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register_user');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(3, 110, 73, 1),
                  ),
                  child: const Text('Adicionar Atleta'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
