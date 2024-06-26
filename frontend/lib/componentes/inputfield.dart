import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final bool enabled;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  const InputField({
    Key? key,
    required this.labelText,
    this.isPassword = false,
    this.onChanged,
    this.initialValue,
    this.enabled = true,
    this.controller,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller =
        controller ?? TextEditingController(text: initialValue);

    // Se o initialValue estiver definido e não houver um controlador,
    // definimos o texto no controlador
    if (initialValue != null && controller == null) {
      _controller.text = initialValue!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: isPassword,
        onChanged: onChanged,
        controller: _controller,
        readOnly: !enabled,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color.fromRGBO(150, 150, 150, 0.5),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(150, 150, 150, 1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(0, 128, 87, 0.4),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: suffixIcon,
        ),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
    );
  }
}
