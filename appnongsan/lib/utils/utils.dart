import 'package:flutter/material.dart';

showSnackBar(String content, BuildContext context)
{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
class GlobalKeyManager {
  static final GlobalKeyManager _instance = GlobalKeyManager._internal();
  factory GlobalKeyManager() => _instance;

  GlobalKeyManager._internal();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get getScaffoldKey => scaffoldKey;
}

