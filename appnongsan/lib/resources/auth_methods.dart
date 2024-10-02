import 'dart:async';

import 'package:appnongsan/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
    await user.reload();  // Tải lại thông tin người dùng để cập nhật trạng thái
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
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);
        String sendResult = await sendVerificationEmail();
        if (sendResult == 'success') {
          UserModel user = UserModel(uid: cred.user!.uid, email: email);

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
