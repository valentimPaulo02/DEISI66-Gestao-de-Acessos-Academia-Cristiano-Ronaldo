import 'dart:convert';
import 'dart:ui';
import 'package:deisi66/componentes/custom_button.dart';
import 'package:deisi66/componentes/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../componentes/app_bar_with_back.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/dropdown_picker.dart';
import '../componentes/filters/cp_filter.dart';
import '../componentes/textfield.dart';
import '../componentes/scp_list_object.dart';
import '../componentes/time_picker.dart';
import '../main.dart';

class Pedido {
  int requestId;
  int userId;
  String username;
  String state;
  String date;
  String type;
  String note;
  String updatedBy;
  String updatedAt;
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
    required this.note,
    required this.updatedBy,
    required this.updatedAt,
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
  String usernameFilter = "";
  DateTime? startDateFilter;
  DateTime? endDateFilter;

  @override
  void initState() {
    if (getRole() == 'supervisor') {
      currentPage = 2;
    }
    super.initState();
    //_getPedidosFromBackend();
    _loadFakeTemporaryPedidos();
    _loadFakeWeekendPedidos();
  }

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
          state: 'authorized',
          date: '2024-06-18',
          type: 'Temporary',
          dataSaida: '2024-06-18',
          horaSaida: 'Hora Saída ${i + 1}',
          destino: 'Destino ${i + 1}',
          transporte: 'transporte publico',
          comQuemSai: 'pai/mae',
          dataRetorno: '2024-06-21',
          horaRetorno: 'Hora Retorno ${i + 1}',
          note: 'abcde',
          updatedBy: 'staff01',
          updatedAt: '2024-07-01',
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
          date: '2024-06-18',
          type: 'Weekend',
          dataSaida: '2024-06-18',
          horaSaida: 'Hora Saída ${i + 1}',
          destino: 'Destino ${i + 1}',
          transporte: 'transporte publico',
          comQuemSai: 'pai/mae',
          dataRetorno: '2024-06-21',
          horaRetorno: 'Hora Retorno ${i + 1}',
          note: 'abcde',
          updatedBy: 'staff01',
          updatedAt: '2024-07-01',
        ));
      }
    });
  }

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
                      note: pedido['note'],
                      updatedBy: pedido['updated_by'],
                      updatedAt: pedido['updated_at'],
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
                      dataRetorno: pedido['arrival_date'],
                      horaRetorno: pedido['arrival_time'],
                      note: pedido['note'],
                      updatedBy: pedido['updated_by'],
                      updatedAt: pedido['updated_at'],
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
        'updated_by': getToken(),
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
        Text('Pedido feito a ${pedido.date}'),
        Text(''),
        Text('--------------- Detalhes ---------------'),
        Text('Data Saída: ${pedido.dataSaida}'),
        Text('Hora Saída: ${pedido.horaSaida}'),
        Text('Destino: ${pedido.destino}'),
        Text('Transporte: ${pedido.transporte}'),
        Text('Com quem sai: ${pedido.comQuemSai}'),
        Text('Data Retorno: ${pedido.dataRetorno}'),
        Text('Hora Retorno: ${pedido.horaRetorno}'),
        Text(''),
        Text('-------------- Informação --------------'),
        Text('Estado: ${pedido.state}'),
        Text('Verificado por: ${pedido.updatedBy.replaceAll('_', ' ')}'),
        Text('Verificado a: ${pedido.updatedAt}'),
        Text(''),
        Text('Nota: ${pedido.note}'),
      ],
    );
  }

  void _showPedidoDetailsDialog(BuildContext context, Pedido pedido) {
    TextEditingController noteController =
        TextEditingController(text: pedido.note);
    bool controller = false;
    bool accepted;
    bool isSelectedA = false;
    bool isSelectedR = false;
    pedido.state == "authorized" ? accepted = true : accepted = false;
    String noteA = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Detalhes do Pedido',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      _outputPedidoDetails(pedido),
                      const SizedBox(height: 16),
                      if ((getRole() == 'supervisor' || getRole() == 'admin') &&
                          pedido.state == "pending") ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                _acceptRejectPedido(pedido.requestId, true);
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    const Color.fromRGBO(0, 128, 87, 1),
                              ),
                              child: const Text('Aceitar'),
                            ),
                            TextButton(
                              onPressed: () {
                                _acceptRejectPedido(pedido.requestId, false);
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    const Color.fromRGBO(0, 128, 87, 1),
                              ),
                              child: const Text('Recusar'),
                            ),
                          ],
                        ),
                      ],
                      if ((getRole() == 'supervisor' || getRole() == 'admin') &&
                          (pedido.state == "authorized" ||
                              pedido.state == "refused")) ...[
                        if (!controller)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    controller = true;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      const Color.fromRGBO(0, 128, 87, 1),
                                ),
                                child: const Text('Editar'),
                              ),
                            ],
                          ),
                        if (controller) ...{
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _editRequest(
                                      context, pedido, noteA, accepted);
                                  Navigator.pop(context);
                                },
                                iconSize: 20,
                                splashRadius: 25.0,
                                icon: const Icon(Icons.save,
                                    color: Color.fromRGBO(0, 128, 87, 1)),
                              ),
                              const SizedBox(width: 13),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    accepted = true;
                                    isSelectedA = true;
                                    isSelectedR = false;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: isSelectedR
                                      ? const Color.fromRGBO(0, 128, 87, 0.5)
                                      : const Color.fromRGBO(0, 128, 87, 1),
                                ),
                                child: const Text('Aceitar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    accepted = false;
                                    isSelectedR = true;
                                    isSelectedA = false;
                                  });
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: isSelectedA
                                        ? const Color.fromRGBO(0, 128, 87, 0.5)
                                        : const Color.fromRGBO(0, 128, 87, 1)),
                                child: const Text('Recusar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _askForNoteDialog(
                                      context, pedido, noteController,
                                      (String value) {
                                    setState(() {
                                      noteA = value;
                                    });
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      const Color.fromRGBO(0, 128, 87, 1),
                                ),
                                child: const Text('Nota'),
                              ),
                            ],
                          ),
                        }
                      ],
                    ],
                  ),
                  Positioned(
                    top: -12,
                    right: -13,
                    child: IconButton(
                      iconSize: 18,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _askForNoteDialog(BuildContext context, Pedido pedido,
      TextEditingController noteController, Function(String) onNoteChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Nota'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                onNoteChanged(noteController.text);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromRGBO(0, 128, 87, 1),
              ),
              child: const Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                onNoteChanged("");
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromRGBO(0, 128, 87, 1),
              ),
              child: const Text('Não'),
            ),
          ],
        );
      },
    );
  }

  void _editRequest(
      BuildContext context, Pedido pedido, String note, bool accepted) async {
    final data = {
      "request_id": pedido.requestId,
      "accepted": accepted ? 1 : 0,
      "type": pedido.type,
      "note": note,
    };

    final response = await http.post(
      Uri.parse('http://localhost:5000/editRequest'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody["success"]) {
        _getPedidosFromBackend();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido atualizado com sucesso.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${responseBody["error"]}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao comunicar com o servidor.')),
      );
    }
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
      _loadFakeWeekendPedidos();
      //_getPedidosFromBackend();
    } else if (index == 5) {
      tipoPedido = "Temporary";
      _loadFakeTemporaryPedidos();
      //_getPedidosFromBackend();
    }
  }

  List<Pedido> getFilteredPedidos() {
    List<Pedido> filteredPedidos = [];

    if (getRole() == 'athlete') {
      filteredPedidos = List.from(pedidosUser);
    } else {
      filteredPedidos = List.from(pedidosAll);
    }

    if (usernameFilter.isNotEmpty) {
      filteredPedidos = filteredPedidos
          .where((pedido) =>
              pedido.username.toLowerCase().contains(usernameFilter))
          .toList();
    }

    if (startDateFilter != null) {
      filteredPedidos = filteredPedidos
          .where((pedido) => DateTime.parse(pedido.date)
              .isAfter(startDateFilter!.subtract(const Duration(days: 1))))
          .toList();
    }

    if (endDateFilter != null) {
      filteredPedidos = filteredPedidos
          .where((pedido) => DateTime.parse(pedido.date)
              .isBefore(endDateFilter!.add(const Duration(days: 1))))
          .toList();
    }

    return filteredPedidos;
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

  void _filterByUsername(String value) {
    setState(() {
      usernameFilter = value.toLowerCase();
    });
  }

  void _filterByStartDate(DateTime? value) {
    setState(() {
      startDateFilter = value;
    });
  }

  void _filterByEndDate(DateTime? value) {
    setState(() {
      endDateFilter = value;
    });
  }

  void _clearFilters() {
    setState(() {
      usernameFilter = '';
      startDateFilter = null;
      endDateFilter = null;
    });
  }

  Widget _buildPedidoListTile(Pedido pedido) {
    return ScpListObject(
      color: pedido.state == "refused"
          ? Colors.black12
          : pedido.state == "pending"
              ? const Color.fromRGBO(243, 194, 66, 0.7)
              : const Color.fromRGBO(0, 128, 87, 0.7),
      nome: pedido.username.replaceAll('_', ' '),
      numeroString: pedido.userId.toString(),
      qqString: pedido.date,
      textoOpcional: "Estado: ${pedido.state}",
      onPressed: () => _showPedidoDetailsDialog(context, pedido),
      onEditPressed: pedido.state == "pending" && getRole() == "athlete"
          ? () => _editPedido(context, pedido)
          : null,
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
      body: Stack(
        children: [
          Column(
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
                        //_getPedidosFromBackend();
                        _loadFakeTemporaryPedidos();
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
                        //_getPedidosFromBackend();
                        _loadFakeWeekendPedidos();
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
          Positioned(
            bottom: 20,
            right: 20,
            child: CpFilter(
              initialUsernameFilter: usernameFilter,
              initialStartDate: startDateFilter,
              initialEndDate: endDateFilter,
              onUsernameFilterChanged: _filterByUsername,
              onStartDateChanged: _filterByStartDate,
              onEndDateChanged: _filterByEndDate,
              onClearFilters: _clearFilters,
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
      Navigator.pushNamed(context, '/consultar_pedidos');
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                  child: Text(
                'Editar Pedido Temporário',
                style: TextStyle(
                  color: Color.fromRGBO(79, 79, 79, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
              const SizedBox(height: 15),
              DatePicker(
                labelText: 'Data Saída:',
                controller: dataSaidaController,
                verification: false,
              ),
              const SizedBox(height: 15),
              TimePicker(
                labelText: 'Hora Saída:',
                controller: horaSaidaController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                labelText: 'Destino:',
                controller: destinoController,
              ),
              const SizedBox(height: 15),
              Dropdown(
                labelText: "Transporte:",
                initialValue: transporteController.text,
                items: const ["transporte publico", "tvde", "carro privado"],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      transporteController.text = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              Dropdown(
                labelText: "Com quem sai:",
                initialValue: comQuemSaiController.text,
                items: const ["pai/mae", "tutor", "empresario"],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      comQuemSaiController.text = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              DatePicker(
                labelText: 'Data Retorno:',
                controller: dataRetornoController,
                verification: false,
              ),
              const SizedBox(height: 15),
              TimePicker(
                labelText: 'Hora Retorno:',
                controller: horaRetornoController,
              ),
              const SizedBox(height: 20),
              SendButton(
                onPressed: _updatePedidoTemporario,
                buttonText: 'Atualizar',
              ),
            ],
          ),
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

  Future<void> _updatePedidoFimDeSemana() async {
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
      Uri.parse('http://localhost:5000/updateWeekendRequest'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/consultar_pedidos');
    } else {
      print(
          'Erro na atualização do pedido fim de semana: ${response.reasonPhrase}');
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                  child: Text(
                'Editar Pedido Fim De Semana',
                style: TextStyle(
                  color: Color.fromRGBO(79, 79, 79, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
              const SizedBox(height: 15),
              DatePicker(
                labelText: 'Data Saída:',
                controller: dataSaidaController,
                verification: false,
              ),
              const SizedBox(height: 15),
              TimePicker(
                labelText: 'Hora Saída:',
                controller: horaSaidaController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                labelText: 'Destino:',
                controller: destinoController,
              ),
              const SizedBox(height: 15),
              Dropdown(
                labelText: "Transporte:",
                initialValue: transporteController.text,
                items: const ["transporte publico", "tvde", "carro privado"],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      transporteController.text = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              Dropdown(
                labelText: "Com quem sai:",
                initialValue: comQuemSaiController.text,
                items: const ["pai/mae", "tutor", "empresario"],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      comQuemSaiController.text = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              DatePicker(
                labelText: 'Data Retorno:',
                controller: dataRetornoController,
                verification: false,
              ),
              const SizedBox(height: 15),
              TimePicker(
                labelText: 'Hora Retorno:',
                controller: horaRetornoController,
              ),
              const SizedBox(height: 20),
              SendButton(
                onPressed: _updatePedidoFimDeSemana,
                buttonText: 'Atualizar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
