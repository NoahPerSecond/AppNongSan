import 'package:appnongsan/widgets/product_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imgSliderList = [
      'assets/slider1.png',
      'assets/slider2.jpg',
      'assets/slider3.jpg'
    ];
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40), // Độ cong của góc dưới AppBar
          ),
        ),
        leading: Icon(
          Icons.menu,
          color: Colors.white,
          size: 40,
        ),
        title: Text(
          'LOGO',
          style: TextStyle(
              color: Colors.white, fontSize: 44, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 40,
              ))
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
      body: Column(
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
                        radius: 25,
                        backgroundColor: Colors.green,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.food_bank),
                        )),
                    Text('Trái cây'),
                  ],
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  children: [
                    CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.green,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.food_bank),
                        )),
                    Text('Rau'),
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
                        radius: 25,
                        backgroundColor: Colors.green,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.food_bank),
                        )),
                    Text('Củ'),
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
            thickness: 0.1, // Độ dày của đường kẻ
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sản phẩm bán chạy'),
                Text('Xem thêm'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                ProductCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
