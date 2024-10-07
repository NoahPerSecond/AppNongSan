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

  Future<void> _updateQuantity(int change) async {
    setState(() {
      _quantity = (_quantity + change).clamp(1, 100); // Ensure quantity stays within bounds
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .doc(widget.productId)
          .update({
        "quantity": _quantity, // Update Firestore with new quantity
      });
    }
  }

  Future<void> removeFromFavourites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favourites')
            .doc(widget.productId)
            .delete();

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
          .collection('favourites')
          .doc(widget.productId)
          .get();

      // Check if the state is still mounted before calling setState
      if (mounted) {
        setState(() {
          _isFavorite = doc.exists; // Set based on document existence
        });
      }
    } catch (e) {
      // Handle any errors that occur during the Firestore call
      print('Error checking favorite status: $e');

      // Optional: You can also set _isFavorite to false if there's an error
      if (mounted) {
        setState(() {
          _isFavorite = false;
        });
      }
    }
  }
}


  // Uncomment and use this method to toggle favorite status
  Future<void> toggleFavorite() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_isFavorite) {
      await removeFromFavourites(); // Remove from favorites
    } else {
      // Add to favorites logic here
      // Set Firestore document with product details
      setState(() {
        _isFavorite = true; // Update the UI
      });
    }
  }

  @override
  void initState() {
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
                            onPressed: () => _updateQuantity(-1),
                            icon: Icon(Icons.remove, size: 20),
                          ),
                          Text(
                            '$_quantity',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
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
              onPressed: toggleFavorite, // Toggle favorite status
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
