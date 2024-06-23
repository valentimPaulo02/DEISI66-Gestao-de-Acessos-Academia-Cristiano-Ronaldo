import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool verification;

  const DatePicker({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.verification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              labelText,
              style: const TextStyle(color: Color.fromRGBO(79, 79, 79, 0.8)),
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: TextInputType.datetime,
            readOnly: true,
            onTap: () async {
              final DateTime currentDate = DateTime.now();

              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: currentDate,
                firstDate: verification ? DateTime(1900) : currentDate,
                lastDate: verification ? currentDate : DateTime(2100),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.highContrastLight(
                        primary: Color.fromRGBO(0, 128, 87, 0.4),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                final formattedDate =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                controller.text = formattedDate;
              }
            },
            decoration: InputDecoration(
              labelText: '',
              filled: true,
              fillColor: const Color.fromRGBO(0, 128, 87, 0.4),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffixIcon: IconButton(
                onPressed: () async {
                  final DateTime currentDate = DateTime.now();

                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: currentDate,
                    firstDate: verification ? DateTime(1900) : currentDate,
                    lastDate: verification ? currentDate : DateTime(2100),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.highContrastLight(
                            primary: Color.fromRGBO(0, 128, 87, 0.4),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    final formattedDate =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    controller.text = formattedDate;
                  }
                },
                icon: const Icon(Icons.calendar_today),
                color: const Color.fromRGBO(79, 79, 79, 0.8),
                iconSize: 18.0,
              ),
            ),
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}