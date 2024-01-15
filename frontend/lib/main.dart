import 'package:deisi66/componentes/get_role.dart';
import 'package:deisi66/pages/consultar_pedido.dart';
import 'package:deisi66/pages/fazer_pedido_fim_de_semana.dart';
import 'package:deisi66/pages/fazer_pedido_temporario.dart';
import 'package:deisi66/pages/lista_atletas.dart';
import 'package:deisi66/pages/lista_supervisores.dart';
import 'package:deisi66/pages/registar_utilizador.dart';
import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/home.dart';
//import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

// Menu Items ----------------------------

final menuItemsAdmin = [
  'Home',
  'Fazer Pedido Temporario',
  'Fazer Pedido Fim de Semana',
  'Consultar Pedido',
  'Lista de Atletas',
  'Lista de Supervisores',
];

final menuItemsAthlete = [
  'Home',
  'Fazer Pedido Temporario',
  'Fazer Pedido Fim de Semana',
  'Consultar Pedido',
];

final menuItemsSupervisor = [
  'Home',
  'Consultar Pedido',
  'Lista de Atletas',
];

// Page Icons ----------------------------

final List<IconData> pageIconsAdmin = [
  Icons.home,
  Icons.list_alt,
  Icons.list_alt,
  Icons.remove_red_eye,
  Icons.group,
  Icons.supervisor_account,
];

final List<IconData> pageIconsAthlete = [
  Icons.home,
  Icons.list_alt,
  Icons.list_alt,
  Icons.remove_red_eye,
];

final List<IconData> pageIconsSupervisor = [
  Icons.home,
  Icons.remove_red_eye,
  Icons.group,
];

// Token Related Stuff ----------------
String token = "";

String getToken() {
  return token;
}

void setToken(String value) {
  token = value;
}
// ------------------------------------

// Role Related Stuff ----------------
String role = "";

String getRole() {
  return role;
}

void setRole(String value) {
  role = value;
}
// ------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key, Key? k});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academia Cristiano Ronaldo',
      theme: ThemeData(
        colorScheme: null,
        useMaterial3: false,
      ),
      initialRoute: '/', //Rota Inicial
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/fazer_pedido_temporario': (context) => const FazerPedidoTPage(),
        '/fazer_pedido_fim_de_semana': (context) => const FazerPedidoFSPage(),
        '/consultar_pedido': (context) => const ConsultarPedidoPage(),
        '/lista_de_atletas': (context) => const ListaAtletasPage(),
        '/register_user': (context) => const AddPlayerPage(),
        '/lista_de_supervisores': (context) => const ListaSupervisoresPage(),
      },
    );
  }
}
