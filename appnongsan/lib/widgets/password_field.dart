import 'package:flutter/material.dart';

class PasswordTextfield extends StatefulWidget {
  final String hintText;
  final TextEditingController editingController;
  final String? prePass;
  
    PasswordTextfield(
      {super.key,
      required this.hintText,
      required this.editingController,
      this.prePass = ''
      });

  @override
  State<PasswordTextfield> createState() => _LoginTextfieldState();
}

class _LoginTextfieldState extends State<PasswordTextfield> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 54,
      child: TextFormField(
        
        obscureText: obscureText,
        controller: widget.editingController,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
            ),
            hintText: widget.hintText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}
