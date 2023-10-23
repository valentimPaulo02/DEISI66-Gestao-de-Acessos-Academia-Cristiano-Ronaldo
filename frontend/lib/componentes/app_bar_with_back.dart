import 'package:flutter/material.dart';

class CustomAppBarWithBack extends StatelessWidget {
  final Function() onBackButtonPressed;

  const CustomAppBarWithBack({
    Key? key,
    required this.onBackButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(4, 180, 107, 1),
      leading: GestureDetector(
        onTap: onBackButtonPressed,
        child: Opacity(
          opacity: 0.9,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/arrowBack.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
            width: 25,
            height: 25,
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'lib/images/leaoPages.png',
              width: 35,
              height: 35,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            // código quando a imagem do perfil é clicada
          },
          child: Opacity(
            opacity: 0.9,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/profileimg.png'),
                ),
              ),
              width: 25,
              height: 5,
            ),
          ),
        ),
      ],
    );
  }
}
