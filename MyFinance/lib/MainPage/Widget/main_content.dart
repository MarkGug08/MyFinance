import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import 'package:myfinance/TransactionPage/transaction_page.dart';
import '../../CryptoPage/CryptoHomePage/crypto_home_page.dart';
import '../../HomePage/home_page.dart';
import '../../Models/User.dart';

class MainContent extends StatelessWidget {
  final int selectedIndex;
  UserApp user;
  TransactionController controller = TransactionController();

  late final List<Widget> pages;

  MainContent({required this.selectedIndex, required this.user, required this.controller}) {
    pages = <Widget>[
      HomePage(user: user, controller: controller),
      TransactionPage(user: user, controller: controller),
      MarketPage(user: user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return pages[selectedIndex];
  }
}
