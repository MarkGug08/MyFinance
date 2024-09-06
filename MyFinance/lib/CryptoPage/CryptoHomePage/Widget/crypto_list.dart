import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../Models/Crypto.dart';

/// Builds a List of crypto items.
Widget cryptolist(List<Crypto> cryptoList, Function(Crypto) toggleFavorite) {
  return Container(
    color: Color(0xFFFAFAFA),
    child: ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: cryptoList.length,
      itemBuilder: (context, index) {
        var crypto = cryptoList[index];
        Color changeColor = crypto.percentChange24h >= 0 ? Colors.green : Colors.red;
        String changeSymbol = crypto.percentChange24h >= 0 ? '+' : '';

        return Slidable(
          key: ValueKey(crypto.symbol),

          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) {
                  toggleFavorite(crypto);
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.bookmark,
                label: 'Favorite',
                borderRadius: BorderRadius.circular(10.0),
                flex: 1,
              ),
            ],
          ),


          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(10.0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
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
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${crypto.currentValue.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            '${changeSymbol}${crypto.percentChange24h.toStringAsFixed(2)}%',
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
              ),
            ),
          ),
        );
      },
    ),
  );
}
