import 'package:flutter/material.dart';

import '../../CryptoPage/CryptoHomePage/crypto_home_page.dart';
import '../../HomePage/home_page.dart';


class MainContent extends StatelessWidget {
  final int selectedIndex;

  MainContent({required this.selectedIndex});

  static List<Widget> pages = <Widget>[
    HomePage(),
    MarketPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return pages[selectedIndex];
  }
}
