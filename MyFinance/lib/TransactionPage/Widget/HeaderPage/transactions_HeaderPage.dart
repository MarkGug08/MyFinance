import 'package:flutter/material.dart';

PreferredSizeWidget TransactionsHeaderpage(BuildContext context, {required VoidCallback onToggleForm}) {
  return AppBar(
    backgroundColor: const Color(0xFFFAFAFA),
    centerTitle: true,
    title: const Text('Statistics'),
    actions: [
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: onToggleForm,
      ),
    ],
  );
}
