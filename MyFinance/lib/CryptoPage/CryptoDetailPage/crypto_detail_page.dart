import 'dart:async';
import 'package:flutter/material.dart';
import '../../../Models/Crypto.dart';
import 'Widget/ContentWidget/content_page.dart';
import 'Widget/HeaderWidget/header_page.dart';


class CryptoDetailPage extends StatefulWidget {
  final Crypto crypto;

  const CryptoDetailPage({super.key, required this.crypto});

  @override
  _CryptoDetailPageState createState() => _CryptoDetailPageState();
}

class _CryptoDetailPageState extends State<CryptoDetailPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(context, widget.crypto),
          buildContent(widget.crypto),
        ],
      ),
      ),
    );
  }
}
