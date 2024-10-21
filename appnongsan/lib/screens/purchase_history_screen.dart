import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch Sử Mua Hàng"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId) // Filter orders by user ID
            .orderBy('timestamp', descending: true) // Order by timestamp
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Chưa có lịch sử mua hàng.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tên sản phẩm: ${orderData['productName'] ?? 'N/A'}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text("Số lượng: ${orderData['quantity'] ?? 0}"),
                      const SizedBox(height: 5),
                      Text("Tổng cộng: ${orderData['totalAmount']?.toStringAsFixed(0) ?? 0} VND"),
                      const SizedBox(height: 5),
                      Text("Người nhận: ${orderData['recipientName'] ?? 'N/A'}"),
                      const SizedBox(height: 5),
                      Text("Địa chỉ: ${orderData['recipientAddress'] ?? 'N/A'}"),
                      const SizedBox(height: 5),
                      Text("Số điện thoại: ${orderData['recipientPhoneNum'] ?? 'N/A'}"),
                      const SizedBox(height: 5),
                      Text("Ngày đặt: ${orderData['timestamp']?.toDate().toString() ?? 'N/A'}"),
                      const SizedBox(height: 5),
                      Text("Trạng thái: ${orderData['orderStatus'] ?? 'N/A'}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
