import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), // Giảm kích cỡ mũi tên back
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Điều khoản và chính sách',
          style: TextStyle(fontSize: 20, color: Colors.white), // Tăng kích cỡ chữ tiêu đề
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        toolbarHeight: 80, // Tăng kích cỡ AppBar
      ),
      body: SingleChildScrollView(  // Sử dụng SingleChildScrollView để cho phép cuộn
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'LOGO',
                  style: TextStyle(
                    fontSize: 45, // Tăng kích thước font của chữ LOGO
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'I. Điều khoản',
                style: TextStyle(
                  fontSize: 16, // Giảm kích thước của các văn bản còn lại
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                style: TextStyle(fontSize: 12), // Giảm kích thước văn bản mô tả
              ),
              SizedBox(height: 20),
              Text(
                'II. Chính sách',
                style: TextStyle(
                  fontSize: 16, // Giảm kích thước của các văn bản còn lại
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                style: TextStyle(fontSize: 12), // Giảm kích thước văn bản mô tả
              ),
            ],
          ),
        ),
      ),
    );
  }
}
