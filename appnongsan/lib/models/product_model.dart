// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String category;
  final String description;
  final String imageUrl;
  final String name;
  final String origin;
  final int stockQuantity;
  final String uid;
  final String price;
  final String newPrice;
  final int rating;

  ProductModel({
    required this.price,
    required this.newPrice,
    required this.rating,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.origin,
    required this.stockQuantity,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "category": category,
        "description": description,
        "imageUrl": imageUrl,
        "name": name,
        "origin": origin,
        "stockQuantity": stockQuantity,
      };

  static ProductModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ProductModel(
        uid: snapshot['uid'],
        category: snapshot['category'],
        description: snapshot['description'],
        imageUrl: snapshot['imageUrl'],
        name: snapshot['name'],
        origin: snapshot['origin'],
        stockQuantity: snapshot['stockQuantity'],
        price: snapshot['price'],
        newPrice: snapshot['newPrice'],
        rating: snapshot['rating']);
  }
}
