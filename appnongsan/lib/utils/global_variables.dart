import 'package:appnongsan/screens/account.dart';
import 'package:appnongsan/screens/favourite_screen.dart';
import 'package:appnongsan/screens/home_screen.dart';

import 'package:appnongsan/screens/product_screen.dart';
import 'package:appnongsan/screens/profile_screen.dart';
import 'package:flutter/material.dart';
const webScreenSize = 600;
List<Widget> homeScreenItems = [
  HomeScreen(),
  ProductScreen(),
  FavouriteScreen(),
  ProfilePage()

];