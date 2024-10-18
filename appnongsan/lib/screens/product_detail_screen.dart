import 'package:appnongsan/screens/payment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                      // Display product image
                      Image.network(productData['imageUrl']),
                      const SizedBox(height: 10),

                      // Product name
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

                      // Price Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // New price (if applicable)
                            if (productData['newPrice'] != null &&
                                productData['newPrice'] > 0) ...[
                              Row(
                                children: [
                                  Text(
                                    '${formatCurrency.format(productData['newPrice'])} VND',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  // Show the original price with strikethrough
                                  Text(
                                    '${formatCurrency.format(productData['price'])} VND',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              // If newPrice is not available, just show the original price
                              Text(
                                '${formatCurrency.format(productData['price'])} VND',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),

                            // Origin
                            Text(
                              'Xuất xứ: ${productData['origin']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),

                            // Stock quantity
                            Text(
                              'Số lượng: ${productData['stockQuantity']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start ,
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < productData['rating']
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.yellow,
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

                            // Rating
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Fixed "Đặt hàng ngay" button at the bottom
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
                    MaterialPageRoute(builder: (context) => PaymentPage(productId: widget.productId,)),
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
