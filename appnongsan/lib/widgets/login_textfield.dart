import 'package:flutter/material.dart';

class LoginTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController editingController;
  
  LoginTextfield({super.key, required this.hintText, required this.editingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 54,
      child: TextFormField(
        controller: editingController,
        decoration:  InputDecoration(
          
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}
