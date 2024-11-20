import 'package:appnongsan/resources/auth_methods.dart';
import 'package:appnongsan/screens/forget_password_screen.dart';
import 'package:appnongsan/screens/login_screen.dart';
import 'package:appnongsan/widgets/login_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPasswordConfirmScreen extends StatelessWidget {
  String gmail;
  ForgetPasswordConfirmScreen({super.key, required this.gmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt mật khẩu mới' ,
          style: TextStyle(color: Colors.white),
        ),
        leading: InkWell(
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ForgetPasswordScreen())),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
            Text('Một email đổi mật khẩu đã được gửi đến', style: TextStyle(fontSize: 17),),
            SizedBox(height: 10,),
            Text(gmail, style: TextStyle(fontSize: 17, color: Colors.green),),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Không nhận được email? '),
                InkWell(
                  onTap: () => AuthMethods().resetPassword(gmail),
                  child: Text('Gửi lại email.', style: TextStyle(color: Colors.green),),
                )
              ],
            ),
            
            SizedBox(height: 10,),
            LoginButton(
                text: 'Quay về trang đăng nhập',
                isLoading: false,
                onPressed: ()  {
                   Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()));
                })
          ],
        ),
      ),
    );
  }
}