import 'package:flutter/material.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import '../Models/User.dart';
import 'Widget/bottom_bar.dart';
import 'Widget/main_content.dart';


class MainPage extends StatefulWidget {
  UserApp user;
  TransactionController controller = TransactionController();

  MainPage({super.key, required this.user});
  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    widget.controller.getTransaction(widget.user, context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainContent(selectedIndex: _selectedIndex, user: widget.user, controller: widget.controller,),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
