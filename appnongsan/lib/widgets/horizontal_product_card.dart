import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HorizontalProductCard extends StatefulWidget {
  final snap;
  final String? productId;

  HorizontalProductCard({super.key, required this.snap, this.productId});

  @override
  State<HorizontalProductCard> createState() => _HorizontalProductCardState();
}

class _HorizontalProductCardState extends State<HorizontalProductCard> {
  bool _isFavorite = true;
  int _quantity = 1;
  Future<void> _updateQuantity(int change) async {
    setState(() {
      _quantity = (_quantity + change).clamp(
          1, 100); // Cập nhật giá trị _quantity trước khi lưu vào Firestore
    });

    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favourites')
        .doc(widget.productId)
        .update({
      "quantity": _quantity, // Lưu giá trị đã cập nhật vào Firestore
    });
  }

  Future<void> removeFromFavourites() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('favourites')
          .doc(widget.productId)
          .delete();

      // Cập nhật trạng thái UI sau khi xóa khỏi mục yêu thích
      setState(() {
        _isFavorite = false;
      });

      print('Product removed from favourites');
    } catch (e) {
      print('Failed to remove from favourites: $e');
    }
  }

  Future<void> checkIfFavorite() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .doc(widget.productId)
          .get();

      if (doc.exists) {
        setState(() {
          _isFavorite = true;
        });
      } else {
        setState(() {
          _isFavorite = false; // Nếu không tồn tại, đảm bảo trạng thái được cập nhật
        });
      }
    }
  }

  // Future<void> toggleFavorite() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return;

  //   if (_isFavorite) {
  //     // Remove from favorites
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .collection('favourites')
  //         .doc(widget.productId)
  //         .delete();
  //     setState(() {
  //       _isFavorite = false; // Update the UI
  //     });
  //   } else {
  //     // Add to favorites
  //     final String category = widget.snap["category"];
  //     final String description = widget.snap["description"];
  //     final String imageUrl = widget.snap["imageUrl"];
  //     final String name = widget.snap["name"];
  //     final String origin = widget.snap["origin"];
  //     final int stockQuantity = widget.snap["stockQuantity"];
  //     final String price = widget.snap["price"];
  //     final String newPrice = widget.snap["newPrice"];
  //     final bool isSale = widget.snap["isSale"];
  //     final int rating = widget.snap["rating"];

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .collection('favourites')
  //         .doc(widget.productId)
  //         .set({
  //       'productId': widget.productId,
  //       "category": category,
  //       "description": description,
  //       "imageUrl": imageUrl,
  //       "name": name,
  //       "origin": origin,
  //       "stockQuantity": stockQuantity,
  //       "price": price,
  //       "newPrice": newPrice,
  //       "isSale": isSale,
  //       "rating": rating,
  //       "quantity": _quantity,
  //     });
  //     setState(() {
  //       _isFavorite = true; // Update the UI
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.3),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image(
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.snap['imageUrl'].toString(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['name'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            size: 15,
                            Icons.star,
                            color: index < widget.snap['rating']
                                ? Colors.yellow
                                : Colors.grey,
                          );
                        }),
                      ),
                      SizedBox(height: 5),
                      (widget.snap['isSale'])
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.snap['newPrice'].toString(),
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  widget.snap['price'].toString(),
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            )
                          : Text(
                              widget.snap['price'].toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                _updateQuantity(-1), // Giảm số lượng
                            icon: Icon(Icons.remove, size: 20),
                          ),
                          Text(
                            '$_quantity', // Hiển thị số lượng
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                            onPressed: () =>
                                _updateQuantity(1), // Tăng số lượng
                            icon: Icon(Icons.add, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                if (_isFavorite) {
                  removeFromFavourites(); // Xóa khỏi yêu thích
                } 
              },
              icon: Icon(
                _isFavorite
                    ? Icons.favorite // Red icon if favorite
                    : Icons.favorite_outline, // Outline if not favorite
                size: 20,
                color: _isFavorite
                    ? Colors.red
                    : Colors.black, // Change color based on state
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 20,
                )),
          ),
        ),
      ],
    );
  }
}
