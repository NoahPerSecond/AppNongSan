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
  bool _isFavorite = false; // Initialize to false
  int _quantity = 1;
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
  Future<void> _updateQuantity(int change) async {
    setState(() {
      _quantity = (_quantity + change).clamp(1, 100); // Ensure quantity stays within bounds
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Update the quantity of the cart item
      // To handle quantity updates correctly, consider removing the item first
      // await removeFromCart();
      // await addToCart(); // Then re-add with the new quantity
      print(_quantity);
    }
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
              borderRadius: BorderRadius.circular(12),
            ),
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
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  widget.snap['price'].toString(),
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              widget.snap['price'].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _updateQuantity(-1),
                            icon: Icon(Icons.remove, size: 20),
                          ),
                          Text(
                            '$_quantity',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _updateQuantity(1),
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
              onPressed: () { if (_isFavorite) {
                      removeFromFavourites(); // Xóa khỏi yêu thích
                    } else {
                      addToFavourites(); // Thêm vào yêu thích
                    }},
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_outline,
                size: 20,
                color: _isFavorite ? Colors.red : Colors.black,
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
              onPressed: () {if (_isInCart) {
                      removeFromCart(); // Xóa khỏi giỏ hàng
                    } else {
                      addToCart(); // Thêm vào giỏ hàng
                    }},
              icon: Icon(
                _isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                size: 20,
                color: _isInCart ? Colors.red : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
