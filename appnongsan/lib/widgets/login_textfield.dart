import 'package:flutter/material.dart';

class LoginTextfield extends StatelessWidget {
  final String hintText;
  
  LoginTextfield({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 54,
      child: TextField(
        decoration:  InputDecoration(
          // fillColor: Color.fromARGB(8, 194, 94, 1),
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}
