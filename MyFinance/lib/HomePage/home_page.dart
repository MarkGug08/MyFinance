import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {

              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to MyFinance',
            ),
            SizedBox(height: 20),
            Text(
              'Here you can manage your finances, check your balance, and much more.',
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Go to Profile'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
