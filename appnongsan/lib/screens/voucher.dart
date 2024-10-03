import 'package:flutter/material.dart';

class VoucherForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Nhập mã voucher tại đây',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.grey),
                    onPressed: () {
                      // Xử lý khi nhấn vào biểu tượng kính lúp
                      print('Tìm kiếm với mã voucher: '); // Có thể thêm hành động cụ thể
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 80),
            Expanded(
              child: ListView(
                children: [
                  VoucherItem(
                    code: 'MUALANDAU',
                    description: 'Ưu đãi giảm 20%, tối đa 50k cho khách hàng lần đầu mua sắm tại LOGO',
                  ),
                  Divider(color: Colors.green),
                  VoucherItem(
                    code: 'NH050K',
                    description: 'Ưu đãi của voucher NH050K',
                  ),
                  Divider(color: Colors.green),
                  VoucherItem(
                    code: 'Voucher 3',
                    description: 'Ưu đãi của voucher 3',
                  ),
                  Divider(color: Colors.green),
                  VoucherItem(
                    code: 'Voucher 4',
                    description: 'Ưu đãi của voucher 4',
                  ),
                  Divider(color: Colors.green),
                  VoucherItem(
                    code: 'Voucher 5',
                    description: 'Ưu đãi của voucher 5',
                  ),
                  Divider(color: Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherItem extends StatelessWidget {
  final String code;
  final String description;

  VoucherItem({required this.code, required this.description});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        code,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14, // Thay đổi kích thước font chữ cho tiêu đề
          color: Colors.green,
        ),
      ),
      subtitle: Text(
        description,
        style: TextStyle(
          fontSize: 10, // Thay đổi kích thước font chữ cho mô tả
        ),
      ),
      onTap: () {
        // Xử lý khi người dùng nhấn vào một voucher
      },
    );
  }
}
