import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../componentes/app_bar_with_back.dart';
import '../componentes/inputfield.dart';

String usernameController = "";
String passwordController = "";

class AddPlayerPage extends StatelessWidget {
  AddPlayerPage({Key? key}) : super(key: key);

  void addPlayer(BuildContext context, String username, String password) async {
    final url = Uri.parse('http://localhost:5000/registerUser');

    final response = await http.post(url,
        body: json.encode({
          'username': username,
          'password': password,
        }),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success'] == true) {
        showSuccess(context, 'O jogador foi adicionado com sucesso.');
      } else {
        showError(
            context, 'Não foi possível adicionar o jogador. Tente novamente.');
      }
    } else {
      showNetworkError(context);
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
      backgroundColor: const Color.fromRGBO(191, 191, 191, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0), //altura da appBar
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
              'Adicionar Atleta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            InputField(
              labelText: 'Username',
              onChanged: (value) {
                usernameController = value;
              },
            ),
            const SizedBox(height: 10),
            InputField(
              labelText: 'Password',
              isPassword: true,
              onChanged: (value) {
                passwordController = value;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addPlayer(context, usernameController, passwordController);
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(3, 110, 73, 1),
                onPrimary: Colors.white,
              ),
              child: const Text('Adicionar Atleta'),
            ),
          ],
        ),
      ),
    );
  }
}
