import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appnongsan/screens/demoscreen.dart';
import 'account.dart';
import 'policy.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0), // Tăng chiều cao của AppBar
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tài khoản',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20), // Tăng khoảng cách giữa AppBar và thông tin tài khoản
              GestureDetector(
                onTap: () {
                  // Điều hướng đến ProfilePage khi nhấn vào ảnh đại diện
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/Sign.jpeg'),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'ĐĂNG NHẬP/ĐĂNG KÝ',
                style: TextStyle(
                  fontSize: 16, // Kích thước chữ
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Material(
        child: ListView(
          padding: EdgeInsets.only(top: 60), // Giảm khoảng cách giữa AppBar và nội dung
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // Giảm padding giữa văn bản và các cạnh
              minVerticalPadding: 0, // Xóa padding dọc thêm
              dense: true, // Làm cho ListTile gọn hơn
              leading: Icon(Icons.policy, size: 20),
              title: Text('Thông tin tài khoản', style: TextStyle(fontSize: 13, color: Colors.grey)),
            ),
            Divider(color: Colors.green, thickness: 1), // Giảm độ dày của Divider
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              minVerticalPadding: 0,
              dense: true,
              leading: Icon(Icons.policy, size: 20),
              title: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PolicyScreen(), // Điều hướng tới PolicyScreen
                    ),
                  );
                },
                child: Text('Chính sách', style: TextStyle(fontSize: 13, color: Colors.black)),
              ),
            ),
            Divider(color: Colors.green, thickness: 1),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              minVerticalPadding: 0,
              dense: true,
              leading: Icon(Icons.history, size: 20),
              title: Text('Lịch sử mua hàng', style: TextStyle(fontSize: 13, color: Colors.black)),
            ),
            Divider(color: Colors.green, thickness: 1),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              minVerticalPadding: 0,
              dense: true,
              leading: Icon(Icons.contact_phone, size: 20),
              title: Text('Liên hệ', style: TextStyle(fontSize: 13, color: Colors.black)),
              subtitle: Text('0123456789', style: TextStyle(fontSize: 13, color: Colors.black)),
            ),
            Divider(color: Colors.green, thickness: 1),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      FaIcon(FontAwesomeIcons.facebook, size: 22),
                      Text('Facebook'),
                    ],
                  ),
                  Column(
                    children: [
                      FaIcon(FontAwesomeIcons.google, size: 22),
                      Text('Google'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainForm()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 20),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag, size: 20),
            label: 'Sản phẩm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 20),
            label: 'Yêu thích',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 20),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
