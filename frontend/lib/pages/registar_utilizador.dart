import 'dart:convert';
import 'dart:io';
import 'package:deisi66/componentes/dropdown_picker.dart';
import 'package:deisi66/componentes/textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../componentes/app_bar_with_back.dart';
import '../componentes/custom_button.dart';
import '../componentes/date_picker.dart';
import '../componentes/image_picker.dart';
import '../componentes/inputfield.dart';

List<int>? profileImageBytes; //bytes da imagem
TextEditingController nameController = TextEditingController();
TextEditingController surnameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
String categoryController = "";
TextEditingController roomNumberController = TextEditingController();
TextEditingController birthDateController = TextEditingController();
const String defaultImagePath = "lib/images/defaultProfile.png"; // img default

const List<String> underOptions = ["under15", "under16", "under17", "under19"];

class AddPlayerPage extends StatefulWidget {
  const AddPlayerPage({Key? key}) : super(key: key);

  @override
  _AddPlayerPageState createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  TextEditingController photoController = TextEditingController();

  void addPlayer(
      BuildContext context,
      String name,
      String surname,
      String password,
      String category,
      String roomNumber,
      String birthDate,
      List<int>? profileImageBytes) async {
    //verifica se os campos obrigatórios estão preenchidos
    if (name.isEmpty ||
        surname.isEmpty ||
        password.isEmpty ||
        category == "" ||
        roomNumber.isEmpty ||
        birthDate.isEmpty) {
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
        'room_number': roomNumber,
        'birth_date': birthDate,
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
        _resetFields();
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

  void _resetFields() {
    setState(() {
      nameController.clear();
      surnameController.clear();
      passwordController.clear();
      categoryController = "";
      roomNumberController.clear();
      birthDateController.clear();
      photoController.clear();
      profileImageBytes = null;
    });
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Adicionar Atleta',
                style: TextStyle(
                  color: Color.fromRGBO(79, 79, 79, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              ImagePickerField(
                labelText: 'Fotografia',
                controller: photoController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                labelText: 'Name*',
                controller: nameController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                labelText: 'Surname*',
                controller: surnameController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                labelText: 'Password*',
                controller: passwordController,
              ),
              const SizedBox(height: 15),
              Dropdown(
                labelText: "Category*",
                items: underOptions,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      categoryController = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              CustomTextField(
                labelText: 'Room Number*',
                controller: roomNumberController,
              ),
              const SizedBox(height: 15),
              DatePicker(
                labelText: 'Birth Date*',
                controller: birthDateController,
                verification: true,
              ),
              const SizedBox(height: 20),
              SendButton(
                onPressed: () {
                  addPlayer(
                    context,
                    nameController.text,
                    surnameController.text,
                    passwordController.text,
                    categoryController,
                    roomNumberController.text,
                    birthDateController.text,
                    profileImageBytes,
                  );
                },
                buttonText: 'Adicionar Atleta',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
