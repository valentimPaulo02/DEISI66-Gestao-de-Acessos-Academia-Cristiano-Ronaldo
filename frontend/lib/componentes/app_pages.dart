import 'package:flutter/material.dart';

class AppPages extends StatelessWidget {
  final List<String> menuItems;
  final String currentPageTitle;
  final int currentPageIndex;
  final ValueChanged<int> onMenuItemSelected;
  final List<IconData> pageIcons;
  final String userRole;

  const AppPages({
    Key? key,
    required this.menuItems,
    required this.currentPageTitle,
    required this.currentPageIndex,
    required this.onMenuItemSelected,
    required this.pageIcons,
    required this.userRole,
  }) : super(key: key);

  List<String> getFilteredMenuItems() {
    switch (userRole) {
      case 'admin':
        return menuItems;
      case 'supervisor':
        return menuItems.sublist(0, 4);
      case 'athlete':
        return menuItems.sublist(0, 3);
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredMenuItens = getFilteredMenuItems();
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(4, 180, 107, 1),
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
          ...filteredMenuItens.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final item = entry.value;
            return ListTile(
              selectedTileColor: const Color.fromRGBO(4, 180, 107, 0.2),
              selectedColor: const Color.fromRGBO(4, 180, 107, 1),
              leading: Icon(pageIcons[index - 1]),
              title: Text(item),
              onTap: () {
                Navigator.pop(
                    context); // Após seleção da página, o drawer fecha
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
