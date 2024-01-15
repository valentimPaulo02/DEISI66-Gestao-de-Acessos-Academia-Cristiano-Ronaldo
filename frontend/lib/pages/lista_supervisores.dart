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
  int currentPage = 6;
  late NavigationManager navigationManager;

  @override
  void initState() {
    super.initState();
    navigationManager = NavigationManager(context, currentPage: currentPage);
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPage = index;
    });

    navigationManager.navigateToPage(index);
  }

  static List<String> getMenuItems() {
    switch (getRole()) {
      case 'admin':
        return menuItemsAdmin;
      case 'supervisor':
        return menuItemsSupervisor;
      case 'athlete':
        return menuItemsAthlete;
      default:
        return [];
    }
  }

  static List<IconData> getPageIcons() {
    switch (role) {
      case 'admin':
        return pageIconsAdmin;
      case 'supervisor':
        return pageIconsSupervisor;
      case 'athlete':
        return pageIconsAthlete;
      default:
        return [];
    }
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
        menuItems: getMenuItems(),
        currentPageTitle: getMenuItems()[currentPage - 1],
        currentPageIndex: currentPage,
        onMenuItemSelected: _navigateToPage,
        pageIcons: getPageIcons(),
      ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              getMenuItems()[currentPage - 1],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        )
    );
  }
}
