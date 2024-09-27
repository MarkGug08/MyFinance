import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/TransactionPage/transaction_page.dart';
import '../../CryptoPage/CryptoHomePage/crypto_home_page.dart';
import '../../HomePage/home_page.dart';
import '../../Models/User.dart';

class MainContent extends StatelessWidget {
  final int selectedIndex;
  final UserApp user1 = UserApp(Income: 0, Expenses: 0);


  late final List<Widget> pages;

  MainContent({required this.selectedIndex}) {
    pages = <Widget>[
      HomePage(),
      TransactionPage(user: user1),
      MarketPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return pages[selectedIndex];
  }
}
