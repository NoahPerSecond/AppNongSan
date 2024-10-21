import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String productId;

  PaymentPage({super.key, required this.productId});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int quantity = 1; // Default quantity
  late double price; // To hold the product price
  String productName = '';

  late TextEditingController recipientNameController;
  late TextEditingController recipientAddressController;
  late TextEditingController recipientPhoneNumController;

  @override
  void initState() {
    super.initState();
    recipientNameController = TextEditingController();
    recipientAddressController = TextEditingController();
    recipientPhoneNumController = TextEditingController();
    fetchUserData();
  }

  @override
  void dispose() {
    recipientNameController.dispose();
    recipientAddressController.dispose();
    recipientPhoneNumController.dispose();
    super.dispose();
  }

  void fetchUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        recipientNameController.text = userData['username'] ?? '';
        recipientAddressController.text = userData['address'] ?? '';
        recipientPhoneNumController.text = userData['phoneNum'] ?? '';
      });
    }
  }
//   void saveOrder() async {
//   String userId = FirebaseAuth.instance.currentUser!.uid;

//   // Get a reference to the product document
//   DocumentReference productRef = FirebaseFirestore.instance.collection('product').doc(widget.productId);

//   FirebaseFirestore.instance.runTransaction((transaction) async {
//     // Get the current stock of the product
//     DocumentSnapshot productSnapshot = await transaction.get(productRef);

//     if (!productSnapshot.exists) {
//       throw Exception("Sản phẩm không tồn tại.");
//     }

//     int currentStock = productSnapshot['stockQuantity'];
//     int newStock = currentStock - quantity;

//     if (newStock < 0) {
//       throw Exception("Số lượng sản phẩm không đủ.");
//     }

//     // Update the product's stock quantity
//     transaction.update(productRef, {'stockQuantity': newStock});

//     // Create an order document
//     await FirebaseFirestore.instance.collection('orders').add({
//       'productId': widget.productId,
//       'userId': userId,
//       'recipientName': recipientNameController.text,
//       'recipientAddress': recipientAddressController.text,
//       'recipientPhoneNum': recipientPhoneNumController.text,
//       'quantity': quantity,
//       'totalAmount': price * quantity,
//       'orderStatus': 'Đang chờ xử lý', // Add order status
//       'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
//     });

//     // Show success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Đặt hàng thành công!")),
//     );
//     Navigator.pop(context); // Go back to the previous screen
//   }).catchError((error) {
//     // Handle any errors
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Lỗi: $error")),
//     );
//   });
// }


  void saveOrder() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Tạo một tài liệu đơn hàng
    await FirebaseFirestore.instance.collection('orders').add({
      'productId': widget.productId,
      'productName': productName, // Thêm tên sản phẩm vào đơn hàng
      'userId': userId,
      'recipientName': recipientNameController.text,
      'recipientAddress': recipientAddressController.text,
      'recipientPhoneNum': recipientPhoneNumController.text,
      'quantity': quantity,
      'totalAmount': price * quantity,
      'orderStatus': 'Đang chờ xử lý', // Trạng thái đơn hàng
      'timestamp': FieldValue.serverTimestamp(), // Thêm thời gian
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đặt hàng thành công!")),
      );
      Navigator.pop(context); // Quay lại màn hình trước
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $error")),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh Toán"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('product')
                .doc(widget.productId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Sản phẩm không tồn tại.'));
              }

              final productData = snapshot.data!.data() as Map<String, dynamic>;
              price = productData['price']?.toDouble() ?? 0.0;
               productName = productData['name'] ?? 'N/A'; // Lưu tên sản phẩm
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thông tin sản phẩm",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Display product image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        productData['imageUrl'],
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Display product details
                  // Product information section

// Display product details
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tên sản phẩm: ${productData['name'] ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 20, // Increased font size
                            fontWeight: FontWeight.bold, // Make the name bold
                            color: Colors.black, // Change text color
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Giá: ${price.toStringAsFixed(0)} VND",
                          style: const TextStyle(
                            fontSize: 18, // Slightly smaller than the name
                            fontWeight:
                                FontWeight.w600, // Semi-bold for the price
                            color:
                                Colors.green, // Use a green color for the price
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Thông tin người nhận",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Display recipient information
                  _buildTextField("Họ và tên", recipientNameController),
                  const SizedBox(height: 10),
                  _buildTextField("Địa chỉ", recipientAddressController),
                  const SizedBox(height: 10),
                  _buildTextField("Số điện thoại", recipientPhoneNumController,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 10),

                  const Text(
                    "Chọn số lượng",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Quantity selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuantityButton(Icons.remove, () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      }),
                      Text('$quantity', style: const TextStyle(fontSize: 24)),
                      _buildQuantityButton(Icons.add, () {
                        setState(() {
                          quantity++;
                        });
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Total amount
                  Text(
                    "Tổng cộng: ${(price * quantity).toStringAsFixed(0)} VND",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Submit button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        saveOrder();
                      
                      },
                      child: const Text("Xác Nhận Thanh Toán"),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      controller: controller,
      keyboardType: keyboardType,
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: 30,
      color: Colors.green,
    );
  }
}
