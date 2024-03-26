import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../componentes/app_bar_with_back.dart';
import '../main.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';
import 'package:deisi66/componentes/textfield.dart' as customTextField;

class Supervisor {
  int id;
  String name;
  String surname;

  Supervisor({
    required this.id,
    required this.name,
    required this.surname,
  });
}

//Página Lista de Supervisores
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

    navigationManager = NavigationManager(context, currentPage: currentPage);

    /*
    supervisores = [
      Supervisor(id: 1, name: 'João', surname: 'Anacleto'),
      Supervisor(id: 2, name: 'Valentim', surname: 'Paulo'),
      Supervisor(id: 3, name: 'test', surname: 'aaa')
    ];
    */

    _getSupervisorList();
  }

  Future<void> _getSupervisorList() async {
    final url =
    await http.get(Uri.parse('http://localhost:5000/getSupervisorList'));

    if (url.statusCode == 200) {
      final data = jsonDecode(url.body);

      if (data['success']) {
        setState(() {
          supervisores = (data['list'] as List).map((supervisor) => Supervisor(
            id: supervisor['user_id'],
            name: supervisor['name'],
            surname: supervisor['surname'],
          )).toList();
        });
        print(supervisores);
      } else {
        print('Erro ao procurar a lista de supervisores: ${data['error']}');
      }
    } else {
      print('Erro ao estabelecer conexão à lista de supervisores');
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPage = index;
    });

    navigationManager.navigateToPage(index);
  }

  void _editSupervisor(Supervisor supervisor) {
    if (getRole() == 'admin') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditSupervisorPage(supervisor: supervisor),
        ),
      );
    }
  }

  Future<void> _deleteSupervisor(Supervisor supervisor) async {
    if (getRole() == 'admin') {
      final int supervisorID = supervisor.id;
      final response = await http.post(
        Uri.parse('http://localhost:5000/deleteUser'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user_id': supervisorID}),
      );

      if (response.statusCode == 200) {
        // sendo excluido com sucesso da api, agr removo-o localmente da lista
        setState(() {
          supervisores.removeWhere((element) => element.id == supervisorID);
        });
      } else {
        print('Erro ao excluir o supervisor: ${response.reasonPhrase}');
      }
    }
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

  //Construção da lista de supervisores na interface
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
                    Navigator.of(context)
                        .pushNamed('/registar_supervisores');
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
                  trailing: getRole() == 'admin'
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editSupervisor(supervisor);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteSupervisor(supervisor);
                        },
                      ),
                    ],
                  )
                      : null,
                  onTap: () {
                    if (getRole() == 'admin') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DetalhesSupervisorDialog(
                            supervisor: supervisor,
                          );
                        },
                      );
                    }
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

class DetalhesSupervisorDialog extends StatelessWidget {
  final Supervisor supervisor;

  const DetalhesSupervisorDialog({Key? key, required this.supervisor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detalhes do Supervisor'),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nome: ${supervisor.name}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Sobrenome: ${supervisor.surname}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}

class EditSupervisorPage extends StatefulWidget {
  final Supervisor supervisor;

  const EditSupervisorPage({super.key, required this.supervisor});

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

  //Função para atualizar os dados de um supervisor
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
      // Atualização bem-sucedida
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
            customTextField.CustomTextField(
              labelText: 'Name',
              controller: nameController,
            ),
            const SizedBox(height: 10),
            customTextField.CustomTextField(
              labelText: 'Surname',
              controller: surnameController,
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
