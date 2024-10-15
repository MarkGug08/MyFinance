import 'package:flutter/material.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import 'package:myfinance/Models/User.dart';
import 'Widget/ContentWidget/content_page.dart';
import 'Widget/HeaderContent/header_page.dart';

class HomePage extends StatelessWidget {
  final UserApp user;
  final TransactionController controller;

  const HomePage({super.key, required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: FutureBuilder(
        future: controller.getTransaction(user, context),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(user: user, controller: controller),
                buildContent(user: user, controller: controller),
              ],
            );
          }
        },
      ),
    );
  }
}
