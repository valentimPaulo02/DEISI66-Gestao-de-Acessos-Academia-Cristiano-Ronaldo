import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../componentes/app_bar_with_back.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';
import '../componentes/textfield.dart';
import '../main.dart';

class Atleta {
  int id;
  String name;
  String surname;
  String category;

  Atleta({
    required this.id,
    required this.name,
    required this.surname,
    required this.category,
  });
}

//Página Lista de Atletas
class ListaAtletasPage extends StatefulWidget {
  const ListaAtletasPage({Key? key}) : super(key: key);

  @override
  _ListaAtletasPageState createState() => _ListaAtletasPageState();
}

class _ListaAtletasPageState extends State<ListaAtletasPage> {
  int currentPage = 5;
  late NavigationManager navigationManager;
  List<Atleta> atletas = [];

  @override
  void initState() {
    super.initState();
    if (getRole() == 'supervisor') {
      currentPage = 3;
    }
    navigationManager = NavigationManager(context, currentPage: currentPage);

    /*
    atletas = [
      Atleta(id: 1, name: 'João', surname: 'Anacleto', category: 'under15'),
      Atleta(id: 2, name: 'Valentim', surname: 'Paulo', category: 'under16'),
      Atleta(id: 3, name: 'test', surname: 'aaa', category: 'under19')
    ];
    */

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
            category: atleta['category'],
          ))
              .toList();
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

  void _editAtleta(Atleta atleta) {
    if (getRole() == 'admin') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditAtletaPage(atleta: atleta),
        ),
      );
    }
  }

  Future<void> _deleteAtleta(Atleta atleta) async {
    if (getRole() == 'admin') {
      final int atletaId = atleta.id;

      final response = await http.post(
        Uri.parse('http://localhost:5000/deleteUser'),
        headers:{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user_id': atletaId}),
      );

      if (response.statusCode == 200) {
        // sendo excluido com sucesso da api, agr removo-o localmente da lista
        setState(() {
          atletas.removeWhere((element) => element.id == atletaId);
        });
      } else {
        print('Erro ao excluir o atleta: ${response.reasonPhrase}');
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

  // Construção da lista de atletas na interface
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
                  trailing: getRole() == 'admin'
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editAtleta(atleta);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteAtleta(atleta);
                        },
                      ),
                    ],
                  )
                      : null,
                  onTap: () {
                    if (getRole() == 'admin' || getRole() == 'supervisor') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DetalhesAtletaDialog(atleta: atleta);
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

class DetalhesAtletaDialog extends StatelessWidget {
  final Atleta atleta;

  const DetalhesAtletaDialog({Key? key, required this.atleta})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detalhes do Atleta'),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nome: ${atleta.name}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Sobrenome: ${atleta.surname}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Categoria: ${atleta.category}',
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

// Página para editar um atleta
class EditAtletaPage extends StatefulWidget {
  final Atleta atleta;

  const EditAtletaPage({super.key, required this.atleta});

  @override
  _EditAtletaPageState createState() => _EditAtletaPageState();
}

class _EditAtletaPageState extends State<EditAtletaPage> {
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.atleta.name);
    surnameController = TextEditingController(text: widget.atleta.surname);
    categoryController = TextEditingController(text: widget.atleta.category);
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  // Função para atualizar os dados de um atleta
  Future<void> _updateAtleta(
      String name, String surname, String category) async {
    final Map<String, dynamic> updatedData = {
      'name': name,
      'surname': surname,
      'category': category,
    };

    final response = await http.post(
      Uri.parse('http://localhost:5000/updateAthlete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      // Atualização bem-sucedida
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
            ),
            const SizedBox(height: 10),
            CustomTextField(
              labelText: 'Surname',
              controller: surnameController,
            ),
            const SizedBox(height: 10),
            CustomTextField(
              labelText: 'Category',
              controller: categoryController,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _updateAtleta(
                  nameController.text,
                  surnameController.text,
                  categoryController.text,
                );
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
