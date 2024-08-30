import 'dart:async';

import 'package:appnongsan/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    String res = '';

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      res = 'success';
      print('Verification email sent');
    } else {
      res = 'failed';
    }
    return res;
  }

  Future<void> checkEmailVerification() async {
    final Timer timer;
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      timer = Timer.periodic(Duration(seconds: 3), (timer) async {
        await user?.reload(); // Tải lại thông tin người dùng
      user = FirebaseAuth.instance
          .currentUser; // Cập nhật thông tin người dùng sau khi tải lại

      if (user!.emailVerified) {
        timer.cancel();
        
        // Đưa người dùng đến trang chính của ứng dụng
      } 
    }
      
      );}
      
    
  }

  Future<String> signUpUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        UserModel user = UserModel(uid: cred.user!.uid, email: email);

        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'success';

        // Gửi email xác thực
        await sendVerificationEmail();

        // Đăng xuất người dùng (tùy chọn) để yêu cầu họ xác thực email trước khi đăng nhập lại
        await FirebaseAuth.instance.signOut();
        print('Please check your email for a verification link.');
        // await firestore.collection('user').add({
        //   'username' : userName,
        //   'uid' : cred.user!.uid,
        //   'email' : email,
        //   'bio' : bio,
        //   'followers': [],
        //   'following': [],
        // });
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> logInUser(
      {required String email, required String password}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
