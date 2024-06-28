import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../date_picker_choice.dart';

class CpFilter extends StatefulWidget {
  final String? initialUsernameFilter;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final ValueChanged<String> onUsernameFilterChanged;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final VoidCallback? onClearFilters;

  const CpFilter({
    Key? key,
    this.initialUsernameFilter,
    this.initialStartDate,
    this.initialEndDate,
    required this.onUsernameFilterChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    this.onClearFilters,
  }) : super(key: key);

  @override
  _CpFilterState createState() => _CpFilterState();
}

class _CpFilterState extends State<CpFilter> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.initialUsernameFilter ?? '';
    startDateController.text = widget.initialStartDate != null
        ? DateFormat('yyyy-MM-dd').format(widget.initialStartDate!)
        : '';
    endDateController.text = widget.initialEndDate != null
        ? DateFormat('yyyy-MM-dd').format(widget.initialEndDate!)
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FloatingActionButton(
          onPressed: () {
            usernameController.text = widget.initialUsernameFilter ?? '';
            startDateController.text = widget.initialStartDate != null
                ? DateFormat('yyyy-MM-dd').format(widget.initialStartDate!)
                : '';
            endDateController.text = widget.initialEndDate != null
                ? DateFormat('yyyy-MM-dd').format(widget.initialEndDate!)
                : '';
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Filter Pedidos',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              controller: usernameController,
                              onChanged: (value) {
                                widget.onUsernameFilterChanged(value);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Username:',
                                labelStyle: TextStyle(
                                  color: Color.fromRGBO(79, 79, 79, 0.8),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(79, 79, 79, 0.8),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(79, 79, 79, 0.8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Start Date'),
                                            content: DatePickerS(
                                              controller: startDateController,
                                              verification: true,
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 128, 87, 1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: AbsorbPointer(
                                      child: TextField(
                                        controller: startDateController,
                                        keyboardType: TextInputType.datetime,
                                        decoration: InputDecoration(
                                          labelText: 'StartDate:',
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                                Icons.calendar_today),
                                            color: const Color.fromRGBO(
                                                79, 79, 79, 0.8),
                                            iconSize: 18.0,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('EndDate'),
                                            content: DatePickerS(
                                              controller: endDateController,
                                              verification: true,
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 128, 87, 1)),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: AbsorbPointer(
                                      child: TextField(
                                        controller: endDateController,
                                        keyboardType: TextInputType.datetime,
                                        decoration: InputDecoration(
                                          labelText: 'EndDate:',
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                                Icons.calendar_today),
                                            color: const Color.fromRGBO(
                                                79, 79, 79, 0.8),
                                            iconSize: 18.0,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    usernameController.clear();
                                    startDateController.clear();
                                    endDateController.clear();
                                    widget.onClearFilters?.call();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black12,
                                  ),
                                  child: const Text('Clear All'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    widget.onStartDateChanged(
                                      startDateController.text.isNotEmpty
                                          ? DateTime.parse(
                                              startDateController.text)
                                          : null,
                                    );
                                    widget.onEndDateChanged(
                                      endDateController.text.isNotEmpty
                                          ? DateTime.parse(
                                              endDateController.text)
                                          : null,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(0, 128, 87, 0.7),
                                  ),
                                  child: const Text('Filter'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          backgroundColor: const Color.fromRGBO(0, 128, 87, 0.7),
          child: const Icon(Icons.filter_list, color: Colors.white),
        ),
        if (usernameController.text.isNotEmpty ||
            startDateController.text.isNotEmpty ||
            endDateController.text.isNotEmpty)
          Positioned(
            top: 5,
            right: 5,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.red,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.clear, size: 12, color: Colors.white),
                onPressed: () {
                  usernameController.clear();
                  startDateController.clear();
                  endDateController.clear();
                  widget.onClearFilters?.call();
                },
              ),
            ),
          ),
      ],
    );
  }
}
