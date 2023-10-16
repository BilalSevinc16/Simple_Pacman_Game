import 'package:flutter/material.dart';

class Pacman extends StatelessWidget {
  const Pacman({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset(
        "images/pacman.png",
        color: Colors.yellow,
      ),
    );
  }
}
