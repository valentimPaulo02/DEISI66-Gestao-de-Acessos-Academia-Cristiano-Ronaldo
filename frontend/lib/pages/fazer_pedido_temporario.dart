import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';
import '../main.dart';

class FazerPedidoTPage extends StatefulWidget {
  const FazerPedidoTPage({Key? key}) : super(key: key);

  @override
  _FazerPedidoTPageState createState() => _FazerPedidoTPageState();
}

class _FazerPedidoTPageState extends State<FazerPedidoTPage> {
  int currentPage = 2;
  late NavigationManager navigationManager;

  DateTime? leaveDate;
  TimeOfDay? leaveTime;
  String destiny = "";
  String transport = "transporte publico"; // valor padrão
  String supervisor = "pai/mae"; // valor padrão
  DateTime? arrivalDate;
  TimeOfDay? arrivalTime;

  @override
  void initState() {
    super.initState();
    navigationManager = NavigationManager(context, currentPage: currentPage);
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

  String formatDate(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  String formatTime(TimeOfDay timeOfDay){
    return "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
  }

  Future<void> addLeaveRequest(BuildContext context) async {
      String formattedLeaveDate = formatDate(
          DateTime(leaveDate!.year, leaveDate!.month, leaveDate!.day));
      String formattedLeaveTime = formatTime(
          TimeOfDay(hour: leaveTime!.hour, minute:leaveTime!.minute));
      String formattedReturnDate = formatDate(
          DateTime(arrivalDate!.year, arrivalDate!.month, arrivalDate!.day));
      String formattedReturnTime = formatTime(
          TimeOfDay(hour: arrivalTime!.hour, minute: arrivalTime!.minute));

      final url = Uri.parse('http://localhost:5000/makeTemporaryRequest');

      final response = await http.post(
        url,
        body: json.encode({
          'token': getToken(),
          'leave_date': formattedLeaveDate,
          'leave_time': formattedLeaveTime,
          'destiny': destiny,
          'transport': transport,
          'supervisor': supervisor,
          'arrival_date': formattedReturnDate,
          'arrival_time': formattedReturnTime,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          Navigator.pushNamed(context, '/consultar_pedido');
        }
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  getMenuItems()[currentPage - 1],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text("Data de Saída: "),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(9999),
                            );
                            if (pickedDate != null && pickedDate != leaveDate) {
                              setState(() {
                                leaveDate = pickedDate;
                              });
                            }
                          },
                          child: const Text("Escolher Data"),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        const Text("Hora de Saída: "),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null && pickedTime != leaveTime) {
                              setState(() {
                                leaveTime = pickedTime;
                              });
                            }
                          },
                          child: const Text("Escolher Hora"),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(labelText: 'Destino'),
                  onChanged: (value) {
                    destiny = value;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: transport,
                  items: ["transporte publico", "tvde", "carro privado"]
                      .map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        transport = newValue;
                      });
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Transporte'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: supervisor,
                  items: ["", "pai/mae", "tutor", "empresario"]
                      .map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        supervisor = newValue;
                      });
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Com Quem Sai'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text("Data de Retorno: "),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(9999),
                            );
                            if (pickedDate != null &&
                                pickedDate != arrivalDate) {
                              setState(() {
                                arrivalDate = pickedDate;
                              });
                            }
                          },
                          child: const Text("Escolher Data"),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        const Text("Hora de Retorno: "),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null &&
                                pickedTime != arrivalTime) {
                              setState(() {
                                arrivalTime = pickedTime;
                              });
                            }
                          },
                          child: const Text("Escolher Hora"),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    addLeaveRequest(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(3, 110, 73, 1),
                  ),
                  child: const Text('Enviar Pedido'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
