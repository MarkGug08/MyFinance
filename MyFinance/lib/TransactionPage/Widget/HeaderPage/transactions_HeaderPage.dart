import 'package:flutter/material.dart';

PreferredSizeWidget TransactionsHeaderpage(BuildContext context, {required VoidCallback onToggleForm}) {
  return AppBar(
    backgroundColor: Color(0xFFFAFAFA),
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
