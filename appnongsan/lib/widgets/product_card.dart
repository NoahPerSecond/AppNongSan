import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final snap;
  final String? productId;

  ProductCard({super.key, required this.snap, this.productId});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;
  bool _isInCart = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
    checkIfInCart();
  }

  Future<void> addToCart() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'cart': FieldValue.arrayUnion([widget.productId]),
      });

      setState(() {
        _isInCart = true; // Cập nhật trạng thái UI
      });
      print('Product added to cart');
    } catch (e) {
      print('Failed to add to cart: $e');
    }
  }

  Future<void> removeFromCart() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'cart': FieldValue.arrayRemove([widget.productId]),
      });

      setState(() {
        _isInCart = false; // Cập nhật trạng thái UI
      });
      print('Product removed from cart');
    } catch (e) {
      print('Failed to remove from cart: $e');
    }
  }

  Future<void> checkIfInCart() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        List<dynamic> cartItems = doc['cart'] ?? [];
        setState(() {
          _isInCart = cartItems.contains(widget.productId);
        });
      } catch (e) {
        print('Error checking cart status: $e');
        setState(() {
          _isInCart = false;
        });
      }
    }
  }

  Future<void> removeFromFavourites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'favourites': FieldValue.arrayRemove([widget.productId]),
        });

        setState(() {
          _isFavorite = false;
        });
        print('Product removed from favourites');
      } catch (e) {
        print('Failed to remove from favourites: $e');
      }
    }
  }

  Future<void> checkIfFavorite() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        List<dynamic> favoriteItems = doc['favourites'] ?? [];
        setState(() {
          _isFavorite = favoriteItems.contains(widget.productId);
        });
      } catch (e) {
        print('Error checking favorite status: $e');
        setState(() {
          _isFavorite = false;
        });
      }
    }
  }

  Future<void> addToFavourites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'favourites': FieldValue.arrayUnion([widget.productId]),
      });

      setState(() {
        _isFavorite = true;
      });
      print('Product added to favourites');
    } catch (e) {
      print('Failed to add to favourites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Container(
            width: 160,
            decoration: BoxDecoration(
                border: Border.all(width: 0.3),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Image(
                    width: 160,
                    height: 120,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      widget.snap['imageUrl'].toString(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        overflow: TextOverflow.ellipsis,
                        widget.snap['name'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
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
                      (widget.snap['isSale'])
                          ? Column(
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
                                )
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 22,
                                ),
                                Text(widget.snap['price'].toString()),
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
            top: 6,
            right: 6,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: IconButton(
                  onPressed: () {
                    if (_isFavorite) {
                      removeFromFavourites(); // Xóa khỏi yêu thích
                    } else {
                      addToFavourites(); // Thêm vào yêu thích
                    }
                  },
                  icon: Icon(
                    _isFavorite
                        ? Icons.favorite // Icon đỏ nếu đã yêu thích
                        : Icons.favorite_outline, // Outline nếu chưa yêu thích
                    size: 20,
                    color: _isFavorite
                        ? Colors.red
                        : Colors.black, // Đổi màu theo trạng thái
                  )),
            )),
        Positioned(
            top: 80,
            right: 6,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: IconButton(
                  onPressed: () {
                    if (_isInCart) {
                      removeFromCart(); // Xóa khỏi giỏ hàng
                    } else {
                      addToCart(); // Thêm vào giỏ hàng
                    }
                  },
                  icon: Icon(
                    _isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                    size: 20,
                    color: _isInCart ? Colors.red : Colors.black,
                  )),
            )),
      ],
    );
  }
}
