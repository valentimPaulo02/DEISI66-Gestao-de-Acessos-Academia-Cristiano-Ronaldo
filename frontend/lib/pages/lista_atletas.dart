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
import '../componentes/textfield.dart';
import '../main.dart';

class Atleta {
  int id;
  String name;
  String surname;
  String password;
  String category;
  List<int>? profileImageBytes;

  Atleta({
    required this.id,
    required this.name,
    required this.surname,
    required this.password,
    required this.category,
    this.profileImageBytes,
  });
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
          id: 1,
          name: 'João',
          surname: 'Anacleto',
          password: "abc",
          category: 'under15'),
      Atleta(
          id: 2,
          name: 'Valentim',
          surname: 'Paulo',
          password: "abcd",
          category: 'under16'),
      Atleta(
          id: 3,
          name: 'test',
          surname: 'aaa',
          password: "abcde",
          category: 'under19')
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
            padding: EdgeInsets.only(top: 30.0),
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
                  backgroundColor: const Color.fromRGBO(3, 110, 73, 1),
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
                  return SizedBox.shrink();
                }
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: atleta.profileImageBytes != null
                ? Image.memory(
                    Uint8List.fromList(atleta.profileImageBytes!),
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
  late Uint8List _currentImageBytes;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.atleta.name;
    surnameController.text = widget.atleta.surname;
    passwordController.text = widget.atleta.password;
    categoryController = widget.atleta.category;
    _currentImageBytes = Uint8List(0);
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    if (widget.atleta.profileImageBytes != null) {
      setState(() {
        _currentImageBytes =
            Uint8List.fromList(widget.atleta.profileImageBytes!);
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

  Future<void> _updateAtleta() async {
    final updatedName = nameController.text;
    final updatedSurname = surnameController.text;
    final updatedPassword = passwordController.text;
    final id = widget.atleta.id;

    /*final profileImageBytes =
        _pickedImage != null ? await _pickedImage!.readAsBytes() : null;
     */

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
        'category': categoryController,
        /*'profileImage':
            profileImageBytes != null ? base64Encode(profileImageBytes) : null,
         */
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
            /*
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

             */
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: DropdownButtonFormField<String>(
                dropdownColor: const Color.fromRGBO(150, 150, 150, 0.9),
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color.fromRGBO(150, 150, 150, 0.5),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(150, 150, 150, 1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(50, 190, 100, 1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: categoryController,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      categoryController = newValue;
                    });
                  }
                },
                items: ["under15", "under16", "under17", "under19"]
                    .map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
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
