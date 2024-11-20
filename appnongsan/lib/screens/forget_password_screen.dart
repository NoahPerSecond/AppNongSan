import 'package:appnongsan/resources/auth_methods.dart';
import 'package:appnongsan/screens/forget_password_confirm_screen.dart';
import 'package:appnongsan/screens/login_screen.dart';
import 'package:appnongsan/widgets/login_button.dart';
import 'package:appnongsan/widgets/login_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController accController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lấy lại mật khẩu',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen())),
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Text(
              'Nhập thông tin tài khoản',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
                'Vui lòng nhập tên tài khoản email mà bạn đã đăng ký tài khoản'),
            SizedBox(
              height: 16,
            ),
            LoginTextfield(
                hintText: 'Tên tài khoản gmail',
                editingController: accController),
            SizedBox(
              height: 16,
            ),
            LoginButton(
                text: 'Tiếp theo',
                isLoading: false,
                onPressed: () async {
                  await AuthMethods().resetPassword(accController.text);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ForgetPasswordConfirmScreen(
                          gmail: accController.text)));
                })
          ],
        ),
      ),
    );
  }
}
