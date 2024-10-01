import 'package:flutter/material.dart';

PreferredSizeWidget TransactionsHeaderpage(BuildContext context, {required VoidCallback onToggleForm}) {
  return AppBar(
    centerTitle: true,
    title: Text('Statistics'),
    actions: [
      IconButton(
        icon: Icon(Icons.add),
        onPressed: onToggleForm,
      ),
    ],
  );
}
