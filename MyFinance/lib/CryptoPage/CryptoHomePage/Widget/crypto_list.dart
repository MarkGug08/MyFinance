import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myfinance/Widget/crypto_info.dart';
import '../../../Models/Crypto.dart';
import '../../CryptoDetailPage/crypto_detail_page.dart';

Widget cryptolist(List<Crypto> cryptoList, Function(Crypto) toggleFavorite) {
  return Container(
    child: ListView.builder(
      itemCount: cryptoList.length,
      itemBuilder: (context, index) {
        var crypto = cryptoList[index];

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
                backgroundColor: Colors.white,
                foregroundColor: crypto.isFavorite ? Colors.red : Colors.black,
                icon: crypto.isFavorite ? Icons.bookmark_remove : Icons.bookmark,
                label: crypto.isFavorite ? 'Remove' : 'Favorite',
                borderRadius: BorderRadius.circular(10.0),
                padding: const EdgeInsets.all(1.0),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CryptoDetailPage(crypto: crypto),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey[300]!),
              ),
              padding: const EdgeInsets.all(16.0),
              child: CryptoInfo(
                name: crypto.name,
                symbol: crypto.symbol,
                currentValue: crypto.currentValue,
                percentChange: crypto.percentChange24h,
                color: Colors.black,
                isFavorite: crypto.isFavorite,
              ),
            ),
          ),
        );
      },
    ),
  );
}
