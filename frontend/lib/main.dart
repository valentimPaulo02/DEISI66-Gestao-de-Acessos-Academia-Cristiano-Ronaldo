import 'package:deisi66/componentes/get_role.dart';
import 'package:deisi66/pages/consultar_pedidos.dart';
import 'package:deisi66/pages/lista_de_presen%C3%A7as.dart';
import 'package:deisi66/pages/pedido_saida_fim_de_semana.dart';
import 'package:deisi66/pages/pedido_saida_temporaria.dart';
import 'package:deisi66/pages/lista_atletas.dart';
import 'package:deisi66/pages/lista_supervisores.dart';
import 'package:deisi66/pages/profile.dart';
import 'package:deisi66/pages/registar_supervisor.dart';
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
  'Pedido Saida Temporaria',
  'Pedido Saida Fim de Semana',
  'Consultar Pedidos',
  'Lista de Atletas',
  'Lista de Supervisores',
  'Lista de Presenças'
];

final menuItemsAthlete = [
  'Home',
  'Pedido Saida Temporaria',
  'Pedido Saida Fim de Semana',
  'Consultar Pedidos',
];

final menuItemsSupervisor = [
  'Home',
  'Consultar Pedidos',
  'Lista de Atletas',
];

// Page Icons ----------------------------

final List<IconData> pageIconsAdmin = [
  Icons.home,
  Icons.list_alt,
  Icons.list_alt,
  Icons.remove_red_eye,
  Icons.group_outlined,
  Icons.supervisor_account,
  Icons.online_prediction
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
String role = "admin";

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
        '/pedido_saida_temporaria': (context) => const FazerPedidoTPage(),
        '/pedido_saida_fim_de_semana': (context) => const FazerPedidoFSPage(),
        '/consultar_pedidos': (context) => const ConsultarPedidoPage(),
        '/lista_de_atletas': (context) => const ListaAtletasPage(),
        '/register_user': (context) => const AddPlayerPage(),
        '/lista_de_supervisores': (context) => const ListaSupervisoresPage(),
        '/registar_supervisores': (context) => const AddSupervisorPage(),
        '/profile': (context) => const ProfilePage(),
        '/lista_de_presenças': (context) => const ListaPresencasPage(),
      },
    );
  }
}
