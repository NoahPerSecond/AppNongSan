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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfFavorite();
  }
  

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   checkIfFavorite(); // Kiểm tra lại trạng thái yêu thích khi widget thay đổi
  // }

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
      print('Error checking favorite status: $e');
      // You may also want to set _isFavorite to false here as a fallback
      if (mounted) {
        setState(() {
          _isFavorite = false;
        });
      }
    }
  }
}

  

  Future<void> addToFavourites() async {
    User? user = FirebaseAuth.instance.currentUser;
    final String category = widget.snap["category"];
    final String description = widget.snap["description"];
    final String imageUrl = widget.snap["imageUrl"];
    final String name = widget.snap["name"];
    final String origin = widget.snap["origin"];
    final int stockQuantity = widget.snap["stockQuantity"];
    final String price = widget.snap["price"];
    final String newPrice = widget.snap["newPrice"];
    final bool isSale = widget.snap["isSale"];
    final int rating = widget.snap["rating"];
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('favourites')
          .doc(widget.productId)
          .set({
        'productId': widget.productId,
        "category": category,
        "description": description,
        "imageUrl": imageUrl,
        "name": name,
        "origin": origin,
        "stockQuantity": stockQuantity,
        "price": price,
        "newPrice": newPrice,
        "isSale": isSale,
        "rating": rating,
        "quantity": 1,
      });
      print('Product added to favourites');
      setState(() {
        _isFavorite = true;
      });
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
            decoration: BoxDecoration(
                border: Border.all(width: 0.3),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
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
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
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
    removeFromFavourites();  // Xóa khỏi yêu thích
  } else {
    addToFavourites();  // Thêm vào yêu thích
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
                  )),
            )),
        Positioned(
            top: 80,
            right: 6,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: 20,
                    // color: Colors.white,
                  )),
            )),
      ],
    );
  }
}
