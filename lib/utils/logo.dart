import 'package:flutter/material.dart';

Image getLogoWithText({double size = 40}) => Image.asset(
      'assets/icons/logo/logo-title.png',
      height: size,
    );

Hero getLogo({double size = 125}) => Hero(
      tag: 'televindu-logo',
      child: Image.asset(
        'assets/icons/logo/logo.png',
        width: size,
        height: size,
      ),
    );
