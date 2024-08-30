import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final Function onPressed;
  LoginButton({super.key, required this.text, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 54,
      child: OutlinedButton(
        onPressed: () => onPressed, 
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        child:(isLoading) ? CircularProgressIndicator() : Text(text,style: TextStyle(color: Colors.white),)),
    );
  }
}
