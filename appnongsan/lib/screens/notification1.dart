import 'package:flutter/material.dart';

class Notification1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), // Giảm kích cỡ mũi tên back
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Chi tiết thông báo',
          style: TextStyle(fontSize: 20, color: Colors.white), // Tăng kích cỡ chữ tiêu đề
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        toolbarHeight: 80, // Tăng kích cỡ AppBar
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Đặt ảnh nằm ngay dưới AppBar
          Image.network(
            'assets/images/Sale.jpeg',
            width: double.infinity, // Chiều rộng bằng với chiều rộng của màn hình
            fit: BoxFit.contain, // Đảm bảo hiển thị toàn bộ ảnh
          ),
          SizedBox(height: 20), // Khoảng cách giữa ảnh và phần nội dung
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Giảm giá tưng bừng Khuyến mại vô cùng hấp dẫn lên đến 49%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '18 Thg12, 2021',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent porta suscipit dignissim. Curabitur fringilla, enim non ultrices finibus, sapien velit maximus ligula, sed viverra leo velit vitae odio. Quisque auctor interdum luctus. Curabitur non commodo nisl, et ullamcorper libero',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent porta suscipit dignissim. Curabitur fringilla, enim non ultrices finibus, sapien velit maximus ligula, sed viverra leo velit vitae odio. Quisque auctor interdum luctus. Curabitur non commodo nisl, et ullamcorper libero',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent porta suscipit dignissim. Curabitur fringilla, enim non ultrices finibus, sapien velit maximus ligula, sed viverra leo velit vitae odio. Quisque auctor interdum luctus. Curabitur non commodo nisl, et ullamcorper libero',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
