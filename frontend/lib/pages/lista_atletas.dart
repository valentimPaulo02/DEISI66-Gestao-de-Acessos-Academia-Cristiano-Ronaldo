import 'dart:convert';
import 'dart:typed_data';
import 'package:deisi66/componentes/custom_button.dart';
import 'package:deisi66/pages/registar_utilizador.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../componentes/app_bar_with_back.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/date_picker.dart';
import '../componentes/dropdown_picker.dart';
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
  String roomNumber;
  String birthDate;

  Atleta(
      {required this.image,
      required this.id,
      required this.name,
      required this.surname,
      required this.password,
      required this.category,
      required this.roomNumber,
      required this.birthDate});
}

class ListaAtletasPage extends StatefulWidget {
  const ListaAtletasPage({Key? key}) : super(key: key);

  @override
  _ListaAtletasPageState createState() => _ListaAtletasPageState();
}

class _ListaAtletasPageState extends State<ListaAtletasPage> {
  int currentPage = 5;
  late NavigationManager navigationManager;
  List<Atleta> atletas = [];
  List<String> underOptions = ['under15', 'under16', 'under17', 'under19'];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    if (getRole() == 'supervisor') {
      currentPage = 3;
    }
    navigationManager = NavigationManager(context, currentPage: currentPage);
/*
    atletas = [
      Atleta(
        id: 126,
        name: 'João',
        surname: 'Anacleto',
        password: "abc",
        category: 'under15',
        image: '',
        roomNumber: 'A20',
        birthDate: '2002-11-14',
      ),
      Atleta(
          id: 221,
          name: 'Valentim',
          surname: 'Paulo',
          password: "abcd",
          category: 'under16',
          image: '',
          roomNumber: 'A80',
          birthDate: '2002-12-22'),
      Atleta(
          id: 312,
          name: 'test',
          surname: 'aaa',
          password: "abcde",
          category: 'under19',
          image: '',
          roomNumber: 'A22',
          birthDate: '2001-10-18')
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
                    password: atleta['password'],
                    category: atleta['category'],
                    roomNumber: atleta['room_number'],
                    birthDate: atleta['birth_date'],
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
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user_id': atletaId}),
      );

      if (response.statusCode == 200) {
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

  List<String> getUnderOptions() {
    return ['under15', 'under16', 'under17', 'under19'];
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
                    if (getRole() == 'admin' || getRole() == 'supervisor') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DetalhesAtletaDialog(atleta: atleta);
                        },
                      );
                    }
                  },
                  onEditPressed: () {
                    _editAtleta(atleta);
                  },
                  onDeletePressed: () {
                    _deleteAtleta(atleta);
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: atleta.image.isEmpty
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
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Nome: ${atleta.name}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Sobrenome: ${atleta.surname}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Categoria: ${atleta.category}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Room Number: ${atleta.roomNumber}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Birth Date: ${atleta.birthDate}',
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
            backgroundColor: const Color.fromRGBO(0, 128, 87, 0.2),
          ),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}

class EditAtletaPage extends StatefulWidget {
  final Atleta atleta;

  const EditAtletaPage({required this.atleta});

  @override
  _EditAtletaPageState createState() => _EditAtletaPageState();
}

class _EditAtletaPageState extends State<EditAtletaPage> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final passwordController = TextEditingController();
  String categoryController = "";
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.atleta.name;
    surnameController.text = widget.atleta.surname;
    passwordController.text = widget.atleta.password;
    categoryController = widget.atleta.category;
    roomNumberController.text = widget.atleta.roomNumber;
    birthDateController.text = widget.atleta.birthDate;
    imageController.text = widget.atleta.image;
  }

  Future<void> _updateAtleta() async {
    final updatedName = nameController.text;
    final updatedSurname = surnameController.text;
    final updatedPassword = passwordController.text;
    final updatedCategory = categoryController;
    final updatedRoomNumber = roomNumberController.text;
    final updatedBirthDate = birthDateController.text;
    final id = widget.atleta.id;

    final response = await http.post(
      Uri.parse('http://localhost:5000/updateAthlete'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': id,
        'name': updatedName,
        'surname': updatedSurname,
        'password': updatedPassword,
        'category': updatedCategory,
        'room_number': updatedRoomNumber,
        'birth_date': updatedBirthDate,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/lista_de_atletas');
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Editar Atleta',
                  style: TextStyle(
                    color: Color.fromRGBO(79, 79, 79, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 12),
                Dropdown(
                  labelText: "Category",
                  initialValue: categoryController,
                  items: underOptions,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        categoryController = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  labelText: 'Room Number',
                  controller: roomNumberController,
                ),
                const SizedBox(height: 12),
                DatePicker(
                  labelText: 'Birth Date',
                  controller: birthDateController,
                  verification: true,
                ),
                const SizedBox(height: 20),
                SendButton(
                  onPressed: () {
                    _updateAtleta();
                  },
                  buttonText: 'Atualizar Atleta',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
