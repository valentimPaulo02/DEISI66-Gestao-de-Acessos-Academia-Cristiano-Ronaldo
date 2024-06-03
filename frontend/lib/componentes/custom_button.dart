import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const SendButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 51,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 128, 87, 0.9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}