import 'package:appnongsan/widgets/horizontal_product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách yêu thích'),
      ),
      body: Container(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData ||
                !snapshot.data!.exists ||
                !snapshot.data!.data()!.containsKey('favourites')) {
              return const Center(
                child: Text('Không có sản phẩm yêu thích nào.'),
              );
            }

            List<dynamic> favourites = snapshot.data!['favourites'] ?? [];
            print('Favourites: $favourites'); // Debug log

            if (favourites.isEmpty) {
              return const Center(
                child: Text('Không có sản phẩm yêu thích nào.'),
              );
            }

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _getFavouriteProducts(favourites),
              builder: (context, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Check for errors
                if (futureSnapshot.hasError) {
                  return Center(
                    child: Text(
                        'Error fetching products: ${futureSnapshot.error}'),
                  );
                }
                if (!futureSnapshot.hasData || futureSnapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Không có sản phẩm yêu thích nào.'),
                  );
                }

                print('Future Data: ${futureSnapshot.data}'); // Debug log

                return ListView.builder(
                  itemCount: futureSnapshot.data!.length,
                  itemBuilder: (context, index) {
                    var productData = futureSnapshot.data![index];
                    var productId = favourites[index];
                    return HorizontalProductCard(
                      snap: productData,
                      productId: productId,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getFavouriteProducts(
      List<dynamic> favourites) async {
    List<Map<String, dynamic>> productDataList = [];

    for (var productId in favourites) {
      try {
        DocumentSnapshot<Map<String, dynamic>> productDoc =
            await FirebaseFirestore.instance
                .collection('product')
                .doc(productId)
                .get();

        if (productDoc.exists) {
          productDataList.add(productDoc.data()!);
        } else {
          print(
              'Product not found for ID: $productId'); // Log if the product is not found
        }
      } catch (e) {
        print('Error fetching product ID $productId: $e'); // Log any errors
      }
    }
    print('Fetched Products: $productDataList'); // Debug log

    return productDataList; // Return the collected data
  }
}
