import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({super.key, required this.currentIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFFAFAFA),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money_outlined),
          label: 'Transaction'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Market',
        ),

      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      onTap: onItemTapped,
    );
  }
}
