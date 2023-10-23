import 'package:flutter/material.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';
import '../main.dart';

class ListaSupervisoresPage extends StatefulWidget {
  const ListaSupervisoresPage({Key? key}) : super(key: key);

  @override
  _ListaSupervisoresPageState createState() => _ListaSupervisoresPageState();
}

class _ListaSupervisoresPageState extends State<ListaSupervisoresPage> {
  int currentPage = 5;
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
      backgroundColor: const Color.fromRGBO(191, 191, 191, 1),
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
      body: Center(
        child: Text(
          menuItems[currentPage - 1],
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
