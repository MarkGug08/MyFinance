import 'package:flutter/material.dart';

Widget Background(){
  return Container(
    decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/Assets/Sfondo.webp'),
          fit: BoxFit.cover
        )
    ),
  );
}