import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const TimePicker({
    Key? key,
    required this.labelText,
    required this.controller,
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
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                initialEntryMode: TimePickerEntryMode.input,
                useRootNavigator: true,
                // remove o AM/PM que n estava a ser preciso
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.highContrastLight(
                        primary: Color.fromRGBO(0, 128, 87, 0.4),
                      ),
                    ),
                    child: MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    ),
                  );
                },
              );

              if (pickedTime != null) {
                final formattedTime =
                    '${pickedTime.hour.toString().padLeft(2, '0')}:'
                    '${pickedTime.minute.toString().padLeft(2, '0')}';
                controller.text = formattedTime;
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
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.input,
                    useRootNavigator: true,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.highContrastLight(
                            primary: Color.fromRGBO(0, 128, 87, 0.4),
                          ),
                        ),
                        child: MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        ),
                      );
                    },
                  );

                  if (pickedTime != null) {
                    final formattedTime =
                        '${pickedTime.hour.toString().padLeft(2, '0')}:'
                        '${pickedTime.minute.toString().padLeft(2, '0')}';
                    controller.text = formattedTime;
                  }
                },
                icon: const Icon(Icons.access_time),
                color: const Color.fromRGBO(79, 79, 79, 0.8),
                iconSize: 18.0,
              ),
            ),
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
