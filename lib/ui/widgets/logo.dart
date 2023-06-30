import 'package:flutter/material.dart';

enum LogoType { title, square }

class Logo extends StatelessWidget {
  const Logo({this.type = LogoType.square, this.size, super.key});

  final LogoType type;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final String assetName =
        type == LogoType.title ? 'logo-title.png' : 'logo.png';
    final double height = size ?? (type == LogoType.title ? 55 : 100);

    return Hero(
      tag: type,
      child: Image.asset(
        'assets/images/logo/$assetName',
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
