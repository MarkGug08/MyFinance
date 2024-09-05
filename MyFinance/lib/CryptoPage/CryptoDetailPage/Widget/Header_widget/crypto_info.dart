import 'package:flutter/material.dart';

Widget CryptoInfo({
  required String name,
  required String symbol,
  required double currentValue,
  required double percentChange,
}) {
  final changeSymbol = percentChange >= 0 ? '+' : '';
  final changeColor = percentChange >= 0 ? Colors.green : Colors.red;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              SizedBox(height: 4.0),
              Text(
                symbol,
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${currentValue.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                '${changeSymbol}${percentChange.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: changeColor,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
