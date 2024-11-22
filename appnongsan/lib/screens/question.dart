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
      expandedValue: 'Để mua hàng trên ứng dụng của chúng tôi, bạn chỉ cần chọn sản phẩm mong muốn, thêm vào giỏ hàng, và thực hiện thanh toán qua các phương thức có sẵn. Sau khi thanh toán thành công, sản phẩm sẽ được giao đến địa chỉ mà bạn đã cung cấp.',
    ),

    Item(
      headerValue: 'Sản phẩm có đảm bảo chất lượng không?',
      expandedValue: 'Chúng tôi cam kết chỉ cung cấp sản phẩm nông sản tươi sạch, được kiểm tra chất lượng nghiêm ngặt trước khi giao đến tay người tiêu dùng. Mọi sản phẩm đều có nguồn gốc rõ ràng và được chứng nhận an toàn vệ sinh thực phẩm.',
    ),

    Item(
      headerValue: 'Chính sách đổi trả hàng như thế nào?',
      expandedValue: 'Chúng tôi chấp nhận đổi trả trong vòng 24 giờ kể từ ngày nhận hàng nếu sản phẩm bị hư hỏng hoặc không đúng với mô tả. Bạn chỉ cần liên hệ với bộ phận hỗ trợ khách hàng và chúng tôi sẽ hướng dẫn bạn quy trình đổi trả.',
    ),

    Item(
      headerValue: 'Làm sao để liên hệ với bộ phận hỗ trợ khách hàng?',
      expandedValue: 'Bạn có thể liên hệ với bộ phận hỗ trợ khách hàng qua số điện thoại có trong mục "Liên hệ" trên ứng dụng. Chúng tôi luôn sẵn sàng hỗ trợ bạn giải quyết các vấn đề liên quan đến đơn hàng hoặc sản phẩm.',
    ),

    Item(
      headerValue: 'Thời gian giao hàng là bao lâu?',
      expandedValue: 'Thời gian giao hàng sẽ tùy thuộc vào vị trí của bạn. Thông thường, đơn hàng sẽ được giao trong vòng 2-4 ngày làm việc. Chúng tôi luôn nỗ lực giao hàng nhanh chóng và đúng hạn.',
    ),

    Item(
      headerValue: 'Có thể thay đổi địa chỉ giao hàng sau khi đặt đơn không?',
      expandedValue: 'Nếu bạn cần thay đổi địa chỉ giao hàng, vui lòng liên hệ với bộ phận hỗ trợ khách hàng ngay sau khi đặt đơn. Chúng tôi sẽ cố gắng cập nhật thông tin của bạn trước khi đơn hàng được xử lý.',
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