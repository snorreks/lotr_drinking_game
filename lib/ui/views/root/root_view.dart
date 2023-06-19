import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/characters.dart';
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
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo/logo-title.png',
          fit: BoxFit.contain,
          height: 60,
        ),
        centerTitle: true,
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered),
            label: 'Leader board',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Rules'),
        ],
        currentIndex: viewModel.currentIndex,
        onTap: (int index) => viewModel.onItemTapped(index),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            StreamBuilder<Character?>(
              stream: viewModel.characterStream,
              builder:
                  (BuildContext context, AsyncSnapshot<Character?> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final Character character = snapshot.data!;
                  return UserAccountsDrawerHeader(
                    accountName: const Text('LOTR Drinking Game'),
                    accountEmail: Text(character.displayName),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        'LG',
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Change Theme'),
              onTap: () {
                // Add your change theme function here
              },
            ),
            const Spacer(), // Pushes the logout button to the bottom
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: viewModel.signOut,
            ),
          ],
        ),
      ),
    );
  }
}
