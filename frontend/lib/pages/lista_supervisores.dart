import 'dart:convert';
import 'package:deisi66/componentes/textfield.dart';
import 'package:flutter/material.dart';
import '../componentes/app_bar_with_back.dart';
import '../main.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';
import 'package:http/http.dart' as http;

class Supervisor {
  String name;
  String surname;

  Supervisor({
    required this.name,
    required this.surname,
  });

  void update({
    String? name,
    String? surname,
    String? category,
  }) {
    this.name = name ?? this.name;
    this.surname = surname ?? this.surname;
  }
}

class ListaSupervisoresPage extends StatefulWidget {
  const ListaSupervisoresPage({Key? key}) : super(key: key);

  @override
  _ListaSupervisoresPageState createState() => _ListaSupervisoresPageState();
}

class _ListaSupervisoresPageState extends State<ListaSupervisoresPage> {
  int currentPage = 6;
  late NavigationManager navigationManager;
  List<Supervisor> supervisores = [];

  @override
  void initState() {
    super.initState();

    if(getRole()=='supervisor'){
      currentPage = 3;
    }
    navigationManager = NavigationManager(context, currentPage: currentPage);

    /*
    supervisores = [
      Supervisor(name: 'João', surname: 'Anacleto'),
      Supervisor(name: 'Valentim', surname: 'Paulo')
    ];
     */


    _getSupervisorList();
  }

  Future<void> _getSupervisorList() async {
    final url = await http.get(Uri.parse('http://localhost:5000/getSupervisorList'));

    if (url.statusCode == 200) {
      final data = jsonDecode(url.body);

      if (data['success']) {
        setState(() {
          supervisores = (data['list'] as List).map((supervisor) => Supervisor(
            name: supervisor['name'],
            surname: supervisor['surname']
          )).toList();
        });
      } else {
        print('Erro ao buscar a lista de supervisores: ${data['error']}');
      }
    } else {
      print('Erro de conexão ao buscar a lista de supervisores');
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPage = index;
    });

    navigationManager.navigateToPage(index);
  }

  void _editSupervisor(Supervisor supervisor) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditSupervisorPage(supervisor: supervisor),
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
                'Lista de Supervisores',
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
                    Navigator.of(context).pushNamed('/registar_supervisores');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(3, 110, 73, 1),
                  ),
                  child: const Text('Adicionar Supervisor'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: supervisores.length,
              itemBuilder: (context, index) {
                final supervisor = supervisores[index];
                return ListTile(
                  title: Text(
                    '${supervisor.name} ${supervisor.surname}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editSupervisor(supervisor);
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

class EditSupervisorPage extends StatefulWidget {
  final Supervisor supervisor;

  EditSupervisorPage({required this.supervisor});

  @override
  _EditSupervisorPageState createState() => _EditSupervisorPageState();
}

class _EditSupervisorPageState extends State<EditSupervisorPage> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.supervisor.name;
    surnameController.text = widget.supervisor.surname;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  //dar update no backend da atualização de qq elemento da lista
  Future<void> _updateSupervisor() async {
    final updatedName = nameController.text;
    final updatedSurname = surnameController.text;

    final Map<String, dynamic> updatedData = {
      'name': updatedName,
      'surname': updatedSurname,
    };

    final response = await http.post(
      Uri.parse('http://localhost:5000/updateSupervisor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
    } else {
      print('Erro na atualização do supervisor: ${response.reasonPhrase}');
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
              'Editar Supervisor',
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
                widget.supervisor.update(name: value);
              },
            ),
            const SizedBox(height: 10),
            CustomTextField(
              labelText: 'Surname',
              controller: surnameController,
              onChanged: (value) {
                widget.supervisor.update(surname: value);
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _updateSupervisor();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(3, 110, 73, 1),
              ),
              child: const Text('Atualizar Supervisor'),
            ),
          ],
        ),
      ),
    );
  }
}