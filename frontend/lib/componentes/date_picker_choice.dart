import 'package:flutter/material.dart';

class DatePickerS extends StatefulWidget {
  final TextEditingController controller;
  final bool verification;

  const DatePickerS({
    Key? key,
    required this.controller,
    required this.verification,
  }) : super(key: key);

  @override
  _DatePickerSState createState() => _DatePickerSState();
}

class _DatePickerSState extends State<DatePickerS> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: widget.verification ? DateTime(1900) : currentDate,
      lastDate: widget.verification ? currentDate : DateTime(2100),
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
      widget.controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: '',
        filled: true,
        fillColor: const Color.fromRGBO(0, 128, 87, 0.4),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: IconButton(
          onPressed: () => _selectDate(context),
          icon: const Icon(Icons.calendar_today),
          color: const Color.fromRGBO(79, 79, 79, 0.8),
          iconSize: 18.0,
        ),
      ),
      style: const TextStyle(
        color: Color.fromRGBO(255, 255, 255, 0.8),
        fontSize: 16,
      ),
    );
  }
}
