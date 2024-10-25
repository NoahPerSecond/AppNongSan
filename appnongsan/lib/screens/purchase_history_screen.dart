import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lịch Sử Mua Hàng"),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 12), // Adjust font size to fit more text
            tabs: [
              Tab(child: Text("Chờ\nxác nhận", textAlign: TextAlign.center)),
              Tab(child: Text("Đang\nGiao", textAlign: TextAlign.center)),
              Tab(child: Text("Hoàn\nThành", textAlign: TextAlign.center)),
              Tab(child: Text("Đã\nHủy", textAlign: TextAlign.center)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderList(userId: userId, orderStatus: "Chờ xác nhận"),
            OrderList(userId: userId, orderStatus: "Đang giao"),
            OrderList(userId: userId, orderStatus: "Hoàn thành"),
            OrderList(userId: userId, orderStatus: "Đã hủy"),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final String userId;
  final String orderStatus;

  const OrderList({required this.userId, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where('orderStatus', isEqualTo: orderStatus)
          .orderBy('timestamp', descending: true)
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

            return InkWell(
              onTap: () {
                // Only allow cancellation for "Chờ xác nhận" orders
                if (orderStatus == "Chờ xác nhận") {
                  _showCancelDialog(context, orders[index].id); // Pass the order ID
                }
              },
              child: Card(
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
              ),
            );
          },
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hủy đơn hàng'),
          content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Không'),
            ),
            TextButton(
              onPressed: () {
                _cancelOrder(context, orderId); // Cancel the order
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Hủy đơn'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelOrder(BuildContext context, String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'orderStatus': 'Đã hủy'});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đơn hàng đã được hủy.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
    }
  }
}
