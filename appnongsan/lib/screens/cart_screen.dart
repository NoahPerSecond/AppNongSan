import 'package:appnongsan/widgets/horizontal_product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late User? user;

  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    // Lấy dữ liệu người dùng
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    List<dynamic> cart = userDoc.data()?['cart'] ?? [];

    // Kiểm tra xem có sản phẩm trong giỏ hàng không
    if (cart.isEmpty) {
      return [];
    }

    // Lấy thông tin sản phẩm từ Firestore dựa trên cart array
    return Future.wait(cart.map((productId) async {
      DocumentSnapshot<Map<String, dynamic>> productDoc = await FirebaseFirestore.instance
          .collection('product')
          .doc(productId)
          .get();

      if (productDoc.exists) {
        return productDoc.data()!;
      } else {
        print('Product with ID $productId does not exist');
        return null; // Trả về null nếu sản phẩm không tồn tại
      }
    })).then((products) {
      // Lọc bỏ các sản phẩm null (có thể không tồn tại)
      return products.where((product) => product != null).cast<Map<String, dynamic>>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Giỏ hàng trống.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var productData = snapshot.data![index];
              var productId = productData['id']; // Đảm bảo lấy productId từ dữ liệu
              return HorizontalProductCard(
                snap: productData,
                productId: productId,
              );
            },
          );
        },
      ),
    );
  }
}
