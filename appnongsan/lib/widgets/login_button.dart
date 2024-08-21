import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 54,
     
      child: OutlinedButton(
        onPressed: () {}, 
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        child: Text('Đăng nhập',style: TextStyle(color: Colors.white),)),
    );
  }
}
