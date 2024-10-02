import 'package:appnongsan/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late PageController pageController;
  int page = 0;

  void onPageChange(int pageNum) {
    setState(() {
      page = pageNum;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKeyManager().getScaffoldKey;
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green, // Màu nền cho DrawerHeader
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Column(
              children: [
                _createDrawerItem(
                  icon: Icons.home,
                  text: 'Trang chủ',
                  onTap: () {
                    Navigator.pop(context); // Đóng drawer khi chọn
                  },
                ),
                _customDivider(),
                _createDrawerItem(
                  icon: Icons.category,
                  text: 'Danh mục',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _customDivider(),
                _createDrawerItem(
                  icon: Icons.shopping_cart,
                  text: 'Sản phẩm',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _customDivider(),
                _createDrawerItem(
                  icon: Icons.favorite,
                  text: 'Yêu thích',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _customDivider(),
                _createDrawerItem(
                  icon: Icons.notifications,
                  text: 'Thông báo',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _customDivider(),
                _createDrawerItem(
                  icon: Icons.settings,
                  text: 'Cài đặt',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: PageView(
        onPageChanged: onPageChange,
        controller: pageController,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Colors.white, // Màu biểu tượng khi được chọn
        inactiveColor: Colors.white70, // Màu biểu tượng khi không được chọn
        backgroundColor: Colors.green,
        onTap: navigationTapped,
        items: [
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Icon(
                page == 0 ? Icons.home : Icons.home_outlined,
                key: ValueKey(page == 0),
                size: page == 0 ? 28 : 24,
                color: page == 0 ? Colors.white : Colors.white70, // Cùng một màu với các mục khác
              ),
            ),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Icon(
                page == 1 ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                key: ValueKey(page == 1),
                size: page == 1 ? 28 : 24,
                color: page == 1 ? Colors.white : Colors.white70,
              ),
            ),
            label: 'Sản phẩm',
          ),
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Icon(
                page == 2 ? Icons.favorite : Icons.favorite_outline,
                key: ValueKey(page == 2),
                size: page == 2 ? 28 : 24,
                color: page == 2 ? Colors.white : Colors.white70,
              ),
            ),
            label: 'Yêu thích',
          ),
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Icon(
                page == 3 ? Icons.person : Icons.person_outline,
                key: ValueKey(page == 3),
                size: page == 3 ? 28 : 24,
                color: page == 3 ? Colors.white : Colors.white70,
              ),
            ),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}

Widget _createDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
      onTap: onTap,
    );
  }

    Widget _customDivider() {
    return Divider(
      color: Colors.black,
      thickness: 0.4,
      height: 1, // Chiều cao của divider, ảnh hưởng đến khoảng cách giữa các item
      // indent: 16, // Khoảng cách từ đầu danh sách
      // endIndent: 16, // Khoảng cách từ cuối danh sách
    );
  }
