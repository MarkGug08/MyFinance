import 'package:flutter/material.dart';
import '../Models/User.dart';
import 'Widget/bottom_bar.dart';
import 'Widget/main_content.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final UserApp user = UserApp(Income: 0, Expenses: 0, UserEmail: 'test@deve.com');

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainContent(selectedIndex: _selectedIndex, user: user),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
