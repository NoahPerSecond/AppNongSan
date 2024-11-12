import 'package:appnongsan/screens/home_screen.dart';
import 'package:appnongsan/screens/product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationForm extends StatefulWidget {
  @override
  _NotificationFormState createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: Text(
          'Thông báo',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: 50, // Chiều cao cho TabBar
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(30), // Bo tròn để tạo hình oval
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _onTabSelected(0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0
                            ? Colors.green
                            : Colors.transparent,
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(30),
                            left: Radius.circular(30)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Sản phẩm',
                        style: TextStyle(
                          color:
                              _selectedIndex == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _onTabSelected(1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1
                            ? Colors.green
                            : Colors.transparent,
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(30),
                            left: Radius.circular(30)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Khuyến mãi',
                        style: TextStyle(
                          color:
                              _selectedIndex == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedIndex == 0 ? NotificationList() : PromotionList(),
          ),
        ],
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection('orders')
      .where('userId', isEqualTo: currentUserId)
      .orderBy('timestamp', descending: true) // Sắp xếp giảm dần
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Lỗi: ${snapshot.error}'));
    }
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Center(child: Text('Chưa có thông báo đơn hàng.'));
    }

    final orders = snapshot.data!.docs;

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final orderData = orders[index].data() as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Đơn hàng ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: orderData['productName'] ?? 'N/A',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' ${_getOrderStatusMessage(orderData['orderStatus'])}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                orderData['timestamp']?.toDate().toString() ?? '',
                style: TextStyle(color: Colors.grey),
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  },
);

  }

  String _getOrderStatusMessage(String? status) {
    switch (status) {
      case 'Chờ xác nhận':
        return 'đang chờ xác nhận.';
      case 'Đang giao':
        return 'đang được giao.';
      case 'Hoàn thành':
        return 'đã hoàn thành.';
      case 'Đã hủy':
        return 'đã bị hủy.';
      default:
        return 'cập nhật.';
    }
  }
}

class PromotionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('product')
          .where('newPrice', isGreaterThan: 0) // Lọc các sản phẩm có newPrice
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Không có sản phẩm khuyến mãi.'));
        }

        final promotions = snapshot.data!.docs;

        return ListView.builder(
          itemCount: promotions.length,
          itemBuilder: (context, index) {
            final productData = promotions[index].data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị ảnh sản phẩm
                  if (productData['imageUrl'] != null)
                    Image.network(
                      productData['imageUrl'],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 5),
                  
                  // Tên sản phẩm
                  Text(
                    productData['name'] ?? 'Tên sản phẩm',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  
                  // Giá mới và giá cũ
                  Text(
                    'Giá mới: ${productData['newPrice'] != null ? formatCurrency.format(productData['newPrice']) + ' VND' : 'N/A'}',
                    style: TextStyle(color: Colors.green),
                  ),
                  Text(
                    'Giá cũ: ${productData['price'] != null ? formatCurrency.format(productData['price']) + ' VND' : 'N/A'}',
                    style: TextStyle(color: Colors.red, decoration: TextDecoration.lineThrough),
                  ),
                  const SizedBox(height: 5),
                  
                  // Mô tả khuyến mãi
                  Text(
                    'Hàng mới về! Click để xem ngay.',
                    style: TextStyle(color: Colors.black),
                  ),
                  
                  const SizedBox(height: 5),
                  Divider(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '');
}
