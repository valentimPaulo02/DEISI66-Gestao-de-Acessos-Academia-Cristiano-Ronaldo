import 'dart:convert';
import 'package:deisi66/main.dart';
import 'package:flutter/material.dart';
import '../componentes/get_role.dart';
import '../componentes/inputfield.dart';
import 'package:http/http.dart' as http;

String usernameController = "";
String passwordController = "";

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void signUserIn(
      BuildContext context, String username, String password) async {
    // URL do seu servidor Flask
    final url = Uri.parse('https://projects.deisi.ulusofona.pt/DEISI66/login');

    // solicitação POST para o servidor
    final response = await http.post(url,
        body: json.encode({
          'username': username,
          'password': password,
        }),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success'] == true) {
        await fetchUserRole(data['token']);
        Navigator.pushNamed(context, '/home');
      } else {
        // login malsucedido (mostrar mensagem de erro, etc.)
      }
    } else {
      // erro de rede ou erro do servidor
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //"NAV" part
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/leaoback.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 33,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 85,
              color: const Color.fromRGBO(3, 110, 73, 0.9),
              child: Center(
                child: Image.asset(
                  'lib/images/simboloacademiav2.png',
                  width: 170,
                  height: 170,
                ),
              ),
            ),
          ),

          //"Login message"(...)

          const Positioned(
            top: 200, // Ajuste de posição vertical
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromRGBO(160, 160, 160, 0.9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Username step

          Positioned(
            top: 280,
            left: 0,
            right: 0,
            child: Center(
              child: InputField(
                labelText: 'Username',
                onChanged: (value) {
                  usernameController = value;
                },
              ),
            ),
          ),

          // Password step

          Positioned(
            top: 350,
            left: 0,
            right: 0,
            child: Center(
              child: InputField(
                labelText: 'Password',
                isPassword: true,
                onChanged: (value) {
                  passwordController = value;
                },
              ),
            ),
          ),

          // Forgot Password?

          Positioned(
            top: 445, // Ajuste de posição vertical
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 105, // largura butão "Sign In"
                height: 50, // comprimento // // // //
                child: ElevatedButton(
                  onPressed: () {
                    signUserIn(context, usernameController, passwordController);
                    //Navigator.pushNamed(context, '/home');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(3, 110, 73, 1),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
