import 'dart:convert';
import 'dart:io';
import 'package:deisi66/componentes/custom_button.dart';
import 'package:deisi66/componentes/textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../componentes/app_bar_with_back.dart';
import '../componentes/image_picker.dart';
import '../componentes/inputfield.dart';

TextEditingController nameController = TextEditingController();
TextEditingController surnameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
List<int>? profileImageBytes; //bytes das imagens armazenadas
const String defaultImagePath = "lib/images/defaultProfile.png"; //img default

class AddSupervisorPage extends StatefulWidget {
  const AddSupervisorPage({Key? key}) : super(key: key);

  @override
  _AddSupervisorPageState createState() => _AddSupervisorPageState();
}

class _AddSupervisorPageState extends State<AddSupervisorPage> {
  TextEditingController photoController = TextEditingController();

  void addSupervisor(BuildContext context, String name, String surname,
      String password, List<int>? profileImageBytes) async {
    //ve se os campos obrigatorios estao preenchidos ou n
    if (name.isEmpty || surname.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Por favor, preencha todos os campos obrigatórios.'),
        ),
      );
      return;
    }

    final url = Uri.parse('http://localhost:5000/registSupervisor');

    final response = await http.post(url,
        body: json.encode({
          'name': name,
          'surname': surname,
          'password': password,
          'image': '',
          /*'profileImage': profileImageBytes != null
              ? base64Encode(profileImageBytes)
              : null,
           */
        }),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success'] == true) {
        Navigator.pushNamed(context, '/lista_de_supervisores');
        //showSuccess(context, 'O supervisor foi adicionado com sucesso.');
      } else {
        // showError(
        // context, 'Não foi possível adicionar o supervisor. Tente novamente.');
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Adicionar Supervisor',
                style: TextStyle(
                  color: Color.fromRGBO(79, 79, 79, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ImagePickerField(
                labelText: 'Fotografia',
                controller: photoController,
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
              SendButton(
                onPressed: () {
                  addSupervisor(
                      context,
                      nameController.text,
                      surnameController.text,
                      passwordController.text,
                      profileImageBytes);
                },
                buttonText: 'Adicionar Supervisor',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
