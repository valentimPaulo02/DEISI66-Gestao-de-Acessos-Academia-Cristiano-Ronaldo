import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../componentes/app_bar_with_back.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';
import '../componentes/scp_list_object.dart';
import '../main.dart';

class Atleta {
  int id;
  String name;
  String surname;
  String category;
  bool isAvailable;

  Atleta({
    required this.id,
    required this.name,
    required this.surname,
    required this.category,
    required this.isAvailable,
  });
}

class ListaPresencasPage extends StatefulWidget {
  const ListaPresencasPage({Key? key}) : super(key: key);

  @override
  _ListaPresencasPageState createState() => _ListaPresencasPageState();
}

class _ListaPresencasPageState extends State<ListaPresencasPage> {
  int currentPage = 7;
  late NavigationManager navigationManager;
  List<Atleta> atletas = [];
  List<String> underOptions = ['under15', 'under16', 'under17', 'under19'];
  String? selectedCategory;
  bool useTestData = false;

  @override
  void initState() {
    super.initState();
    navigationManager = NavigationManager(context, currentPage: currentPage);
    _getAthleteList();
  }

  Future<void> _getAthleteList() async {
    if (useTestData) {
      _loadTestAthleteList();
      return;
    }

    final response =
        await http.get(Uri.parse('http://localhost:5000/getAvailableAthletes'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success']) {
        setState(() {
          atletas = (data['available_athletes'] as List)
              .map((atleta) => Atleta(
                    id: atleta['user_id'],
                    name: atleta['name'],
                    surname: atleta['surname'],
                    category: atleta['category'],
                    isAvailable: true,
                  ))
              .toList()
            ..addAll((data['unavailable_athletes'] as List)
                .map((atleta) => Atleta(
                      id: atleta['user_id'],
                      name: atleta['name'],
                      surname: atleta['surname'],
                      category: atleta['category'],
                      isAvailable: false,
                    ))
                .toList());
          selectedCategory = null;
        });
      } else {
        print('Erro ao procurar a lista de atletas: ${data['error']}');
      }
    } else {
      print('Erro ao estabelecer conexão à lista de atletas');
    }
  }

  void _loadTestAthleteList() {
    setState(() {
      atletas = [
        Atleta(
            id: 1,
            name: 'João',
            surname: 'Silva',
            category: 'under15',
            isAvailable: true),
        Atleta(
            id: 2,
            name: 'Pedro',
            surname: 'Santos',
            category: 'under16',
            isAvailable: true),
        Atleta(
            id: 3,
            name: 'Maria',
            surname: 'Fernandes',
            category: 'under19',
            isAvailable: true),
        Atleta(
            id: 4,
            name: 'Ana',
            surname: 'Costa',
            category: 'under15',
            isAvailable: false),
        Atleta(
            id: 5,
            name: 'Luís',
            surname: 'Martins',
            category: 'under16',
            isAvailable: false),
        Atleta(
            id: 6,
            name: 'Sofia',
            surname: 'Gomes',
            category: 'under19',
            isAvailable: false),
        Atleta(
            id: 6,
            name: 'asdsa',
            surname: 'Gomes',
            category: 'under19',
            isAvailable: true),
        Atleta(
            id: 6,
            name: 'xcvxc',
            surname: 'Gomes',
            category: 'under19',
            isAvailable: true),
        Atleta(
            id: 6,
            name: 'Szxzx',
            surname: 'Gomes',
            category: 'under19',
            isAvailable: false),
        Atleta(
            id: 6,
            name: 'asdasa',
            surname: 'Gomes',
            category: 'under19',
            isAvailable: false),
      ];
      selectedCategory = null;
    });
  }

  void _toggleTestData() {
    setState(() {
      useTestData = !useTestData;
    });
    _getAthleteList();
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Lista de Presenças',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(79, 79, 79, 1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue == selectedCategory) {
                      selectedCategory = null;
                    } else {
                      selectedCategory = newValue;
                    }
                  });
                },
                items: underOptions.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: atletas.length,
              itemBuilder: (context, index) {
                final atleta = atletas[index];

                if (selectedCategory != null &&
                    atleta.category != selectedCategory) {
                  return const SizedBox.shrink();
                }

                return ScpListObject(
                  color: atleta.isAvailable
                      ? const Color.fromRGBO(0, 128, 87, 0.7)
                      : Colors.black12,
                  nome: '${atleta.name} ${atleta.surname}',
                  numeroString: atleta.category,
                  qqString: 'ID: ${atleta.id}',
                  textoIcone:
                      atleta.isAvailable ? 'Na academia' : 'Fora da academia',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
