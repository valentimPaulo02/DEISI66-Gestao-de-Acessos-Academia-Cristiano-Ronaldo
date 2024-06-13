import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../componentes/app_bar_with_back.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/textfield.dart';
import '../componentes/scp_list_object.dart';
import '../main.dart';

class Pedido {
  int requestId;
  int userId;
  String username;
  String state;
  String date;
  String type;
  String dataSaida;
  String horaSaida;
  String destino;
  String transporte;
  String comQuemSai;
  String dataRetorno;
  String horaRetorno;

  Pedido({
    required this.requestId,
    required this.userId,
    required this.username,
    required this.state,
    required this.date,
    required this.type,
    required this.dataSaida,
    required this.horaSaida,
    required this.destino,
    required this.transporte,
    required this.comQuemSai,
    required this.dataRetorno,
    required this.horaRetorno,
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
  List<Pedido> pedidos = [];
  String tipoPedido = "Temporary";

  @override
  void initState() {
    if (getRole() == 'supervisor') {
      currentPage = 2;
    }
    super.initState();
    _getPedidosFromBackend();
    //_loadFakeTemporaryPedidos();
    //_loadFakeWeekendPedidos();
  }

  /*
  //lista forcada para testes dos pedidos temporários
  Future<void> _loadFakeTemporaryPedidos() async {
    setState(() {
      pedidosAll = [];
      pedidosUser = [];
      for (int i = 0; i < 5; i++) {
        pedidosAll.add(Pedido(
          requestId: i + 1,
          userId: 100 + i,
          username: 'GYOKERES ${i + 1}',
          state: 'pending',
          date: 'Data ${i + 1}',
          type: 'Temporary',
          dataSaida: 'Data Saída ${i + 1}',
          horaSaida: 'Hora Saída ${i + 1}',
          destino: 'Destino ${i + 1}',
          transporte: 'Transporte ${i + 1}',
          comQuemSai: 'Com Quem Sai ${i + 1}',
          dataRetorno: 'Data Retorno ${i + 1}',
          horaRetorno: 'Hora Retorno ${i + 1}',
        ));
      }
    });
  }

  //lista forcada para testes dos pedidos de fim de semana
  Future<void> _loadFakeWeekendPedidos() async {
    setState(() {
      pedidosAll = [];
      pedidosUser = [];
      for (int i = 0; i < 5; i++) {
        pedidosAll.add(Pedido(
          requestId: i + 1,
          userId: 200 + i,
          username: 'ESGAIO ${i + 1}',
          state: 'pending',
          date: 'Data ${i + 1}',
          type: 'Weekend',
          dataSaida: 'Data Saída ${i + 1}',
          horaSaida: 'Hora Saída ${i + 1}',
          destino: 'Destino ${i + 1}',
          transporte: 'Transporte ${i + 1}',
          comQuemSai: 'Com Quem Sai ${i + 1}',
          dataRetorno: '',
          horaRetorno: '',
        ));
      }
    });
  }

   */

  Future<void> _getPedidosFromBackend() async {
    String url = '';
    String type = "";
    pedidosAll.clear();
    pedidosUser.clear();
    pedidos.clear();

    if (getRole() == 'athlete') {
      if (tipoPedido == 'Weekend') {
        type = "Weekend";
        url = 'http://localhost:5000/getUserWeekendRequest';
      } else if (tipoPedido == 'Temporary') {
        type = "Temporary";
        url = 'http://localhost:5000/getUserTemporaryRequest';
      }
    } else {
      if (tipoPedido == 'Weekend') {
        type = "Weekend";
        url = 'http://localhost:5000/getAllWeekendRequest';
      } else if (tipoPedido == 'Temporary') {
        type = "Temporary";
        url = 'http://localhost:5000/getAllTemporaryRequest';
      }
    }

    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'token': getToken(),
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success']) {
        setState(() {
          if (type == "Temporary") {
            pedidos = (data['list'] as List)
                .map((pedido) => Pedido(
                      requestId: pedido['request_id'],
                      userId: pedido['user_id'],
                      username: pedido['username'],
                      state: pedido['state'],
                      date: pedido['date'],
                      type: type,
                      dataSaida: pedido['leave_date'],
                      horaSaida: pedido['leave_time'],
                      destino: pedido['destiny'],
                      transporte: pedido['transport'],
                      comQuemSai: pedido['supervisor'],
                      dataRetorno: pedido['arrival_date'],
                      horaRetorno: pedido['arrival_time'],
                    ))
                .toList();
          } else {
            pedidos = (data['list'] as List)
                .map((pedido) => Pedido(
                      requestId: pedido['request_id'],
                      userId: pedido['user_id'],
                      username: pedido['username'],
                      state: pedido['state'],
                      date: pedido['date'],
                      type: type,
                      dataSaida: pedido['leave_date'],
                      horaSaida: pedido['leave_time'],
                      destino: pedido['destiny'],
                      transporte: pedido['transport'],
                      comQuemSai: pedido['supervisor'],
                      dataRetorno: "",
                      horaRetorno: "",
                    ))
                .toList();
          }
          if (getRole() == "athlete") {
            pedidosUser = pedidos;
          } else {
            pedidosAll = pedidos;
          }
        });
      } else {
        print('Erro ao encontrar a lista de pedidos: ${data['error']}');
      }
    } else {
      print('Erro de Net ao procurar lista de pedidos');
    }
  }

  void _acceptRejectPedido(int requestId, bool accepted) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/checkRequest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'request_id': requestId,
        'accepted': accepted ? 1 : 0,
        'type': tipoPedido,
      }),
    );

    if (response.statusCode == 200) {
      _getPedidosFromBackend();
    } else {
      print('Erro na atualização do pedido: ${response.reasonPhrase}');
    }
  }

  Widget _outputPedidoDetails(Pedido pedido) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data: ${pedido.dataSaida}'),
        Text('Hora Saída: ${pedido.horaSaida}'),
        Text('Destino: ${pedido.destino}'),
        Text('Transporte: ${pedido.transporte}'),
        Text('Com quem sai: ${pedido.comQuemSai}'),
        if (tipoPedido == "Temporary") ...[
          Text('Data Retorno: ${pedido.dataRetorno}'),
          Text('Hora Retorno: ${pedido.horaRetorno}'),
        ],
      ],
    );
  }

  void _showPedidoDetailsDialog(BuildContext context, Pedido pedido) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalhes do Pedido'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _outputPedidoDetails(pedido),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromRGBO(0, 128, 87, 1),
              ),
              child: const Text('Fechar'),
            ),
            if ((getRole() == 'supervisor' || getRole() == 'admin') &&
                pedido.state == "pending") ...[
              TextButton(
                onPressed: () {
                  _acceptRejectPedido(pedido.requestId, true);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(0, 128, 87, 1),
                ),
                child: const Text('Aceitar'),
              ),
              TextButton(
                onPressed: () {
                  _acceptRejectPedido(pedido.requestId, false);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(0, 128, 87, 1),
                ),
                child: const Text('Recusar'),
              ),
            ],
          ],
        );
      },
    );
  }

  void _editPedido(BuildContext context, Pedido pedido) {
    if (pedido.type == 'Temporary' && pedido.state == "pending") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditarPedidoTemporarioPage(pedido: pedido),
        ),
      );
    } else if (pedido.type == 'Weekend' && pedido.state == "pending") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditarPedidoFimDeSemanaPage(pedido: pedido),
        ),
      );
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPage = index;
    });

    if (index == 4) {
      tipoPedido = "Weekend";
      //_loadFakeWeekendPedidos();
      _getPedidosFromBackend();
    } else if (index == 5) {
      tipoPedido = "Temporary";
      //_loadFakeTemporaryPedidos();
      _getPedidosFromBackend();
    }
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

  Widget _buildPedidoListTile(Pedido pedido) {
    return ScpListObject(
      color: pedido.state == "refused"
          ? Colors.black12
          : pedido.state == "pending"
              ? const Color.fromRGBO(243, 194, 66, 0.7)
              : const Color.fromRGBO(0, 128, 87, 0.7),
      nome: pedido.username,
      numeroString: pedido.userId.toString(),
      qqString: pedido.date,
      textoOpcional: "Estado: ${pedido.state}",
      onPressed: () => _showPedidoDetailsDialog(context, pedido),
    );
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
                'Consultar Pedidos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(79, 79, 79, 1),
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
                    //_loadFakeTemporaryPedidos();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: tipoPedido == "Temporary"
                        ? const Color.fromRGBO(0, 128, 87, 1)
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
                    //_loadFakeWeekendPedidos();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: tipoPedido == "Weekend"
                        ? const Color.fromRGBO(0, 128, 87, 1)
                        : Colors.grey,
                  ),
                  child: const Text('Saída Fim-de-Semana'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: getFilteredPedidos().length,
              itemBuilder: (context, index) {
                final pedido = getFilteredPedidos()[index];
                return _buildPedidoListTile(pedido);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EditarPedidoTemporarioPage extends StatefulWidget {
  final Pedido pedido;

  const EditarPedidoTemporarioPage({Key? key, required this.pedido})
      : super(key: key);

  @override
  _EditarPedidoTemporarioPageState createState() =>
      _EditarPedidoTemporarioPageState();
}

class _EditarPedidoTemporarioPageState
    extends State<EditarPedidoTemporarioPage> {
  late TextEditingController dataSaidaController;
  late TextEditingController horaSaidaController;
  late TextEditingController destinoController;
  late TextEditingController transporteController;
  late TextEditingController comQuemSaiController;
  late TextEditingController dataRetornoController;
  late TextEditingController horaRetornoController;

  @override
  void initState() {
    super.initState();
    dataSaidaController = TextEditingController(text: widget.pedido.dataSaida);
    horaSaidaController = TextEditingController(text: widget.pedido.horaSaida);
    destinoController = TextEditingController(text: widget.pedido.destino);
    transporteController =
        TextEditingController(text: widget.pedido.transporte);
    comQuemSaiController =
        TextEditingController(text: widget.pedido.comQuemSai);
    dataRetornoController =
        TextEditingController(text: widget.pedido.dataRetorno);
    horaRetornoController =
        TextEditingController(text: widget.pedido.horaRetorno);
  }

  @override
  void dispose() {
    dataSaidaController.dispose();
    horaSaidaController.dispose();
    destinoController.dispose();
    transporteController.dispose();
    comQuemSaiController.dispose();
    dataRetornoController.dispose();
    horaRetornoController.dispose();
    super.dispose();
  }

  Future<void> _updatePedidoTemporario() async {
    final updatedDataSaida = dataSaidaController.text;
    final updatedHoraSaida = horaSaidaController.text;
    final updatedDestino = destinoController.text;
    final updatedTransporte = transporteController.text;
    final updatedComQuemSai = comQuemSaiController.text;
    final updatedDataRetorno = dataRetornoController.text;
    final updatedHoraRetorno = horaRetornoController.text;

    final Map<String, dynamic> updatedData = {
      'request_id': widget.pedido.requestId,
      'leave_date': updatedDataSaida,
      'leave_time': updatedHoraSaida,
      'destiny': updatedDestino,
      'transport': updatedTransporte,
      'supervisor': updatedComQuemSai,
      'arrival_date': updatedDataRetorno,
      'arrival_time': updatedHoraRetorno,
    };

    final response = await http.post(
      Uri.parse('http://localhost:5000/updateTemporaryRequest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/consultar_pedido');
    } else {
      print(
          'Erro na atualização do pedido temporario: ${response.reasonPhrase}');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              labelText: 'Data Saída:',
              controller: dataSaidaController,
            ),
            CustomTextField(
              labelText: 'Hora Saída:',
              controller: horaSaidaController,
            ),
            CustomTextField(
              labelText: 'Destino:',
              controller: destinoController,
            ),
            CustomTextField(
              labelText: 'Transporte:',
              controller: transporteController,
            ),
            CustomTextField(
              labelText: 'Com quem sai:',
              controller: comQuemSaiController,
            ),
            CustomTextField(
              labelText: 'Data Retorno:',
              controller: dataRetornoController,
            ),
            CustomTextField(
              labelText: 'Hora Retorno:',
              controller: horaRetornoController,
            ),
            ElevatedButton(
              onPressed: _updatePedidoTemporario,
              child: const Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditarPedidoFimDeSemanaPage extends StatefulWidget {
  final Pedido pedido;

  const EditarPedidoFimDeSemanaPage({Key? key, required this.pedido})
      : super(key: key);

  @override
  _EditarPedidoFimDeSemanaPageState createState() =>
      _EditarPedidoFimDeSemanaPageState();
}

class _EditarPedidoFimDeSemanaPageState
    extends State<EditarPedidoFimDeSemanaPage> {
  late TextEditingController dataSaidaController;
  late TextEditingController horaSaidaController;
  late TextEditingController destinoController;
  late TextEditingController transporteController;
  late TextEditingController comQuemSaiController;

  @override
  void initState() {
    super.initState();
    dataSaidaController = TextEditingController(text: widget.pedido.date);
    horaSaidaController = TextEditingController(text: widget.pedido.horaSaida);
    destinoController = TextEditingController(text: widget.pedido.destino);
    transporteController =
        TextEditingController(text: widget.pedido.transporte);
    comQuemSaiController =
        TextEditingController(text: widget.pedido.comQuemSai);
  }

  @override
  void dispose() {
    dataSaidaController.dispose();
    horaSaidaController.dispose();
    destinoController.dispose();
    transporteController.dispose();
    comQuemSaiController.dispose();
    super.dispose();
  }

  Future<void> _updatePedidoFimDeSemana() async {
    final updatedDataSaida = dataSaidaController.text;
    final updatedHoraSaida = horaSaidaController.text;
    final updatedDestino = destinoController.text;
    final updatedTransporte = transporteController.text;
    final updatedComQuemSai = comQuemSaiController.text;

    final Map<String, dynamic> updatedData = {
      'date': updatedDataSaida,
      'horaSaida': updatedHoraSaida,
      'destino': updatedDestino,
      'transporte': updatedTransporte,
      'comQuemSai': updatedComQuemSai,
    };

    final response = await http.patch(
      Uri.parse('http://localhost:5000/updateWeekendRequest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      // Atualização bem-sucedida
    } else {
      print('Erro na atualização do pedido weekend: ${response.reasonPhrase}');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              labelText: 'Data Saída:',
              controller: dataSaidaController,
            ),
            CustomTextField(
              labelText: 'Hora Saída:',
              controller: horaSaidaController,
            ),
            CustomTextField(
              labelText: 'Destino:',
              controller: destinoController,
            ),
            CustomTextField(
              labelText: 'Transporte:',
              controller: transporteController,
            ),
            CustomTextField(
              labelText: 'Com quem sai:',
              controller: comQuemSaiController,
            ),
            ElevatedButton(
              onPressed: _updatePedidoFimDeSemana,
              child: const Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
