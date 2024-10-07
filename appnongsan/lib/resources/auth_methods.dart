import 'dart:async';

import 'package:appnongsan/models/user_model.dart';
import 'package:appnongsan/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signOut(BuildContext context) async {
    try {
      await auth.signOut(); // Đăng xuất người dùng
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              LoginScreen())); // Chuyển hướng về màn hình đăng nhập
    } catch (e) {
      print("Error signing out: $e");
      // Xử lý lỗi nếu cần
    }
  }

  Future<User?> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.success) {
      final OAuthCredential credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      return userCredential.user;
    } else {
      print('Facebook login failed: ${loginResult.message}');
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Bắt đầu quá trình đăng nhập
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Nếu người dùng hủy quá trình đăng nhập
      if (googleUser == null) {
        print('Người dùng đã hủy quá trình đăng nhập');
        return null;
      }

      // Lấy thông tin từ Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Tạo một credential từ token
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập vào Firebase với credential từ Google
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Kiểm tra nếu đăng nhập thành công
      if (user != null) {
        print('Đăng nhập thành công: ${user.displayName}');
        await saveUserToFirestore(user);
        return user;
      } else {
        print('Đăng nhập thất bại');
        return null;
      }
    } catch (e) {
      // Xử lý ngoại lệ
      print('Lỗi trong quá trình đăng nhập với Google: $e');
      return null;
    }
  }

  Future<void> saveUserToFirestore(User user) async {
    try {
      UserModel userMd = UserModel(
          uid: user.uid,
          email: user.email!,
          username: '',
          phoneNum: '',
          birthDay: '',
          address: '',
          profileImg: '');
      // Create or update the user document in Firestore
      await firestore.collection('users').doc(user.uid).set(
          userMd.toJson(),
          SetOptions(
              merge: true)); // Use merge to avoid overwriting existing data
      print('Lưu thông tin người dùng thành công');
    } catch (e) {
      print('Lỗi khi lưu người dùng vào Firestore: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  Future<String> sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    String res = '';

    if (user != null) {
      await user.sendEmailVerification();
      res = 'success';
      print('Verification email sent');
    } else {
      res = 'failed';
    }
    return res;
  }

  void checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user
          .reload(); // Tải lại thông tin người dùng để cập nhật trạng thái
      if (user.emailVerified) {
        print('Email đã được xác thực');
        // Thực hiện điều hướng hoặc các hành động khác sau khi xác thực thành công
      } else {
        print('Email chưa được xác thực');
      }
    }
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String uid,
    final String? username,
    final String? phoneNum,
    final String? birthDay,
    final String? address,
    final String? profileImg,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);
        String sendResult = await sendVerificationEmail();
        if (sendResult == 'success') {
          UserModel user = UserModel(
              uid: cred.user!.uid,
              email: email,
              username: '',
              phoneNum: '',
              birthDay: '',
              address: '',
              profileImg: '');

          await firestore
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toJson());
          res = 'success';
        }

        // Gửi email xác thực

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

//   Future<String> signIn(String email, String password) async {
//     String res = "Some error occurred";
//   try {
//     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     res = "success";
//     User? user = userCredential.user;
//     if (user != null && user.emailVerified) {
//       print('Đăng nhập thành công');
//     } else {
//       res = 'Vui lòng xác thực email trước khi đăng nhập';
//       print('Vui lòng xác thực email trước khi đăng nhập');
//       await FirebaseAuth.instance.signOut();  // Đăng xuất nếu email chưa được xác thực
//     }
//   } catch (e) {
//     print('Đăng nhập thất bại: $e');
//   }
//   return res;
// }
}
