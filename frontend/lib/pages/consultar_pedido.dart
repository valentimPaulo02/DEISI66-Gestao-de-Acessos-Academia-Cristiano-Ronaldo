import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../main.dart';

class Pedido {
  int requestId;
  int userId;
  String username;
  String state;
  String date;
  String tipo;

  Pedido({
    required this.requestId,
    required this.userId,
    required this.username,
    required this.state,
    required this.date,
    required this.tipo,
  });
}

class ConsultarPedidoPage extends StatefulWidget {
  const ConsultarPedidoPage({Key? key}) : super(key: key);

  @override
  _ConsultarPedidoPageState createState() => _ConsultarPedidoPageState();
}

class _ConsultarPedidoPageState extends State<ConsultarPedidoPage> {
  int currentPage = 4;
  List<Pedido> pedidosAll = [];
  List<Pedido> pedidosUser = [];
  String tipoPedido = "Temporary";

  @override
  void initState() {
    super.initState();
    _getPedidosFromBackend();
  }

  Future<void> _getPedidosFromBackend() async {
    String url = '';

    if (getRole() == 'athlete') {
      if (tipoPedido == 'Weekend') {
        url = 'http://localhost:5000/getUserWeekendRequest';
      } else if (tipoPedido == 'Temporary') {
        url = 'http://localhost:5000/getUserTemporaryRequest';
      }
    } else {
      if (tipoPedido == 'Weekend') {
        url = 'http://localhost:5000/getAllWeekendRequest';
      } else if (tipoPedido == 'Temporary') {
        url = 'http://localhost:5000/getAllTemporaryRequest';
      }
    }

/*
    pedidosAll.clear();
    pedidosAll.add(Pedido(
        requestId: 20,
        userId: 100,
        username: "joao",
        state: "RECUSADO",
        date: "2002-11-10",tipo: "Temporary"));
        */

    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'token': getToken(),
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success']) {
        setState(() {
          if (getRole() == 'athlete') {
            pedidosUser = (data['list'] as List)
                .map((pedido) => Pedido(
                      requestId: pedido['request_id'],
                      userId: pedido['user_id'],
                      username: pedido['username'],
                      state: pedido['state'],
                      date: pedido['date'], tipo: '',
                    ))
                .toList();
          } else {
            pedidosAll = (data['list'] as List)
                .map((pedido) => Pedido(
                      requestId: pedido['request_id'],
                      userId: pedido['user_id'],
                      username: pedido['username'],
                      state: pedido['state'],
                      date: pedido['date'], tipo: '',
                    ))
                .toList();
          }
        });
      } else {
        print('Erro ao encontrar a lista de pedidos: ${data['error']}');
      }
    } else {
      print('Erro de Net ao procurar lista de pedidos');
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPage = index;
    });

    if (index == 4) {
      tipoPedido = "Weekend";
    } else if (index == 5) {
      tipoPedido = "Temporary";
    }

    _getPedidosFromBackend();
  }

  List<Pedido> getFilteredPedidos() {
    if (getRole() == 'athlete') {
      return pedidosUser;
    } else {
      return pedidosAll;
    }
  }

  static List<String> getMenuItems() {
    switch (getRole()) {
      case 'admin':
        return menuItemsAdmin;
      case 'supervisor':
        return menuItemsSupervisor;
      case 'athlete':
        return menuItemsAthlete;
      default:
        return [];
    }
  }

  List<IconData> getPageIcons() {
    switch (role) {
      case 'admin':
        return pageIconsAdmin;
      case 'supervisor':
        return pageIconsSupervisor;
      case 'athlete':
        return pageIconsAthlete;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(191, 191, 191, 0.8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: CustomAppBar(
          currentPage: currentPage,
          onMenuItemSelected: _navigateToPage,
        ),
      ),
      drawer: AppPages(
        menuItems: getMenuItems(),
        currentPageTitle: getMenuItems()[currentPage - 1],
        currentPageIndex: currentPage,
        onMenuItemSelected: _navigateToPage,
        pageIcons: getPageIcons(),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Lista de Pedidos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tipoPedido = "Temporary";
                    });
                    _getPedidosFromBackend();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: tipoPedido == "Temporary"
                        ? const Color.fromRGBO(3, 110, 73, 1)
                        : Colors.grey,
                  ),
                  child: const Text('Saída Temporária'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tipoPedido = "Weekend";
                    });
                    _getPedidosFromBackend();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: tipoPedido == "Weekend"
                        ? const Color.fromRGBO(3, 110, 73, 1)
                        : Colors.grey,
                  ),
                  child: const Text('Saída Fim-de-Semana'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: getFilteredPedidos().length,
              itemBuilder: (context, index) {
                final pedido = getFilteredPedidos()[index];
                return ListTile(
                  title: Text(
                    '${pedido.date} - ${pedido.username} (ID: ${pedido.userId})',
                  ),
                  subtitle: Text('Estado: ${pedido.state}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
