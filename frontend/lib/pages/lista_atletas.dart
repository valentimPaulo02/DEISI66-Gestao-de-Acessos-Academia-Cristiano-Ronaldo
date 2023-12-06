import 'dart:convert';
import 'package:deisi66/componentes/textfield.dart';
import 'package:flutter/material.dart';
import '../componentes/app_bar_with_back.dart';
import '../main.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';
import 'package:http/http.dart' as http;

class Atleta {
  String name;
  String surname;
  String category;

  Atleta({
    required this.name,
    required this.surname,
    required this.category,
  });

  void update({
    String? name,
    String? surname,
    String? category,
  }) {
    this.name = name ?? this.name;
    this.surname = surname ?? this.surname;
    this.category = category ?? this.category;
  }
}

class ListaAtletasPage extends StatefulWidget {
  const ListaAtletasPage({Key? key}) : super(key: key);

  @override
  _ListaAtletasPageState createState() => _ListaAtletasPageState();
}

class _ListaAtletasPageState extends State<ListaAtletasPage> {
  int currentPage = 4;
  late NavigationManager navigationManager;
  List<Atleta> atletas = [];

  @override
  void initState() {
    super.initState();

    if(getRole()=='supervisor'){
      currentPage = 3;
    }
    navigationManager = NavigationManager(context, currentPage: currentPage);

    atletas = [
      Atleta(name: 'João', surname: 'Anacleto', category: 'under15'),
      Atleta(name: 'Valentim', surname: 'Paulo', category: 'under16'),
      Atleta(name: 'test', surname: 'aaa', category: 'under19')
    ];

    _getAthleteList();
  }

  Future<void> _getAthleteList() async {
    final url = await http.get(Uri.parse('http://localhost:5000/getAthleteList'));

    if (url.statusCode == 200) {
      final data = jsonDecode(url.body);

      if (data['success']) {
        setState(() {
          atletas = (data['list'] as List).map((atleta) => Atleta(
            name: atleta['name'],
            surname: atleta['surname'],
            category: atleta['category'],
          )).toList();
        });
      } else {
        print('Erro ao buscar a lista de atletas: ${data['error']}');
      }
    } else {
      print('Erro de conexão ao buscar a lista de atletas');
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPage = index;
    });

    navigationManager.navigateToPage(index);
  }

  void _editAtleta(Atleta atleta) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditAtletaPage(atleta: atleta),
      ),
    );
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
          Expanded(
            child: ListView.builder(
              itemCount: atletas.length,
              itemBuilder: (context, index) {
                final atleta = atletas[index];
                return ListTile(
                  title: Text(
                    '${atleta.name} ${atleta.surname} | ${atleta.category}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editAtleta(atleta);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EditAtletaPage extends StatefulWidget {
  final Atleta atleta;

  EditAtletaPage({required this.atleta});

  @override
  _EditAtletaPageState createState() => _EditAtletaPageState();
}

class _EditAtletaPageState extends State<EditAtletaPage> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.atleta.name;
    surnameController.text = widget.atleta.surname;
    categoryController.text = widget.atleta.category;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  //dar update no backend da atualização de qq elemento da lista
  Future<void> _updateAtleta() async {
    final updatedName = nameController.text;
    final updatedSurname = surnameController.text;
    final updatedCategory = categoryController.text;

    final Map<String, dynamic> updatedData = {
      'name': updatedName,
      'surname': updatedSurname,
      'category': updatedCategory,
    };

    final response = await http.post(
      Uri.parse('http://localhost:5000/updateAthlete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
    } else {
      print('Erro na atualização do atleta: ${response.reasonPhrase}');
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromRGBO(191, 191, 191, 0.8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: CustomAppBarWithBack(
          onBackButtonPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Editar Atleta',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              labelText: 'Name',
              controller: nameController,
              onChanged: (value) {
                widget.atleta.update(name: value);
              },
            ),
            const SizedBox(height: 10),
            CustomTextField(
              labelText: 'Surname',
              controller: surnameController,
              onChanged: (value) {
                widget.atleta.update(surname: value);
              },
            ),
            const SizedBox(height: 10),
            CustomTextField(
              labelText: 'Category',
              controller: categoryController,
              onChanged: (value) {
                widget.atleta.update(category: value);
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _updateAtleta();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(3, 110, 73, 1),
              ),
              child: const Text('Atualizar Atleta'),
            ),
          ],
        ),
      ),
    );
  }
}