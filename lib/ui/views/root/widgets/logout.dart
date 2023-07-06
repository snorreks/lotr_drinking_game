import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/fellowship.dart';
import '../../../../models/fellowship_member.dart';
import '../../../widgets/loading.dart';
import '../root_view_model.dart';

class LogoutTile extends ConsumerStatefulWidget {
  const LogoutTile({super.key});

  @override
  _LogoutTileState createState() => _LogoutTileState();
}

class _LogoutTileState extends ConsumerState<LogoutTile> {
  FellowshipMember? selectedMember;

  @override
  Widget build(BuildContext context) {
    final RootViewModel viewModel = ref.watch(rootViewModel);

    return StreamBuilder<FellowshipMember?>(
      stream: viewModel.memberStream,
      builder:
          (BuildContext context, AsyncSnapshot<FellowshipMember?> snapshot) {
        final FellowshipMember? member =
            snapshot.hasData ? snapshot.data : null;

        return ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              //If member isAdmin, prompt change
              if (member != null && member.isAdmin) {
                _showAdminDialog(context, viewModel, member);
              } else {
                viewModel.signOut();
              }
            });
      },
    );
  }

  void _showAdminDialog(BuildContext context, RootViewModel viewModel,
      FellowshipMember currAdmin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<Fellowship?>(
          stream: viewModel.fellowshipStream,
          builder: (BuildContext context, AsyncSnapshot<Fellowship?> snapshot) {
            if (!snapshot.hasData && snapshot.data == null) {
              return const Loading();
            }
            final Fellowship fellowship = snapshot.data!;
            final List<FellowshipMember> members = fellowship.members.values
                .toList(); // Assuming your Fellowship class has a members property

            return AlertDialog(
              title: const Text('Admin change'),
              content: DropdownButton<FellowshipMember>(
                hint: const Text('Select a new admin'),
                value: selectedMember,
                onChanged: (FellowshipMember? newValue) {
                  if (selectedMember != currAdmin) {
                    setState(() {
                      selectedMember = newValue;
                    });
                    // Force the builder to rebuild to reflect new selection
                    Navigator.pop(context);
                    _showAdminDialog(context, viewModel, currAdmin);
                  }
                },
                items: members.map((FellowshipMember member) {
                  return DropdownMenuItem<FellowshipMember>(
                    value: member,
                    child: Text(member.name),
                  );
                }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Make admin'),
                  onPressed: () {
                    if (selectedMember != null) {
                      viewModel.changeAdmin(selectedMember!, currAdmin);
                      Navigator.of(context).pop();
                      viewModel.signOut();
                    }
                  },
                ),
                TextButton(
                  child: const Text('Assign random'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    viewModel.signOut();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
