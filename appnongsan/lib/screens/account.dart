import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appnongsan/screens/mainscreen.dart';
import 'question.dart';
import 'info.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
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
              SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/User.jpeg'),
              ),
              SizedBox(height: 6),
              Text(
                'NGUYỄN TUYẾT MAI',
                style: TextStyle(
                  fontSize: 16,
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
          padding: EdgeInsets.only(top: 60),
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              minVerticalPadding: 0,
              dense: true,
              leading: Icon(Icons.account_circle, size: 20),
              title: GestureDetector(
                onTap: () {
                  // Điều hướng đến form AccountInfoScreen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AccountInfoScreen(),
                    ),
                  );
                },
                child: Text(
                  'Thông tin tài khoản',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ),
            ),
            Divider(color: Colors.green, thickness: 1),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              minVerticalPadding: 0,
              dense: true,
              leading: Icon(Icons.policy, size: 20),
              title: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FAQPage(),
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
                      FaIcon(FontAwesomeIcons.google, size: 22), // Use correct icon
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
