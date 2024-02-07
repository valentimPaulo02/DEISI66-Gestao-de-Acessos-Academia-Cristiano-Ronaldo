import 'package:deisi66/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../componentes/app_bar_with_back.dart';
import '../componentes/inputfield.dart';

String nameController = "";
String surnameController = "";
String passwordController = "";

class AddSupervisorPage extends StatefulWidget {
  const AddSupervisorPage({Key? key}) : super(key: key);

  @override
  _AddSupervisorPageState createState() => _AddSupervisorPageState();
}

class _AddSupervisorPageState extends State<AddSupervisorPage> {

  void addSupervisor(BuildContext context, String name, String surname,
      String password) async {
    final url = Uri.parse('http://localhost:5000/registSupervisor');

    final response = await http.post(url,
        body: json.encode({
          'name': name,
          'surname': surname,
          'password': password,
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

  void showSuccess(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showNetworkError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro de Rede'),
          content: const Text('Não foi possível conectar-se ao servidor.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
            InputField(
              labelText: 'Name',
              onChanged: (value) {
                nameController = value;
              },
            ),
            const SizedBox(height: 10),
            InputField(
              labelText: 'Surname',
              onChanged: (value) {
                surnameController = value;
              },
            ),
            const SizedBox(height: 10),
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
                    passwordController);
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
    );
  }
}
