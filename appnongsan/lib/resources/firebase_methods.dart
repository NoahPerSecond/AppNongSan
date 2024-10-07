import 'package:appnongsan/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMethods {
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel(
            uid: data['uid'],
            username: data['username'],
            phoneNum: data['phoneNum'],
            email: data['email'],
            birthDay: data['birthDay'],
            address: data['address'],
            profileImg: data['profileImg']);
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }
}