import 'dart:io';

import 'package:appnongsan/models/user_model.dart';
import 'package:appnongsan/resources/firebase_methods.dart';
import 'package:appnongsan/widgets/login_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AccountInfoScreen extends StatefulWidget {
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  XFile? _image;
  final picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;
  bool _shouldBlink = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Chụp ảnh'),
              onTap: () {
                Navigator.of(context).pop(); // Đóng bảng chọn
                _pickImage(ImageSource.camera); // Chụp ảnh từ camera
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Chọn từ thư viện'),
              onTap: () {
                Navigator.of(context).pop(); // Đóng bảng chọn
                _pickImage(ImageSource.gallery); // Chọn ảnh từ thư viện
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    String fileName = Uuid().v4(); // Generate a unique filename
    Reference storageRef =
        FirebaseStorage.instance.ref().child('images/$fileName.jpg');
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> updateUserData(String uid, String name, String phone, String dob,
      String profileUrl, String address) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'username': name,
        'phoneNum': phone,
        'birthDay': dob,
        'profileImg': profileUrl,
        'address': address
      });
      print('User updated successfully');
    } catch (e) {
      print('Failed to update user: $e');
    }
  }

  String _name = "";
  String _phone = "";
  String _email = "";
  String _dob = "";
  String _profileUrl = '';
  String _address = '';
  Future<void> getProfileImg() async {
    String updatedPprofileUrl;
    // if(_image!.path.isEmpty)
    // {
    //   updatedPprofileUrl = '';
    // }
    updatedPprofileUrl = await uploadImageToFirebase(File(_image!.path));
    setState(() {
      _profileUrl = updatedPprofileUrl;
    });
  }

  Future<void> _loadUserData() async {
    // UID của người dùng hiện tại
    UserModel? userLog = await FirebaseMethods().getUserData(user!.uid);

    if (user != null) {
      setState(() {
        _name = userLog!.username!;
        _phone = userLog.phoneNum!;
        _email = userLog.email;
        _dob = userLog.birthDay!;
        _profileUrl = userLog.profileImg!;
        _address = userLog.address!;
      });
    } else {
      print("Không tìm thấy dữ liệu người dùng");
    }
  }

  void _showUpdateDialog(BuildContext context, String title,
      String currentValue, Function(String) onUpdate) {
    TextEditingController _controller =
        TextEditingController(text: currentValue);

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
                  child:
                      Text('Cập nhật', style: TextStyle(color: Colors.white)),
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

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        // Chuyển đổi sang định dạng chuỗi
        _dob = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  void _showBottomSheet() {
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showDatePicker();
                  Navigator.pop(context); // Đóng ModalBottomSheet
                },
                child: Text('Chọn ngày'),
              ),
              SizedBox(height: 20),
              Text(
                _dob ?? 'Chưa chọn ngày',
                style: TextStyle(fontSize: 16),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 60),
                  child: InkWell(
                    onTap: () {
                      _showImagePickerOptions();
                      getProfileImg();
                    },
                    child: (_profileUrl == '')
                        ? CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('assets/User.png'),
                          )
                        : CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(_profileUrl),
                          ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => _blinkText(),
                          child: Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            // onTap: () => _showUpdateDialog(
                            //     context, 'Email', _email, (newValue) {
                            //   setState(() {
                            //     _email = newValue;
                            //   });
                            // }),
                            child: AnimatedOpacity(
                              opacity: _shouldBlink ? 0.3 : 1.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 30),
                                child: Text(
                                  _email,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.green),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: InkWell(
                      onTap: () {
                              _blinkText();
                              _showUpdateDialog(context, 'Họ và tên', _name,
                                  (newValue) {
                                setState(() {
                                  _name = newValue;
                                });
                              });
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Họ và tên',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: _shouldBlink ? 0.3 : 1.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 30),
                                child: Text(
                                  _name,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.green),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: InkWell(
                      onTap: () {
                              _blinkText();
                              _showUpdateDialog(context, 'Số điện thoại', _phone,
                                  (newValue) {
                                setState(() {
                                  _phone = newValue;
                                });
                              });
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Số điện thoại',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: _shouldBlink ? 0.3 : 1.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 30),
                                child: Text(
                                  _phone,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.green),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: InkWell(
                      onTap: () {
                              _blinkText();
                              _showUpdateDialog(context, 'Địa chỉ', _address,
                                  (newValue) {
                                setState(() {
                                  _address = newValue;
                                });
                              });
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Địa chỉ',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: _shouldBlink ? 0.3 : 1.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 30),
                                child: Text(
                                  _address,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.green),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: InkWell(
                      onTap: () {
                              _blinkText();
                              _showDatePicker();
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 20),
                          Text(
                            'Ngày sinh',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: _shouldBlink ? 0.3 : 1.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 30),
                                child: Text(
                                  _dob,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.green),
                ],
              ),
              // Column(
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         _showUpdateDialog(context, 'Họ và Tên', _name,
              //             (newValue) {
              //           setState(() {
              //             _name = newValue;
              //           });
              //         });
              //         _blinkText();
              //       },
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           SizedBox(width: 20),
              //           Text(
              //             'Họ và tên',
              //             style: TextStyle(
              //                 fontSize: 14, fontWeight: FontWeight.bold),
              //           ),
              //           Expanded(
              //             child: GestureDetector(
              //               onTap: () => _showUpdateDialog(
              //                   context, 'Họ và Tên', _name, (newValue) {
              //                 setState(() {
              //                   _name = newValue;
              //                 });
              //               }),
              //               child: AnimatedOpacity(
              //                 opacity: _shouldBlink ? 0.3 : 1.0,
              //                 duration: Duration(milliseconds: 500),
              //                 child: Container(
              //                   alignment: Alignment.centerRight,
              //                   padding: EdgeInsets.only(right: 30),
              //                   child: Text(
              //                     _name,
              //                     style: TextStyle(
              //                         fontSize: 13, color: Colors.grey),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(height: 12),
              //     Divider(color: Colors.green),
              //     SizedBox(height: 12),
              //   ],
              // ),
              // Column(
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         SizedBox(width: 20),
              //         GestureDetector(
              //           onTap: () => _blinkText(),
              //           child: Text(
              //             'Số điện thoại',
              //             style: TextStyle(
              //                 fontSize: 14, fontWeight: FontWeight.bold),
              //           ),
              //         ),
              //         Expanded(
              //           child: GestureDetector(
              //             onTap: () => _showUpdateDialog(
              //                 context, 'Số điện thoại', _phone, (newValue) {
              //               setState(() {
              //                 _phone = newValue;
              //               });
              //             }),
              //             child: AnimatedOpacity(
              //               opacity: _shouldBlink ? 0.3 : 1.0,
              //               duration: Duration(milliseconds: 500),
              //               child: Container(
              //                 alignment: Alignment.centerRight,
              //                 padding: EdgeInsets.only(right: 50),
              //                 child: Text(
              //                   _phone,
              //                   style: TextStyle(
              //                       fontSize: 13, color: Colors.grey),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //     SizedBox(height: 12),
              //     Divider(color: Colors.green),
              //     SizedBox(height: 12),
              //   ],
              // ),
              // GestureDetector(
              //   onTap: () => _blinkText(),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           SizedBox(width: 20),
              //           GestureDetector(
              //             onTap: () => _blinkText(),
              //             child: Text(
              //               'Ngày sinh',
              //               style: TextStyle(
              //                   fontSize: 14, fontWeight: FontWeight.bold),
              //             ),
              //           ),
              //           Expanded(
              //             child: GestureDetector(
              //               onTap: () => _showDatePicker(context),
              //               child: AnimatedOpacity(
              //                 opacity: _shouldBlink ? 0.3 : 1.0,
              //                 duration: Duration(milliseconds: 500),
              //                 child: Container(
              //                   alignment: Alignment.centerRight,
              //                   padding: EdgeInsets.only(right: 30),
              //                   child: Text(
              //                     _dob,
              //                     style: TextStyle(
              //                         fontSize: 13, color: Colors.grey),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 12),
              //       Divider(color: Colors.green),
              //       SizedBox(height: 12),
              //     ],
              //   ),
              // ),
              // GestureDetector(
              //   onTap: () => _blinkText(),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           SizedBox(width: 20),
              //           GestureDetector(
              //             onTap: () => _blinkText(),
              //             child: Text(
              //               'Địa chỉ',
              //               style: TextStyle(
              //                   fontSize: 14, fontWeight: FontWeight.bold),
              //             ),
              //           ),
              //           Expanded(
              //             child: GestureDetector(
              //               onTap: () => _showUpdateDialog(
              //                   context, 'Địa chỉ', _address, (newValue) {
              //                 setState(() {
              //                   _address = newValue;
              //                 });
              //               }),
              //               child: AnimatedOpacity(
              //                 opacity: _shouldBlink ? 0.3 : 1.0,
              //                 duration: Duration(milliseconds: 500),
              //                 child: Container(
              //                   alignment: Alignment.centerRight,
              //                   padding: EdgeInsets.only(right: 30),
              //                   child: Text(
              //                     _address,
              //                     style: TextStyle(
              //                         fontSize: 13, color: Colors.grey),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 12),
              //       Divider(color: Colors.green),
              //       SizedBox(height: 12),
              //     ],
              //   ),
              // ),
              TextButton(
                onPressed: () async {
                  // Xử lý sự kiện khi nút được nhấn
                  await updateUserData(
                      user!.uid, _name, _phone, _dob, _profileUrl, _address);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green, // Màu nền của nút
                  padding: EdgeInsets.symmetric(
                      vertical: 15, horizontal: 30), // Căn chỉnh khoảng cách
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Bo góc nút
                  ),
                  elevation: 5, // Độ bóng khi nhấn
                ),
                child: Text(
                  'Cập nhật thông tin',
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
      ),
    );
  }
}
