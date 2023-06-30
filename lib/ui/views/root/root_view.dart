import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/characters.dart';
import '../../../models/fellowship.dart';
import '../../../models/fellowship_member.dart';
import '../../widgets/avatar.dart';
import '../../widgets/button.dart';
import '../character/character_view.dart';
import 'root_view_model.dart';
import 'widgets/logout.dart';

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

    return StreamBuilder<bool>(
      stream: viewModel.showCharacterSelectStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return const CharacterView();
        }
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    // Disable ListView's padding to avoid issues with Column
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      StreamBuilder<FellowshipMember?>(
                          stream: viewModel.memberStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<FellowshipMember?> snapshot) {
                            if (!snapshot.hasData || snapshot.data == null) {
                              return Button(
                                  text: 'LOG ME OUT',
                                  onPressed: () {
                                    viewModel.signOut();
                                  });
                            }

                            try {
                              final FellowshipMember member = snapshot.data!;
                              final Character character = member.character;
                              return Column(children: [
                                UserAccountsDrawerHeader(
                                  accountName: Text(member.name),
                                  accountEmail: Text(character.displayName),
                                  currentAccountPicture: Avatar(
                                    character,
                                    circle: true,
                                  ),
                                ),
                                _themeSwitcher(viewModel),
                              ]);
                            } catch (e) {
                              return Button(
                                  text: 'LOG ME OUT',
                                  onPressed: () {
                                    viewModel.signOut();
                                  });
                            }
                          }),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    _pinCode(viewModel),
                    const SizedBox(height: 20),
                    const Divider(),
                    const LogoutTile(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _themeSwitcher(RootViewModel viewModel) {
    return StreamBuilder<ThemeMode>(
      stream: viewModel.themeStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeMode> snapshot) {
        final ThemeMode selectedThemeMode = snapshot.data ?? ThemeMode.system;

        return ListTile(
          leading: const Text('Theme'),
          title: DropdownButton<ThemeMode>(
            value: selectedThemeMode,
            onChanged: (ThemeMode? newValue) {
              viewModel.changeTheme(newValue ?? ThemeMode.system);
            },
            items: const <DropdownMenuItem<ThemeMode>>[
              DropdownMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.auto_awesome),
                    SizedBox(width: 10),
                    Text('System'),
                  ],
                ),
              ),
              DropdownMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.dark_mode),
                    SizedBox(width: 10),
                    Text('Dark Mode'),
                  ],
                ),
              ),
              DropdownMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.light_mode),
                    SizedBox(width: 10),
                    Text('Light Mode'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pinCode(RootViewModel viewModel) {
    return StreamBuilder<Fellowship?>(
      stream: viewModel.fellowshipStream,
      builder: (BuildContext context, AsyncSnapshot<Fellowship?> snapshot) {
        if (!snapshot.hasData && snapshot.data == null) {
          return Container();
        }
        final Fellowship selectedThemeMode = snapshot.data!;
        final String pinCode = selectedThemeMode.pin;

        return ListTile(
          title: Align(
            alignment: Alignment.centerRight,
            child: Text('PIN: $pinCode'),
          ),
          subtitle: ElevatedButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: pinCode),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PIN copied to clipboard')),
              );
            },
            child: const Text('Copy PIN'),
          ),
        );
      },
    );
  }
}
