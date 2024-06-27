import 'dart:convert';
import 'dart:typed_data';
import 'package:deisi66/componentes/custom_button.dart';
import 'package:deisi66/pages/registar_supervisor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../componentes/app_bar_with_back.dart';
import '../componentes/filters/supervisor_filter.dart';
import '../componentes/image_picker.dart';
import '../componentes/scp_list_object.dart';
import '../main.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';
import 'package:deisi66/componentes/textfield.dart';

class Supervisor {
  int id;
  String name;
  String surname;
  String password;
  String image;

  Supervisor({
    required this.id,
    required this.name,
    required this.surname,
    required this.password,
    required this.image,
  });
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
  String? nameFilter = '';

  @override
  void initState() {
    super.initState();

    navigationManager = NavigationManager(context, currentPage: currentPage);
/*
    supervisores = [
      Supervisor(
          id: 1,
          name: 'João',
          surname: 'Anacleto',
          password: "ola123",
          image: ''),
      Supervisor(
          id: 2,
          name: 'Valentim',
          surname: 'Paulo',
          password: "sporting123",
          image: ''),
      Supervisor(
          id: 3,
          name: 'test',
          surname: 'aaa',
          password: "sporting2024",
          image: '')
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
          supervisores = (data['list'] as List)
              .map((supervisor) => Supervisor(
                    id: supervisor['user_id'],
                    name: supervisor['name'],
                    surname: supervisor['surname'],
                    password: supervisor['password'],
                    image: supervisor['image_path'],
                  ))
              .toList();
        });
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

  void _onNameFilterChanged(String value) {
    setState(() {
      nameFilter = value.toLowerCase();
    });
  }

  void _onClearFilters() {
    setState(() {
      nameFilter = null;
    });
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
                  color: Color.fromRGBO(79, 79, 79, 1),
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
                    backgroundColor: const Color.fromRGBO(0, 128, 87, 1),
                  ),
                  child: const Text('Adicionar Supervisor'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: supervisores.length,
              itemBuilder: (context, index) {
                final supervisor = supervisores[index];
                final fullName =
                    '${supervisor.name} ${supervisor.surname}'.toLowerCase();

                if (nameFilter != null &&
                    nameFilter!.isNotEmpty &&
                    !fullName.contains(nameFilter!)) {
                  return const SizedBox.shrink();
                }

                return ScpListObject(
                  color: const Color.fromRGBO(0, 128, 87, 0.9),
                  nome: '${supervisor.name} ${supervisor.surname}',
                  qqString: 'ID: ${supervisor.id}',
                  onPressed: () {
                    if (getRole() == 'admin' || getRole() == 'supervisor') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DetalhesSupervisorDialog(
                              supervisor: supervisor);
                        },
                      );
                    }
                  },
                  onEditPressed: () {
                    _editSupervisor(supervisor);
                  },
                  onDeletePressed: () {
                    _deleteSupervisor(supervisor);
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SupervisorFilter(
                initialNameFilter: nameFilter,
                onNameFilterChanged: _onNameFilterChanged,
                onClearFilters: _onClearFilters,
              ),
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
      content: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  'Detalhes do Atleta',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: supervisor.image.isEmpty
                    ? Image.asset(
                        'lib/images/defaultProfile.png',
                        width: 70,
                        height: 70,
                      )
                    : Image.asset(
                        'lib/images/arrowBack.png',
                        width: 70,
                        height: 70,
                      ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Nome: ${supervisor.name}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Sobrenome: ${supervisor.surname}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          Positioned(
            top: -15,
            right: -15,
            child: IconButton(
              iconSize: 18,
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class EditSupervisorPage extends StatefulWidget {
  final Supervisor supervisor;

  const EditSupervisorPage({Key? key, required this.supervisor})
      : super(key: key);

  @override
  _EditSupervisorPageState createState() => _EditSupervisorPageState();
}

class _EditSupervisorPageState extends State<EditSupervisorPage> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final passwordController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.supervisor.name;
    surnameController.text = widget.supervisor.surname;
    passwordController.text = widget.supervisor.password;
    imageController.text = widget.supervisor.image;
  }

  Future<void> _updateSupervisor() async {
    final updatedName = nameController.text;
    final updatedSurname = surnameController.text;
    final updatedPassword = passwordController.text;
    final id = widget.supervisor.id;

    final response = await http.post(
      Uri.parse('http://localhost:5000/updateSupervisor'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': id,
        'name': updatedName,
        'surname': updatedSurname,
        'password': updatedPassword,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/lista_de_supervisores');
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Center(
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
              const SizedBox(height: 20),
              Center(
                child: imageController.text.isEmpty
                    ? Image.asset(
                        'lib/images/defaultProfile.png',
                        width: 100,
                        height: 100,
                      )
                    : Image.asset(
                        'lib/images/arrowBack.png',
                        width: 100,
                        height: 100,
                      ),
              ),
              const SizedBox(height: 5),
              CustomTextField(
                labelText: 'Name',
                controller: nameController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                labelText: 'Surname',
                controller: surnameController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                labelText: 'Password',
                controller: passwordController,
              ),
              const SizedBox(height: 20),
              SendButton(
                onPressed: () {
                  _updateSupervisor();
                },
                buttonText: 'Atualizar Supervisor',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
