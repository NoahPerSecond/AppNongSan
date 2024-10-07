import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String? username;
  final String? phoneNum;
  final String? birthDay;
  final String? address;
  final String? profileImg;

  UserModel({
    required this.email,
    required this.uid,
    this.username,
    this.phoneNum,
    this.birthDay,
    this.address,
    this.profileImg,
  });

  // Convert the user model to a JSON map
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "username": username,
        "phoneNum": phoneNum,
        "birthDay": birthDay,
        "address": address,
        "profileImg": profileImg,
      };

  // Create a user model from a Firestore document snapshot
  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot['uid'],
      email: snapshot['email'],
      username: snapshot['username'],
      phoneNum: snapshot['phoneNum'],
      birthDay: snapshot['birthDay'],
      address: snapshot['address'],
      profileImg: snapshot['profileImg'],
    );
  }
}
