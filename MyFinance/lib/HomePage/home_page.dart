import 'package:flutter/material.dart';
import 'Widget/ContentWidget/content_page.dart';
import 'Widget/HeaderContent/header_page.dart';



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(context),
          buildContent(context),
        ],
      ),
    );
  }

}
