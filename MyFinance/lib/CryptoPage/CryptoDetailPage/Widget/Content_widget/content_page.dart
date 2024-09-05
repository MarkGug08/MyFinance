import 'package:flutter/material.dart';
import 'package:myfinance/CryptoPage/CryptoDetailPage/Widget/Content_widget/crypto_chart.dart';
import 'package:myfinance/CryptoPage/CryptoDetailPage/Widget/Content_widget/price_card.dart';
import 'package:myfinance/Models/Crypto.dart';

import '../../../../Widget/line_chart.dart';

Widget buildContent(Crypto crypto) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chart',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.0),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: CryptoLineChartWidget(crypto: crypto),
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PriceCard(
              title: 'Highest Price',
              price: crypto.high24h,
              priceColor: Colors.green,
            ),
            SizedBox(width: 8),
            PriceCard(
              title: 'Lowest Price',
              price: crypto.low24h,
              priceColor: Colors.red,
            ),
          ],
        ),
      ],
    ),
  );
}