import 'package:appnongsan/reponsive/mobile_screen_layout.dart';
import 'package:appnongsan/reponsive/reponsive_screen_layout.dart';
import 'package:appnongsan/reponsive/web_screen_layout.dart';
import 'package:appnongsan/resources/auth_methods.dart';
import 'package:appnongsan/screens/forget_password_screen.dart';
import 'package:appnongsan/screens/sign_up_screen.dart';
import 'package:appnongsan/utils/utils.dart';
import 'package:appnongsan/widgets/login_button.dart';
import 'package:appnongsan/widgets/login_textfield.dart';
import 'package:appnongsan/widgets/password_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    bool isLoading = false;

    void logInUser() async {
      setState(() {
        isLoading = true;
      });
      String res = await AuthMethods().logInUser(
          email: emailController.text, password: passController.text);
      setState(() {
        isLoading = false;
      });
      if (res == 'success') {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const ReponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              ),
            ),
          );
        }
      } else {
        showSnackBar(res, context);
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/logo_logo.jpg'),
            const SizedBox(
              height: 32,
            ),
            LoginTextfield(
              hintText: 'Tên tài khoản',
              editingController: emailController,
            ),
            const SizedBox(
              height: 24,
            ),
            PasswordTextfield(
              hintText: 'Mật khẩu',
              editingController: passController,
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.only(left: 240),
              child: InkWell(
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => ForgetPasswordScreen()
                        )
                        )
                        ,
                child: Text('Quên mật khẩu ?'),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width: 350,
              height: 54,
              child: TextButton(
                onPressed: logInUser,
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green, // Màu nền của nút

                  padding: EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0), // Padding của nút
                ),
              ),
            ),
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
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Chưa có tài khoản? '),
                InkWell(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignUpScreen())),
                  child: Text(
                    'Đăng ký',
                    style: TextStyle(color: Colors.green),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
