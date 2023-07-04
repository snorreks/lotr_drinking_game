import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'loading.dart';
import 'logo.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key, this.showLoading = true});
  final bool showLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Logo(),
            if (showLoading)
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Loading(),
              )
          ],
        ),
      ),
    );
  }
}
