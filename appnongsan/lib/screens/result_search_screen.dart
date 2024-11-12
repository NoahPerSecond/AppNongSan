import 'package:appnongsan/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResultSearchScreen extends StatefulWidget {
  final String word;

  ResultSearchScreen({required this.word});

  @override
  _ResultSearchScreenState createState() => _ResultSearchScreenState();
}

class _ResultSearchScreenState extends State<ResultSearchScreen> {
  late Future<List<DocumentSnapshot>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = _performFirestoreSearch(widget.word);
  }

  Future<List<DocumentSnapshot>> _performFirestoreSearch(String query) async {
  query = query.trim();
  
  var result = await FirebaseFirestore.instance
      .collection('product')
      .where('name', isGreaterThanOrEqualTo: query)
      .get();
  
  return result.docs;
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Results')),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _searchResults,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No results found'));
            } else {
              var products = snapshot.data!;
              // return ListView.builder(
              //   itemCount: products.length,
              //   itemBuilder: (context, index) {
              //     var product = products[index].data() as Map<String, dynamic>;
              //     return ProductCard(snap: product,productId: product['id'],);
              //   },
              // );
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cards per row
                  childAspectRatio: 0.8, // Adjust this value for height/width ratio
                  crossAxisSpacing: 8.0, // Space between cards horizontally
                  mainAxisSpacing: 8.0, // Space between cards vertically
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index].data() as Map<String, dynamic>;
                  return ProductCard(snap: product,productId: product['id'],);
                }
              );
            }
          },
        ),
      ),
    );
  }
}
