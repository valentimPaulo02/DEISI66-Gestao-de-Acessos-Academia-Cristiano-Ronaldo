import 'package:deisi66/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AppPages extends StatelessWidget {
  final List<String> menuItems;
  final String currentPageTitle;
  final int currentPageIndex;
  final ValueChanged<int> onMenuItemSelected;
  final List<IconData> pageIcons;

  const AppPages({
    Key? key,
    required this.menuItems,
    required this.currentPageTitle,
    required this.currentPageIndex,
    required this.onMenuItemSelected,
    required this.pageIcons,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 128, 87, 0.9),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'lib/images/simboloacademiav2.png',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          ...menuItems.asMap().entries.map((entry) {
            int index = entry.key + 1;
            final item = entry.value;
            return ListTile(
              selectedTileColor: const Color.fromRGBO(0, 128, 87, 0.2),
              selectedColor: const Color.fromRGBO(0, 128, 87, 0.9),
              leading: Icon(pageIcons[index - 1]),
              title: Text(item),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer após a seleção
                final route =
                    '/${menuItems[index - 1].toLowerCase().replaceAll(' ', '_')}';
                Navigator.of(context).pushReplacementNamed(route);
              },
              selected: index == currentPageIndex,
            );
          }).toList(),
        ],
      ),
    );
  }
}

