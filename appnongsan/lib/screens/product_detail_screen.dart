import 'package:appnongsan/screens/payment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});
  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '');
  bool _isExpanded = false; // Track whether the description is expanded
  int _currentUserRating = 0; // User's rating
  double _averageRating = 0.0; // Average rating
  int _totalRatings = 0; // Count of total ratings

  @override
  void initState() {
    super.initState();
    _fetchRatings(); // Load ratings when the screen initializes
  }

  // Method to fetch user's rating and average rating
  void _fetchRatings() async {
    final userId = FirebaseAuth
        .instance.currentUser!.uid; // Replace with the logged-in user's ID

    final productRef =
        FirebaseFirestore.instance.collection('product').doc(widget.productId);

    // Get user's rating
    final userRatingDoc =
        await productRef.collection('ratings').doc(userId).get();
    if (userRatingDoc.exists) {
      setState(() {
        _currentUserRating = userRatingDoc['rating'];
      });
    }

    // Calculate average rating
    final ratingsSnapshot = await productRef.collection('ratings').get();
    int totalRatingValue = 0;
    int ratingCount = ratingsSnapshot.docs.length;

    for (var doc in ratingsSnapshot.docs) {
      totalRatingValue += (doc['rating'] as num).toInt();
    }

    setState(() {
      _averageRating = ratingCount > 0 ? totalRatingValue / ratingCount : 0.0;
      _totalRatings = ratingCount;
    });
  }

  // Update the user's rating in Firestore
  void _updateRating(int rating) async {
    final userId = FirebaseAuth
        .instance.currentUser!.uid; // Replace with the logged-in user's ID

    await FirebaseFirestore.instance
        .collection('product')
        .doc(widget.productId)
        .collection('ratings')
        .doc(userId)
        .set({
      'rating': rating,
    });

    setState(() {
      _currentUserRating = rating;
    });

    _fetchRatings(); // Refresh the average rating after updating
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('product')
            .doc(widget.productId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Product not found.'));
          }

          final productData = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image
                      Image.network(productData['imageUrl']),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          productData['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${formatCurrency.format(productData['price'])} VND',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Xuất xứ: ${productData['origin']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Số lượng: ${productData['stockQuantity']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),

                            // Average Rating Display
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      Icons.star,
                                      size: 15,
                                      color: index < _averageRating
                                          ? Colors.yellow
                                          : Colors.grey,
                                    );
                                  }),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  _averageRating.toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '( '+ _totalRatings.toString() + ' đánh giá )',style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),

                            // User's Rating Section
                            Text(
                              'Đánh giá của bạn:',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < _currentUserRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.yellow,
                                  ),
                                  onPressed: () {
                                    _updateRating(index + 1);
                                  },
                                );
                              }),
                            ),
                            const SizedBox(height: 20),
                            // Description Header
                            const Text(
                              'Chi tiết sản phẩm:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),

                            // Description Text
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isExpanded
                                        ? productData['description']
                                        : productData['description'].length >
                                                100
                                            ? '${productData['description'].substring(0, 100)}...'
                                            : productData['description'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  if (productData['description'].length >
                                      100) ...[
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isExpanded =
                                              !_isExpanded; // Toggle expansion state
                                        });
                                      },
                                      child: Text(
                                        _isExpanded ? 'Thu gọn' : 'Xem thêm',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),
                            // Description, etc.
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // "Đặt hàng ngay" button, etc.
              Container(
                height: 60, // Fixed height for the button
                width: double.infinity, // Full width
                margin: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.green, // Button color
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle order action
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => PaymentPage(
                                productId: widget.productId,
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Set background to transparent
                    elevation: 0, // No elevation for the button
                  ),
                  child: const Text(
                    'Đặt hàng ngay',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
