import 'package:flutter/material.dart';

class NotificationForm extends StatefulWidget {
  @override
  _NotificationFormState createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Thông báo',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: 50, // Chiều cao cho TabBar
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), // Bo tròn để tạo hình oval
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _onTabSelected(0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0 ? Colors.green : Colors.transparent,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(30), left: Radius.circular(30)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Sản phẩm',
                        style: TextStyle(
                          color: _selectedIndex == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _onTabSelected(1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1 ? Colors.green : Colors.transparent,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(30), left: Radius.circular(30)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Khuyến mãi',
                        style: TextStyle(
                          color: _selectedIndex == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedIndex == 0 ? NotificationList() : PromotionList(),
          ),
        ],
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {'order': '13452378PO', 'message': 'của bạn đã giao cho đơn vị vận chuyển nhấn để xem chi tiết', 'date': '15:30 06/09/2021'},
    {'order': '13452379PO', 'message': 'của bạn đã giao cho đơn vị vận chuyển nhấn để xem chi tiết', 'date': '15:05 09/12/2021'},
    {'order': '13452378PO', 'message': 'của bạn đã giao cho đơn vị vận chuyển nhấn để xem chi tiết', 'date': '15:30 06/09/2021'},
    {'order': '13452379PO', 'message': 'của bạn đã giao cho đơn vị vận chuyển nhấn để xem chi tiết', 'date': '15:05 09/12/2021'},
    {'order': '13452378PO', 'message': 'của bạn đã giao cho đơn vị vận chuyển nhấn để xem chi tiết', 'date': '15:30 06/09/2021'},
    {'order': '13452379PO', 'message': 'của bạn đã giao cho đơn vị vận chuyển nhấn để xem chi tiết', 'date': '15:05 09/12/2021'},
    {'order': '13452378PO', 'message': 'của bạn đã giao cho đơn vị vận chuyển nhấn để xem chi tiết', 'date': '15:30 06/09/2021'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Đơn hàng ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: notifications[index]['order']!,
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' ${notifications[index]['message']}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Text(notifications[index]['date']!, style: TextStyle(color: Colors.grey)),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}

class PromotionList extends StatelessWidget {
  final List<Map<String, String>> promotions = [
    {'title': 'Đừng bỏ lỡ nông sản mùa hè cực hot.', 'message': 'Hàng mới về. Click để xem ngay.', 'time': '15:30 06/09/2021'},
    {'title': 'Đừng bỏ lỡ nông sản mùa hè cực hot.', 'message': 'Hàng mới về. Click để xem ngay.', 'time': '15:30 06/09/2021'},
    {'title': 'Đừng bỏ lỡ nông sản mùa hè cực hot.', 'message': 'Hàng mới về. Click để xem ngay.', 'time': '15:30 06/09/2021'},
    {'title': 'Đừng bỏ lỡ nông sản mùa hè cực hot.', 'message': 'Hàng mới về. Click để xem ngay.', 'time': '15:30 06/09/2021'},
    {'title': 'Đừng bỏ lỡ nông sản mùa hè cực hot.', 'message': 'Hàng mới về. Click để xem ngay.', 'time': '15:30 06/09/2021'},
    {'title': 'Đừng bỏ lỡ nông sản mùa hè cực hot.', 'message': 'Hàng mới về. Click để xem ngay.', 'time': '15:30 06/09/2021'},
    {'title': 'Đừng bỏ lỡ nông sản mùa hè cực hot.', 'message': 'Hàng mới về. Click để xem ngay.', 'time': '15:30 06/09/2021'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: promotions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                promotions[index]['title']!,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                promotions[index]['message']!,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                promotions[index]['time']!,
                style: TextStyle(color: Colors.grey),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
