import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../componentes/app_bar_with_back.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/image_picker.dart';
import '../componentes/navigation_manager.dart';
import '../componentes/scp_list_object.dart';
import '../componentes/textfield.dart';
import '../main.dart';

class Atleta {
  int id;
  String name;
  String surname;
  String password;
  String category;
  String image;

  Atleta({
    required this.id,
    required this.name,
    required this.surname,
    required this.password,
    required this.category,
    required this.image,
  });
}

class ListaPresencasPage extends StatefulWidget {
  const ListaPresencasPage({Key? key}) : super(key: key);

  @override
  _ListaPresencasPageState createState() => _ListaPresencasPageState();
}

class _ListaPresencasPageState extends State<ListaPresencasPage> {
  int currentPage = 6;
  late NavigationManager navigationManager;
  List<Atleta> atletas = [];
  List<String> underOptions = ['under15', 'under16', 'under17', 'under19'];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    /*
    if (getRole() == 'supervisor') {
      currentPage = 3;
    }
     */
    navigationManager = NavigationManager(context, currentPage: currentPage);

    atletas = [
      Atleta(
          id: 126,
          name: 'João',
          surname: 'Anacleto',
          password: "abc",
          category: 'under15',
          image: ''),
      Atleta(
          id: 221,
          name: 'Valentim',
          surname: 'Paulo',
          password: "abcd",
          category: 'under16',
          image: ''),
      Atleta(
          id: 312,
          name: 'test',
          surname: 'aaa',
          password: "abcde",
          category: 'under19',
          image: '')
    ];



    _getAthleteList();
  }

  Future<void> _getAthleteList() async {
    final url =
    await http.get(Uri.parse('http://localhost:5000/getAthleteList'));

    if (url.statusCode == 200) {
      final data = jsonDecode(url.body);

      if (data['success']) {
        setState(() {
          atletas = (data['list'] as List)
              .map((atleta) => Atleta(
            id: atleta['user_id'],
            name: atleta['name'],
            surname: atleta['surname'],
            password: atleta['password'],
            category: atleta['category'],
            image: atleta['image_path'],
          ))
              .toList();
          selectedCategory = null; //limpa a categoria que está selecionada
        });
      } else {
        print('Erro ao procurar a lista de atletas: ${data['error']}');
      }
    } else {
      print('Erro ao estabelecer conexão à lista de atletas');
    }
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
                'Lista de Atletas',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register_user');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(0, 128, 87, 1),
                ),
                child: const Text('Adicionar Atleta'),
              ),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    if (newValue == selectedCategory) {
                      selectedCategory = null; //limpa a categoria selecionada
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
          const SizedBox(height: 20),
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
                  color: const Color.fromRGBO(0, 128, 87, 0.9),
                  nome: '${atleta.name} ${atleta.surname}',
                  numeroString: atleta.category,
                  qqString: 'ID: ${atleta.id}',
                  onPressed: () {
                    print("Mudar dps");
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
