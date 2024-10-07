import 'package:flutter/material.dart';
import 'package:myfinance/Controller/transaction_controller.dart';
import 'package:myfinance/HomePage/Widget/HeaderContent/Widget/Modal_menu.dart';
import 'package:myfinance/Models/User.dart';

import 'Widget/Balance.dart';

class HeaderWidget extends StatelessWidget {
  final UserApp user;
  TransactionController controller = TransactionController();

  HeaderWidget({required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.grey[850]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bentornato, User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.white, size: 28),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (BuildContext context) {
                        return ModalMenu(user);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          balanceWidget(controller, user),
        ],
      ),
    );
  }
}
