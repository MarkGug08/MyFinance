import 'package:flutter/material.dart';
import 'Widget/bottom_bar.dart';
import 'Widget/main_content.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainContent(selectedIndex: _selectedIndex), // Using the custom MainContent widget
      bottomNavigationBar: CustomBottomNavigationBar( // Using the custom BottomNavigationBar widget
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
