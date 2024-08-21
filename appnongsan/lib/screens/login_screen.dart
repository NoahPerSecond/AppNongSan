import 'package:appnongsan/widgets/login_button.dart';
import 'package:appnongsan/widgets/login_textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/logo_logo.jpg'),
            const SizedBox(
              height: 32,
            ),
            LoginTextfield(hintText: 'Số điện thoại hoặc gmail'),
            const SizedBox(
              height: 24,
            ),
            LoginTextfield(hintText: 'Mật khẩu'),
            const SizedBox(
              height: 12,
            ),
            const Padding(
                padding: EdgeInsets.only(left: 240),
                child: Text('Quên mật khẩu ?')),
            const SizedBox(
              height: 12,
            ),
            const LoginButton(),
            const SizedBox(
              height: 24,
            ),
            const Text('Hoặc'),
            const SizedBox(
              height: 24,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/fb_logo.jpg'),
                  ),
                  Text('Facebook')
                ]),
                SizedBox(
                  width: 50,
                ),
                Column(children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/gg_logo.webp'),
                  ),
                  Text('Google')
                ])
              ],
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Chưa có tài khoản? '), Text('Đăng ký', style: TextStyle(color: Colors.green),)],
            )
          ],
        ),
      ),
    );
  }
}
