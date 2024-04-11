import 'dart:convert';
import 'dart:typed_data';
import 'package:deisi66/pages/registar_supervisor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../componentes/app_bar_with_back.dart';
import '../componentes/image_picker.dart';
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
  List<int>? profileImageBytes; //bytes da imagem de perfil

  Supervisor({
    required this.id,
    required this.name,
    required this.surname,
    required this.password,
    this.profileImageBytes,
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

  @override
  void initState() {
    super.initState();

    navigationManager = NavigationManager(context, currentPage: currentPage);

    supervisores = [
      Supervisor(id: 1, name: 'João', surname: 'Anacleto', password: "ola123"),
      Supervisor(
          id: 2, name: 'Valentim', surname: 'Paulo', password: "sporting123"),
      Supervisor(id: 3, name: 'test', surname: 'aaa', password: "sporting2024")
    ];

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
                  ))
              .toList();
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
        // sendo excluido com sucesso da api, agora removo-o localmente da lista
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: supervisor.profileImageBytes != null
                ? Image.memory(
                    Uint8List.fromList(supervisor.profileImageBytes!),
                    width: 50,
                    height: 50,
                  )
                : Image.asset(
                    'lib/images/defaultProfile.png',
                    width: 70,
                    height: 70,
                  ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Nome: ${supervisor.name}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Sobrenome: ${supervisor.surname}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(4, 180, 107, 0.2),
          ),
          child: const Text('Fechar'),
        ),
      ],
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
  late Uint8List _currentImageBytes;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.supervisor.name;
    surnameController.text = widget.supervisor.surname;
    passwordController.text = widget.supervisor.password;
    _currentImageBytes = Uint8List(0);
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    if (widget.supervisor.profileImageBytes != null) {
      setState(() {
        _currentImageBytes =
            Uint8List.fromList(widget.supervisor.profileImageBytes!);
      });
    } else {
      try {
        final ByteData imageData =
            await rootBundle.load('lib/images/defaultProfile.png');
        final Uint8List defaultImageBytes = imageData.buffer.asUint8List();
        setState(() {
          _currentImageBytes = defaultImageBytes;
        });
      } catch (error) {
        print('Erro ao carregar a imagem default: $error');
      }
    }
  }

  Future<void> _updateSupervisor() async {
    final updatedName = nameController.text;
    final updatedSurname = surnameController.text;
    final updatedPassword = passwordController.text;
    final id = widget.supervisor.id;

    final profileImageBytes =
        _pickedImage != null ? await _pickedImage!.readAsBytes() : null;

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
        'profileImage':
            profileImageBytes != null ? base64Encode(profileImageBytes) : null,
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
            const SizedBox(height: 20),
            if (_currentImageBytes.isNotEmpty)
              Image.memory(
                _currentImageBytes,
                width: 100,
                height: 100,
              ),
            if (_currentImageBytes.isEmpty)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(4, 180, 107, 1)),
              ),
            const SizedBox(height: 10),
            ImagePickerField(
              labelText: 'Fotografia',
              controller: TextEditingController(
                  text: _pickedImage != null ? _pickedImage!.name : ''),
              onImagePicked: (pickedImage) {
                setState(() {
                  _pickedImage = pickedImage;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Name',
              controller: nameController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Surname',
              controller: surnameController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Password',
              controller: passwordController,
            ),
            const SizedBox(height: 20),
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
