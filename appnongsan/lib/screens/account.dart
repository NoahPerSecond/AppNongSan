import 'package:appnongsan/models/user_model.dart';
import 'package:appnongsan/resources/auth_methods.dart';
import 'package:appnongsan/resources/firebase_methods.dart';
import 'package:appnongsan/screens/purchase_history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'question.dart';
import 'info.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  String? _name = "";
  String? _email = "";

  String _profileUrl = '';
  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Ensure the user is logged in before trying to fetch data
    if (user != null) {
      try {
        // Fetch user data from your method
        UserModel? userLog = await FirebaseMethods().getUserData(user.uid);

        // Check if the state is still mounted before calling setState
        if (mounted) {
          if (userLog != null) {
            setState(() {
              _name = userLog.username;
              _email = userLog.email;
              _profileUrl = userLog.profileImg!;
            });
          } else {
            print("User data not found.");
          }
        }
      } catch (e) {
        // Handle any errors that may occur
        print('Error loading user data: $e');
      }
    } else {
      print("User not logged in.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

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
              (_profileUrl == '')
                  ? CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/User.png'),
                    )
                  : CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(_profileUrl),
                    ),
              SizedBox(height: 6),
              (_name == '')
                  ? Text(
                      _email!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _name!,
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
                child: Text('Chính sách',
                    style: TextStyle(fontSize: 13, color: Colors.black)),
              ),
            ),
            Divider(color: Colors.green, thickness: 1),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PurchaseHistoryPage()),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                minVerticalPadding: 0,
                dense: true,
                leading: Icon(Icons.history, size: 20),
                title: Text('Lịch sử mua hàng',
                    style: TextStyle(fontSize: 13, color: Colors.black)),
              ),
            ),
            Divider(color: Colors.green, thickness: 1),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              minVerticalPadding: 0,
              dense: true,
              leading: Icon(Icons.contact_phone, size: 20),
              title: Text('Liên hệ',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
              subtitle: Text('0123456789',
                  style: TextStyle(fontSize: 13, color: Colors.black)),
            ),
            Divider(color: Colors.green, thickness: 1),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Column(
                  //   children: [
                  //     FaIcon(FontAwesomeIcons.facebook, size: 22),
                  //     Text('Facebook'),
                  //   ],
                  // ),
                  // Column(
                  //   children: [
                  //     FaIcon(FontAwesomeIcons.google,
                  //         size: 22), // Use correct icon
                  //     Text('Google'),
                  //   ],
                  // ),
                  TextButton(
                    onPressed: () async {
                      // Xử lý sự kiện khi nút được nhấn
                      AuthMethods().signOut(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green, // Màu nền của nút
                      padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30), // Căn chỉnh khoảng cách
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Bo góc nút
                      ),
                      elevation: 5, // Độ bóng khi nhấn
                    ),
                    child: Text(
                      'Đăng xuất',
                      style: TextStyle(
                        fontSize: 16, // Kích thước chữ
                        fontWeight: FontWeight.bold, // Độ dày chữ
                        color: Colors.white, // Màu chữ
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
