import 'package:deisi66/componentes/get_role.dart';
import 'package:flutter/material.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 1;
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

  List<String> getMenuItems() {
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

  List<IconData> getPageIcons() {
    switch (getRole()) {
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
    List<Widget> buttonsToShow = [];
    if (getRole() == 'athlete') {
      buttonsToShow = [
        SizedBox(
          width: 191,
          height: 71,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/pedido_saida_temporaria');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 128, 87, 0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Pedido de saída temporária',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 191,
          height: 71,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/pedido_saida_fim_de_semana');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 128, 87, 0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Pedido de saída de fim de semana',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ];
    } else {
      buttonsToShow = [
        SizedBox(
          width: 191,
          height: 71,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/consultar_pedidos');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 128, 87, 0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Consultar Pedidos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 191,
          height: 71,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/lista_de_atletas');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(0, 128, 87, 0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Lista de atletas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ];
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/hp.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 230.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: buttonsToShow,
            ),
          ),
        ),
      ),
    );
  }
}
