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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Adicionar Supervisor',
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
            ElevatedButton(
              onPressed: () {
                addSupervisor(context, nameController, surnameController,
                    passwordController, profileImageBytes);
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
    );
  }
}