import 'package:flutter/material.dart';

Widget searchbar(searchController){
  return TextField(
    controller: searchController,
    decoration: InputDecoration(
      hintText: 'Search...',
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Color(0xFFFFFFFF),
      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
    ),
    onChanged: (value) {

    },
  );

}