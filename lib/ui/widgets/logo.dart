import 'package:flutter/material.dart';

enum LogoType { title, square }

class Logo extends StatelessWidget {
  const Logo({this.type = LogoType.square, this.size = 100, super.key});

  final LogoType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String assetName =
        type == LogoType.title ? 'logo-title.png' : 'logo.png';
    return Hero(
      tag: type,
      child: Image.asset(
        'assets/images/logo/$assetName',
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
