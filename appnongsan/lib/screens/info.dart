import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AccountInfoScreen extends StatefulWidget {
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool _shouldBlink = false;
  String _name = "Nguyễn Tuyết Mai";
  String _phone = "0123456789";
  String _email = "nguyentuyetmail123@gmail.com";
  String _dob = "01/01/1999";

  void _showUpdateDialog(BuildContext context, String title, String currentValue, Function(String) onUpdate) {
    TextEditingController _controller = TextEditingController(text: currentValue);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Nhập ${title.toLowerCase()}',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  isDense: true,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Cập nhật', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    onUpdate(_controller.text);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker(BuildContext context) {
    List<String> dobParts = _dob.split('/');
    int _day = int.parse(dobParts[0]);
    int _month = int.parse(dobParts[1]);
    int _year = int.parse(dobParts[2]);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Chọn ngày sinh',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 30,
                      onSelectedItemChanged: (value) {
                        _day = value + 1;
                      },
                      children: List<Widget>.generate(31, (index) {
                        return Center(child: Text('${index + 1}'));
                      }),
                      scrollController: FixedExtentScrollController(initialItem: _day - 1),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 30,
                      onSelectedItemChanged: (value) {
                        _month = value + 1;
                      },
                      children: List<Widget>.generate(12, (index) {
                        return Center(child: Text('${index + 1}'));
                      }),
                      scrollController: FixedExtentScrollController(initialItem: _month - 1),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 30,
                      onSelectedItemChanged: (value) {
                        _year = value + 1; // Giả sử từ 1900 đến 2024
                      },
                      children: List<Widget>.generate(2024, (index) {
                        return Center(child: Text('${index + 1}'));
                      }),
                      scrollController: FixedExtentScrollController(initialItem: _year - 1),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Cập nhật', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      // Định dạng lại ngày, tháng để có 2 chữ số
                      String formattedDay = _day.toString().padLeft(2, '0');
                      String formattedMonth = _month.toString().padLeft(2, '0');
                      _dob = '$formattedDay/$formattedMonth/$_year';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _blinkText() {
    setState(() {
      _shouldBlink = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _shouldBlink = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Thông tin tài khoản',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 60),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/User.jpeg'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _blinkText(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => _blinkText(),
                          child: Text(
                            'Họ và tên',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showUpdateDialog(context, 'Họ và Tên', _name, (newValue) {
                              setState(() {
                                _name = newValue;
                              });
                            }),
                            child: AnimatedOpacity(
                              opacity: _shouldBlink ? 0.3 : 1.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 30),
                                child: Text(
                                  _name,
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.green),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _blinkText(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => _blinkText(),
                          child: Text(
                            'Số điện thoại',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showUpdateDialog(context, 'Số điện thoại', _phone, (newValue) {
                              setState(() {
                                _phone = newValue;
                              });
                            }),
                            child: AnimatedOpacity(
                              opacity: _shouldBlink ? 0.3 : 1.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 50),
                                child: Text(
                                  _phone,
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.green),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _blinkText(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => _blinkText(),
                          child: Text(
                            'Email',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showUpdateDialog(context, 'Email', _email, (newValue) {
                              setState(() {
                                _email = newValue;
                              });
                            }),
                            child: AnimatedOpacity(
                              opacity: _shouldBlink ? 0.3 : 1.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 30),
                                child: Text(
                                  _email,
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.green),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _blinkText(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => _blinkText(),
                          child: Text(
                            'Ngày sinh',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showDatePicker(context),
                            child: AnimatedOpacity(
                              opacity: _shouldBlink ? 0.3 : 1.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 30),
                                child: Text(
                                  _dob,
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.green),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
