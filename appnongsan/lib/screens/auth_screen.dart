import 'dart:async';

import 'package:appnongsan/resources/auth_methods.dart';
import 'package:appnongsan/screens/home_screen.dart';
import 'package:appnongsan/screens/sign_up_screen.dart';
import 'package:appnongsan/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  String gmail;
  String password;
  AuthScreen({super.key, required this.gmail, required this.password});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // void checkEmailVerification() async {
  //   String res ='';
  //   res = 
  //   if(res == 'success')
  //   {
  //     Navigator.of(context).pushReplacement(
  //               MaterialPageRoute(builder: (context) => HomeScreen()));
  //   }
  //   else{
  //     showSnackBar('Error', context);
  //   }
  // }

//   void _checkEmailVerification() async {
//   String res = await AuthMethods().checkEmailVerification();
//   if(res == 'success')
//   {
//     print('gui email x2');
//     Timer.periodic(Duration(seconds: 3), (timer) async {
//       Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) => HomeScreen()));
//                 timer.cancel();
//     });
    
//   }
// }

void _startEmailVerificationCheck() {
     Timer _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
        print('User reloaded: ${user?.email}, Verified: ${user?.emailVerified}');
        if (user != null && user.emailVerified) {
           print('Email verified! Navigating to home screen...');
          timer.cancel();
          Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      }
    });
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _startEmailVerificationCheck();
  }

  @override
  Widget build(BuildContext context) {


    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xác nhận' ,
          style: TextStyle(color: Colors.white),
        ),
        leading: InkWell(
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignUpScreen())),
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
            Text('Một email xác nhận đã được gửi đến', style: TextStyle(fontSize: 17),),
            SizedBox(height: 10,),
            Text(widget.gmail, style: TextStyle(fontSize: 17, color: Colors.green),),
          ],
        ),
      ),
    );
  }
}
