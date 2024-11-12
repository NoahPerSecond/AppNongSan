import 'package:appnongsan/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  CategoryScreen({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('product')
            .where('category', isEqualTo: categoryName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No products found in this category.'));
          }

          var products = snapshot.data!.docs;
          return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cards per row
                  childAspectRatio: 0.8, // Adjust this value for height/width ratio
                  crossAxisSpacing: 8.0, // Space between cards horizontally
                  mainAxisSpacing: 8.0, // Space between cards vertically
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index].data() as Map<String, dynamic>;
                  return ProductCard(snap: product,productId: product['id'],);
                }
              );
        },
      ),
    );
  }
}
