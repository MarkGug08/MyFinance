import 'package:flutter/material.dart';
import 'package:myfinance/Models/Crypto.dart';
import '../../../../Widget/crypto_info.dart';
import 'custom_app_bar.dart';

Widget buildHeader(BuildContext context, Crypto crypto) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        CustomAppBar(context, 'Market'),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          margin: EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: CryptoInfo(
            name: crypto.name,
            symbol: crypto.symbol,
            currentValue: crypto.currentValue,
            percentChange: crypto.percentChange24h,
            color: Colors.white,
            isFavorite: crypto.isFavorite,
          ),
        ),
      ],
    ),
  );
}
