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
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: onPageChange,
        controller: pageController,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: navigationTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: page == 0 ? primaryColor : secondaryColor),
              label: 'Trang chủ'),
          BottomNavigationBarItem(
              icon: Icon(Icons.production_quantity_limits,
                  color: page == 1 ? primaryColor : secondaryColor),
              label: 'Sản phẩm'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite,
                  color: page == 2 ? primaryColor : secondaryColor),
              label: 'Yêu thích'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: page == 3 ? primaryColor : secondaryColor),
              label: 'Tài khoản'),

        ],
      ),
    );
  }
}
