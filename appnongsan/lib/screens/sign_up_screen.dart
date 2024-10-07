import 'package:appnongsan/reponsive/mobile_screen_layout.dart';
import 'package:appnongsan/reponsive/reponsive_screen_layout.dart';
import 'package:appnongsan/reponsive/web_screen_layout.dart';
import 'package:appnongsan/resources/auth_methods.dart';
import 'package:appnongsan/screens/auth_screen.dart';
import 'package:appnongsan/screens/login_screen.dart';
import 'package:appnongsan/utils/utils.dart';
import 'package:appnongsan/widgets/login_button.dart';
import 'package:appnongsan/widgets/login_textfield.dart';
import 'package:appnongsan/widgets/password_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController rePassController = TextEditingController();
  String uid = Uuid().v4();
  bool isLoading = false;

  void sendEmailVerification() async {
    String res = await AuthMethods().sendVerificationEmail();
    if (res == 'success') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AuthScreen(
                gmail: emailController.text,
                password: passController.text,
                uid: uid,
              )));
    }
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    
    String res = await AuthMethods().signUpUser(
      email: emailController.text,
      password: passController.text,
      uid: uid
    );
    print(res);
    if (res == 'success') {
      // await AuthMethods().sendVerificationEmail();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => AuthScreen(
                    gmail: emailController.text,
                    password: passController.text,
                    uid: uid,
                  )),
        );
      }
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
    rePassController.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  bool obscureTextPass = true;
  bool obscureTextRePass = true;

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
            LoginTextfield(
              hintText: 'Tên tài khoản',
              editingController: emailController,
            ),
            const SizedBox(
              height: 24,
            ),
            // PasswordTextfield(
            //   hintText: 'Mật khẩu',
            //   editingController: passController,
            // ),
            // const SizedBox(
            //   height: 24,
            // ),
            // PasswordTextfield(
            //   hintText: 'Nhập lại mật khẩu',
            //   editingController: rePassController,
            // ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      height: 54,
                      child: TextFormField(
                        obscureText: obscureTextPass,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                        controller: passController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(obscureTextPass
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  obscureTextPass = !obscureTextPass;
                                });
                              },
                            ),
                            hintText: 'Mật khẩu',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                      ),
                    ),
                    const SizedBox(
              height: 24,
            ),
                    Container(
                      width: 350,
                      height: 54,
                      child: TextFormField(
                        obscureText: obscureTextRePass,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passController.text) {
                            return 'Passwords do not match';
                          }
                        },
                        controller: rePassController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(obscureTextRePass
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  obscureTextRePass = !obscureTextRePass;
                                });
                              },
                            ),
                            hintText: 'Mật khẩu',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: 350,
                      height: 54,
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            signUpUser();
                            // Proceed with registration logic
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(content: Text('Passwords match!')),
                            // );
                          }
                        },
                        child: Text(
                          'Đăng ký tài khoản',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green, // Màu nền của nút

                          padding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0), // Padding của nút
                        ),
                      ),
                    ),
                  ],
                )),

            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Đã có tài khoản? '),
                InkWell(
                    onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen())),
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
