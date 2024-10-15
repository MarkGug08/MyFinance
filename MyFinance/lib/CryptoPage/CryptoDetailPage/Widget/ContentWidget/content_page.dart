import 'package:flutter/material.dart';
import 'package:myfinance/Widget/price_card.dart';
import 'package:myfinance/Models/Crypto.dart';

import 'crypto_chart.dart';

Widget buildContent(Crypto crypto) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chart',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: CryptoLineChartWidget(crypto: crypto),
          ),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PriceCard(
              title: 'Highest Price',
              price: crypto.high24h,
              priceColor: Colors.green,
            ),
            const SizedBox(width: 8),
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