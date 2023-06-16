import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/logo.dart';
import 'loading.dart';

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
            getLogo(),
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
