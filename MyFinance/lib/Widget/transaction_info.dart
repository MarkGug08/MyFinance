import 'package:flutter/material.dart';

Widget TransactionInfo({
  required String title,
  required double currentValue,
  required DateTime time,
  required Color color,
}) {
  final changeColor = currentValue >= 0 ? Colors.green : Colors.red;

  String formattedTime =
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  return Column(
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
                  title,
                  style: TextStyle(fontSize: 16.0, color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Text(
                  '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.year} $formattedTime',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),


          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '\$${currentValue.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: changeColor,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Icon(
                    currentValue >= 0
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: 16.0,
                    color: changeColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
