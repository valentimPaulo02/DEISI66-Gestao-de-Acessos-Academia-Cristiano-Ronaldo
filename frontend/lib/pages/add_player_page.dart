import 'package:deisi66/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../componentes/app_bar_with_back.dart';
import '../componentes/inputfield.dart';

String nameController = "";
String surnameController = "";
String passwordController = "";
String underController = "sub15"; // Valor padrão

class AddPlayerPage extends StatefulWidget {
  const AddPlayerPage({Key? key}) : super(key: key);

  @override
  _AddPlayerPageState createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  final List<String> underOptions = const [
    "under15",
    "under16",
    "under17",
    "under19"
  ];

  void addPlayer(BuildContext context, String name, String surname,
      String password, String under) async {
    final url = Uri.parse('http://localhost:5000/registAthlet');

    final response = await http.post(url,
        body: json.encode({
          'name': name,
          'surname': surname,
          'password': password,
          'class': under,
        }),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success'] == true) {
        //showSuccess(context, 'O jogador foi adicionado com sucesso.');
      } else {
        // showError(
        //      context, 'Não foi possível adicionar o jogador. Tente novamente.');
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
              'Adicionar Atleta',
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
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 200,
                child: DropdownButtonFormField<String>(
                  dropdownColor: const Color.fromRGBO(150, 150, 150, 0.9),
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  decoration: const InputDecoration(
                    labelText: 'Class',
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
                        color: Color.fromRGBO(50, 190, 100, 1),
                        width: 2,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        underController = newValue;
                      });
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
                addPlayer(context, nameController, surnameController,
                    passwordController, underController);
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
    );
  }
}
