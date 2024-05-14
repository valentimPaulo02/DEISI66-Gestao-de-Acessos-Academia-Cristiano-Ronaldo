import 'dart:convert';
import 'package:deisi66/main.dart';
import 'package:flutter/material.dart';
import '../componentes/app_bar_with_back.dart';
import '../componentes/inputfield.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String nome = '';
  late String apelido = '';
  late String password = '';

  TextEditingController passwordController = TextEditingController();

  bool isEditingPassword = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var response = await http.get(
            Uri.parse('http://localhost:5000/getUserData'),
            headers: {"Content-Type": "application/json", "token": getToken()}
            );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          nome = data['name'];
          apelido = data['surname'];
          password = data['password'];
          passwordController.text = password;
        });
      } else {
        throw Exception('Failed to load user profile data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      var response = await http.post(
      Uri.parse('http://localhost:5000/updatePassword'),
      body: json.encode({
          'token': getToken(),
          'password': newPassword,
      }),
      headers: {"Content-Type": "application/json"}
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
        print('Password updated successfully');
      } else {
        throw Exception('Failed to update password');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating password')),
      );
      print('Error: $error');
    }
  }

  Future<void> logout() async {

    var response = await http.post(
      Uri.parse('http://localhost:5000/logout'),
      body: json.encode({
          'token': getToken(),
      }),
      headers: {"Content-Type": "application/json"}
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/');
    } else {
      throw Exception('Failed to load user profile data');
    }
  }

  void startEditingPassword() {
    setState(() {
      isEditingPassword = true;
    });
  }

  void confirmPasswordEditing() {
    setState(() {
      isEditingPassword = false;
      updatePassword(passwordController.text);
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
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('lib/images/defaultProfile.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 20),
            InputField(
              labelText: 'Nome',
              initialValue: nome,
              enabled: false,
            ),
            const SizedBox(height: 10),
            InputField(
              labelText: 'Apelido',
              initialValue: apelido,
              enabled: false,
            ),
            const SizedBox(height: 10),
            InputField(
              labelText: 'Password',
              isPassword: true,
              controller: passwordController,
              enabled: isEditingPassword,
              suffixIcon: isEditingPassword
                  ? IconButton(
                      onPressed: confirmPasswordEditing,
                      icon: const Icon(Icons.check),
                      color: const Color.fromRGBO(4, 180, 107, 1),
                    )
                  : IconButton(
                      onPressed: startEditingPassword,
                      icon: const Icon(Icons.edit),
                      color: const Color.fromRGBO(4, 180, 107, 1),
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                logout();
              },
              child: const Text('Terminar Sessão'),
            ),
          ],
        ),
      ),
    );
  }
}
