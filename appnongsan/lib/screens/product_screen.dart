import 'package:appnongsan/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  String sortBy;
  ProductScreen({super.key, required this.sortBy});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String _selectedSortBy = 'Giá'; // Default sort by 'Giá'
  bool _isAscending = true; // Default order is ascending
  late Query<Map<String, dynamic>> _productQuery;

  @override
  void initState() {
    super.initState();
    _selectedSortBy = widget.sortBy ?? 'Giá';
    _productQuery = FirebaseFirestore.instance.collection('product');
    _sortProducts(_selectedSortBy, true);
  }

  // Method to update the query based on selected sorting
  void _sortProducts(String sortBy, bool isAscending) {
    setState(() {
      _isAscending = isAscending;
      switch (sortBy) {
        case 'Giá':
          _productQuery = FirebaseFirestore.instance
              .collection('product')
              .orderBy('price', descending: !isAscending); // Sort by price
          break;
        case 'Thời gian':
          _productQuery = FirebaseFirestore.instance
              .collection('product')
              .orderBy('createdAt', descending: !isAscending); // Sort by timestamp
          break;
        case 'Lượt bán':
          _productQuery = FirebaseFirestore.instance
              .collection('product')
              .orderBy('saleCount', descending: !isAscending); // Sort by sales count
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Sản phẩm',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        // actions: [
        //   Icon(
        //     Icons.search,
        //     color: Colors.white,
        //   ),
        //   Icon(
        //     Icons.shopping_cart,
        //     color: Colors.white,
        //   ),
        // ],
      ),
      body: Column(
        children: [
          // Sort buttons with icons and ascending/descending toggle
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Use spaceBetween to put icons at the ends
              children: [
                // First 3 icons on the left side
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _sortProducts('Giá', _isAscending);
                        setState(() {
                          _selectedSortBy = 'Giá';
                        });
                      },
                      icon: Icon(
                        Icons.attach_money,
                        color: _selectedSortBy == 'Giá' ? Colors.green : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _sortProducts('Thời gian', _isAscending);
                        setState(() {
                          _selectedSortBy = 'Thời gian';
                        });
                      },
                      icon: Icon(
                        Icons.access_time,
                        color: _selectedSortBy == 'Thời gian' ? Colors.green : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _sortProducts('Lượt bán', _isAscending);
                        setState(() {
                          _selectedSortBy = 'Lượt bán';
                        });
                      },
                      icon: Icon(
                        Icons.shopping_cart,
                        color: _selectedSortBy == 'Lượt bán' ? Colors.green : Colors.black,
                      ),
                    ),
                  ],
                ),
                // Spacer to push the next two icons to the right
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isAscending = true;
                        });
                        _sortProducts(_selectedSortBy, true);
                      },
                      icon: Icon(
                        Icons.arrow_upward,
                        color: _isAscending ? Colors.green : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isAscending = false;
                        });
                        _sortProducts(_selectedSortBy, false);
                      },
                      icon: Icon(
                        Icons.arrow_downward,
                        color: !_isAscending ? Colors.green : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Display the products as a grid
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _productQuery.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 cards per row
                    childAspectRatio: 0.8, // Adjust this value for height/width ratio
                    crossAxisSpacing: 8.0, // Space between cards horizontally
                    mainAxisSpacing: 8.0, // Space between cards vertically
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => ProductCard(
                    snap: snapshot.data!.docs[index].data() as Map<String, dynamic>,
                    productId: snapshot.data!.docs[index].id,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
