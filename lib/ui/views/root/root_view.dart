import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'root_view_model.dart';

class RootView extends ConsumerWidget {
  /// Builds the "shell" for the app by building a Scaffold with a
  /// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
  /// Constructs an [RootView].
  const RootView({
    required this.child,
    super.key,
  });

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RootViewModel viewModel = ref.watch(rootViewModel);

    return Scaffold(
      appBar: AppBar(title: const Text('LOTR Drinking Game')),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'A Screen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'B Screen',
          ),
        ],
        currentIndex: viewModel.currentIndex,
        onTap: (int index) => viewModel.onItemTapped(index),
      ),
    );
  }
}
