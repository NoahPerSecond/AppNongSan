import 'package:appnongsan/widgets/horizontal_product_card.dart';
import 'package:appnongsan/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách yêu thích'),),
      body: Container(
                  
                  
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users').doc(user!.uid).collection('favourites')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => HorizontalProductCard(
                                snap: snapshot.data!.docs[index].data()));
                      }),
                ),
    );
  }
}