import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.isPassword = false,
    required this.controller,
    this.keyboardType,
    this.onChanged,
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
            obscureText: isPassword,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: '',
              filled: true,
              fillColor: const Color.fromRGBO(4, 180, 107, 0.3),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            style: const TextStyle(
              color: Color.fromRGBO(79, 79, 79, 0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}