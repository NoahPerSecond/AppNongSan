import 'package:appnongsan/screens/cart_screen.dart';
import 'package:appnongsan/utils/utils.dart';
import 'package:appnongsan/widgets/product_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _cartItemCount = 0;
  Future<int> getCartItemCount() async {
  User? user = FirebaseAuth.instance.currentUser;
  int totalQuantity = 0;
  int countItem = 0;
  if (user != null) {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Access the 'cart' array
      List<dynamic> cartItems = userDoc['cart'] ?? [];
      countItem = cartItems.length;
      // Sum the quantities
      for (var item in cartItems) {
        totalQuantity += (item['quantity'] as int);
      }
    } catch (e) {
      print('Error getting cart quantity: $e');
    }
  }

  return countItem;
}


  Future<void> _loadCartItemCount() async {
    int itemCount = await getCartItemCount();
    setState(() {
      _cartItemCount = itemCount;
    });
  }

  void listenToCartChanges() {
  User? user = FirebaseAuth.instance.currentUser;
  int countItem = 0;
  FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .snapshots()
      .listen((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          int totalQuantity = 0;
          List<dynamic> cartItems = snapshot['cart'] ?? [];
          countItem = cartItems.length;
          // for (var item in cartItems) {
          //   totalQuantity += (item['quantity'] as int);
          // }

          setState(() {
            _cartItemCount = countItem;
          });
        }
      });
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCartItemCount();
    listenToCartChanges();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _searchHistory = [];
    final List<String> imgSliderList = [
      'assets/slider1.png',
      'assets/slider2.jpg',
      'assets/slider3.jpg'
    ];

    // Lấy lịch sử tìm kiếm từ SharedPreferences
    _loadSearchHistory() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _searchHistory = prefs.getStringList('searchHistory') ?? [];
      });
    }

    // Lưu lịch sử tìm kiếm vào SharedPreferences
    _saveSearchHistory(String query) async {
      if (query.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          _searchHistory.add(query);
          prefs.setStringList('searchHistory', _searchHistory);
        });
      }
    }

    

    final GlobalKey<ScaffoldState> scaffoldKey =
        GlobalKeyManager().getScaffoldKey;

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40), // Độ cong của góc dưới AppBar
          ),
        ),
        leading: IconButton(
            onPressed: () => scaffoldKey.currentState!.openDrawer(),
            icon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 40,
            )),
        title: Text(
          'LOGO',
          style: TextStyle(
              color: Colors.white, fontSize: 44, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              // Badge to show number of items in cart
              if (_cartItemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            CarouselSlider(
              items: imgSliderList
                  .map((item) => Container(
                        width: MediaQuery.of(context)
                            .size
                            .width, // Chiều rộng bằng chiều rộng màn hình
                        height: 200, // Chiều cao cố định của mỗi item
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0), // Bo góc
                          image: DecorationImage(
                            image: AssetImage(item),
                            fit: BoxFit.fill, // Đảm bảo ảnh phủ đầy container
                          ),
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true, // Tự động di chuyển
                // enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.9,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                'assets/apple.png',
                                color: Colors.white,
                                width: 40,
                                height: 40,
                              ))),
                      Text('Trái cây'),
                    ],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                'assets/broccoli.png',
                                color: Colors.white,
                                width: 40,
                                height: 40,
                              ))),
                      Text('Rau củ'),
                      SizedBox(
                        width: 16,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                'assets/wheat.png',
                                color: Colors.white,
                                width: 40,
                                height: 40,
                              ))),
                      Text('Gạo'),
                      SizedBox(
                        width: 16,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey, // Màu của đường kẻ
              thickness: 0.2, // Độ dày của đường kẻ
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sản phẩm bán chạy'),
                  Text('Xem thêm'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: SingleChildScrollView(
                child: Container(
                  height: 230,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('product')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => ProductCard(
                                snap: snapshot.data!.docs[index].data(),
                                productId: snapshot.data!.docs[index].id));
                      }),
                ),
              ),
            ),
            Divider(
              color: Colors.grey, // Màu của đường kẻ
              thickness: 0.2, // Độ dày của đường kẻ
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sản phẩm mới về'),
                  Text('Xem thêm'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: SingleChildScrollView(
                child: Container(
                  height: 230,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('product')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => ProductCard(
                                  snap: snapshot.data!.docs[index].data(),
                                  productId: snapshot.data!.docs[index].id,
                                ));
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
