import 'package:deisi66/pages/consultar_pedido.dart';
import 'package:deisi66/pages/fazer_pedido.dart';
import 'package:deisi66/pages/lista_atletas.dart';
import 'package:deisi66/pages/lista_supervisores.dart';
import 'package:deisi66/pages/add_player_page.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home.dart';
//import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

final menuItems = [
  'Home',
  'Fazer Pedido',
  'Consultar Pedido',
  'Lista de Atletas',
  'Lista de Supervisores',
];

final List<IconData> pageIcons = [
  Icons.home,
  Icons.list_alt,
  Icons.remove_red_eye,
  Icons.group,
  Icons.supervisor_account,
];

// Token Related Stuff ----------------
String token = "";

String getToken() {
  return token;
} // <-------------------------------------------------------------------------------------------

void setToken(String value) {
  token = value;
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
        '/fazer_pedido': (context) => const FazerPedidoPage(),
        '/consultar_pedido': (context) => const ConsultarPedidoPage(),
        '/lista_de_atletas': (context) => const ListaAtletasPage(),
        '/register_user': (context) => const AddPlayerPage(),
        '/lista_de_supervisores': (context) => const ListaSupervisoresPage(),
      },
    );
  }
}
