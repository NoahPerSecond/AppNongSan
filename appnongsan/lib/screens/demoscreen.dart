import 'package:flutter/material.dart';
import 'signup_in.dart';
import 'notification.dart';
import 'notification1.dart';
import 'voucher.dart';



class MainForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('9:27'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationForm()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Demo User'),
            accountEmail: Text('demo@example.com'),
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginSignupPage()),
                );
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/Sign.jpeg'),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Trang chủ'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Sản phẩm'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VoucherForm()), // Điều hướng đến VoucherPage
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Danh mục'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Notification1()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Yêu thích'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chat'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Thông báo'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationForm()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Cài đặt'),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Version 0.0.0.1\nCopyright © Demo 2021',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
