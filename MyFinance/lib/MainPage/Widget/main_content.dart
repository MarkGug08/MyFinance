import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/TransactionPage/transaction_page.dart';
import '../../CryptoPage/CryptoHomePage/crypto_home_page.dart';
import '../../HomePage/home_page.dart';
import '../../Models/User.dart';

class MainContent extends StatelessWidget {
  final int selectedIndex;
  UserApp user;


  late final List<Widget> pages;

  MainContent({required this.selectedIndex, required this.user}) {
    pages = <Widget>[
      HomePage(user: user),
      TransactionPage(user: user),
      MarketPage(user: user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return pages[selectedIndex];
  }
}
