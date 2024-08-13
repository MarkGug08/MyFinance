import 'package:flutter/material.dart';

Widget Background(){  //background for the authentication screen
  return Container(
    decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/Assets/Sfondo.webp'),  //background
          fit: BoxFit.cover,
        )
    ),
  );
}