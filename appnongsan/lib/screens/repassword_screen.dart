import 'package:appnongsan/screens/login_screen.dart';
import 'package:appnongsan/widgets/login_button.dart';
import 'package:appnongsan/widgets/login_textfield.dart';
import 'package:flutter/material.dart';

class RepasswordScreen extends StatefulWidget {
  const RepasswordScreen({super.key});

  @override
  State<RepasswordScreen> createState() => _RepasswordScreenState();
}

class _RepasswordScreenState extends State<RepasswordScreen> {
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
          onPressed: () =>Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => LoginScreen()
                        )
                        )
                        ,
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
                'Vui lòng nhập mật khẩu mới cho tài khoản của bạn'),
            SizedBox(
              height: 16,
            ),
            LoginTextfield(
                hintText: 'Mật khẩu',
                editingController: accController),
            SizedBox(
              height: 16,
            ),
            LoginTextfield(
                hintText: 'Nhập lại mật khẩu',
                editingController: accController),
            SizedBox(
              height: 16,
            ),
            LoginButton(text: 'Cập nhật', isLoading: false, onPressed: () {})
          ],
        ),
      ),
    );
  }
}