import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../componentes/app_bar_with_back.dart';
import '../componentes/image_picker.dart';
import '../componentes/inputfield.dart';

String nameController = "";
String surnameController = "";
String passwordController = "";
String categoryController = ""; // Valor padrão
List<int>? profileImageBytes; //bytes da imagem
const String defaultImagePath = "lib/images/defaultProfile.png"; // img default

const List<String> underOptions = ["under15", "under16", "under17", "under19"];

class AddPlayerPage extends StatefulWidget {
  const AddPlayerPage({Key? key}) : super(key: key);

  @override
  _AddPlayerPageState createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  TextEditingController photoController = TextEditingController();

  void addPlayer(BuildContext context, String name, String surname,
      String password, String category, List<int>? profileImageBytes) async {
    //verifica se os campos obrigatórios estão preenchidos
    if (name.isEmpty || surname.isEmpty || password.isEmpty || category == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, preencha todos os campos obrigatórios.'),
        ),
      );
      return;
    }

    final url = Uri.parse('http://localhost:5000/registAthlete');

    final response = await http.post(
      url,
      body: json.encode({
        'name': name,
        'surname': surname,
        'password': password,
        'category': category,
        'image': '',
        /*'profileImage':
            profileImageBytes != null ? base64Encode(profileImageBytes) : null,
         */
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success'] == true) {
        Navigator.pushNamed(context, '/lista_de_atletas');
        //showSuccess(context, 'O jogador foi adicionado com sucesso.');
      } else {
        // showError(
        // context, 'Não foi possível adicionar o jogador. Tente novamente.');
      }
    } else {
      // showNetworkError(context);
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Adicionar Atleta',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ImagePickerField(
                labelText: 'Fotografia',
                controller: photoController,
              ),
              const SizedBox(height: 20),
              InputField(
                labelText: 'Name',
                onChanged: (value) {
                  nameController = value;
                },
              ),
              const SizedBox(height: 20),
              InputField(
                labelText: 'Surname',
                onChanged: (value) {
                  surnameController = value;
                },
              ),
              const SizedBox(height: 20),
              InputField(
                labelText: 'Password',
                onChanged: (value) {
                  passwordController = value;
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    dropdownColor: const Color.fromRGBO(150, 150, 150, 0.9),
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Color.fromRGBO(150, 150, 150, 0.5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(150, 150, 150, 1),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(0, 128, 87, 1),
                          width: 2,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                          categoryController = newValue;
                      }
                    },
                    items: underOptions.map((String option) {
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
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  addPlayer(
                      context,
                      nameController,
                      surnameController,
                      passwordController,
                      categoryController,
                      profileImageBytes);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(0, 128, 87, 1),
                ),
                child: const Text('Adicionar Atleta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}