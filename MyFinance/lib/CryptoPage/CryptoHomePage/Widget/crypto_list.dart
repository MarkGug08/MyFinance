import 'package:flutter/material.dart';
import '../../../Models/Crypto.dart';

/// Builds a List of crypto items.
Widget cryptolist(List<Crypto> cryptoList) {
  return Container(
    color: Color(0xFFFAFAFA),
    child: ListView.builder(
      itemCount: cryptoList.length,
      itemBuilder: (context, index) {
        var crypto = cryptoList[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crypto.name,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      crypto.symbol,
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Text(
                  '\$${crypto.currentValue.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
