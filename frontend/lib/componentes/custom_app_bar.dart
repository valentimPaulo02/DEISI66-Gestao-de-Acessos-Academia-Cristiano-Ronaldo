import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final int currentPage;
  final Function(int) onMenuItemSelected;

  const CustomAppBar({
    Key? key,
    required this.currentPage,
    required this.onMenuItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(4, 180, 107, 1),
      leading: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Opacity(
                opacity: 0.9,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/images/leaoGarraMenu.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 10,
                  height: 10,
                ),
              ));
        },
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
            // code when profile image is clicked
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
