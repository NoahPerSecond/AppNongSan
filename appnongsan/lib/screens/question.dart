import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  // Danh sách các mục FAQ với nội dung cụ thể
  final List<Item> _data = [
    Item(
      headerValue: 'Cách thức mua hàng như thế nào?',
      expandedValue: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
    Item(
      headerValue: 'Cách thức mua hàng như thế nào?',
      expandedValue: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
    Item(
      headerValue: 'Cách thức mua hàng như thế nào?',
      expandedValue: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
    Item(
      headerValue: 'Cách thức mua hàng như thế nào?',
      expandedValue: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
    Item(
      headerValue: 'Cách thức mua hàng như thế nào?',
      expandedValue: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),
    Item(
      headerValue: 'Cách thức mua hàng như thế nào?',
      expandedValue: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    ),

    // Thêm các mục khác nếu cần
  ];

  final ScrollController _scrollController = ScrollController(); // Tạo ScrollController để cuộn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), // Giảm kích cỡ mũi tên back
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Câu hỏi thường gặp',
          style: TextStyle(fontSize: 20, color: Colors.white), // Tăng kích cỡ chữ tiêu đề
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        toolbarHeight: 80, // Tăng kích cỡ AppBar
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Sử dụng ScrollController
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      elevation: 1, // Tạo hiệu ứng nổi
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !_data[index].isExpanded; // Thay đổi trạng thái
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                item.headerValue,
                style: TextStyle(
                  color: Colors.orange, // Chuyển sang màu cam
                  fontSize: 14, // Kích cỡ chữ cho câu hỏi
                ),
              ),
            );
          },
          body: ListTile(
            title: Text(
              item.expandedValue, // Sử dụng giá trị đã định nghĩa cho nội dung mở rộng
              style: TextStyle(
                color: Colors.black,
                fontSize: 10, // Giảm kích cỡ chữ cho phần nội dung mở rộng
              ),
            ),
          ),
          isExpanded: item.isExpanded,
          canTapOnHeader: true, // Cho phép nhấn vào tiêu đề để mở rộng
        );
      }).toList(),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}