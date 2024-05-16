import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/custom_button.dart';
import '../componentes/dropdown_picker.dart';
import '../componentes/navigation_manager.dart';
import '../componentes/date_picker.dart';
import '../componentes/textfield.dart';
import '../componentes/time_picker.dart';
import '../main.dart';

class FazerPedidoFSPage extends StatefulWidget {
  const FazerPedidoFSPage({Key? key}) : super(key: key);

  @override
  _FazerPedidoFSPageState createState() => _FazerPedidoFSPageState();
}

class _FazerPedidoFSPageState extends State<FazerPedidoFSPage> {
  int currentPage = 3;
  late NavigationManager navigationManager;

  TextEditingController leaveDateController = TextEditingController();
  TextEditingController leaveTimeController = TextEditingController();
  TextEditingController destinyController = TextEditingController();
  String transport = ""; // valor padrão
  String supervisor = ""; // valor padrão

  @override
  void initState() {
    super.initState();
    navigationManager = NavigationManager(context, currentPage: currentPage);
  }

  @override
  void dispose() {
    leaveDateController.dispose();
    leaveTimeController.dispose();
    destinyController.dispose();
    super.dispose();
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPage = index;
    });

    navigationManager.navigateToPage(index);
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

  static List<IconData> getPageIcons() {
    switch (getRole()) {
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

  String formatDate(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  String formatTime(TimeOfDay timeOfDay) {
    return "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
  }

  Future<void> addLeaveRequest(BuildContext context) async {
    String formattedLeaveDate = formatDate(DateTime.now());
    String formattedLeaveTime = formatTime(TimeOfDay.now());
    String destiny = destinyController.text;

    if (destiny.isEmpty || transport.isEmpty || supervisor.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Preencha todos os campos obrigatórios *',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    final url = Uri.parse('http://localhost:5000/makeWeekendRequest');

    final response = await http.post(
      url,
      body: json.encode({
        'token': getToken(),
        'leave_date': formattedLeaveDate,
        'leave_time': formattedLeaveTime,
        'destiny': destiny,
        'transport': transport,
        'supervisor': supervisor,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Pedido enviado com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pushNamed(context, '/consultar_pedidos');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Erro ao enviar o pedido. Por favor, tente novamente.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    getMenuItems()[currentPage - 1],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 1.0),
                      child: DatePicker(
                        labelText: 'Data de Saída*',
                        controller: leaveDateController,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                        ' - ',
                        style: TextStyle(
                          color: Color.fromRGBO(79, 79, 79, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: TimePicker(
                        labelText: 'Hora de Saída*',
                        controller: leaveTimeController,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CustomTextField(
                labelText: 'Destino*',
                controller: destinyController,
                onChanged: (value) {},
              ),
              const SizedBox(height: 30),
              Dropdown(
                labelText: 'Transporte*',
                items: const ["transporte publico", "tvde", "carro privado"],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      transport = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
              Dropdown(
                labelText: 'Com Quem Sai*',
                items: const ["pai/mae", "tutor", "empresario"],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      supervisor = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 80),
              SendButton(
                onPressed: () {
                  addLeaveRequest(context);
                },
                buttonText: 'Enviar Pedido',
              ),
            ],
          ),
        ),
      ),
    );
  }
}