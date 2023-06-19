part of './home_view.dart';

class _HomeMobile extends StatelessWidget {
  const _HomeMobile(this.viewModel);
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.incrementDrink,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<Fellowship?>(
              stream: viewModel.fellowshipStream,
              builder:
                  (BuildContext context, AsyncSnapshot<Fellowship?> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final Fellowship fellowship = snapshot.data!;
                final Character character = viewModel.character!;
                final FellowshipMember? member = fellowship.members[character];
                final String fellowshipName = fellowship.name;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                          text: 'Fellowship of ',
                          style: const TextStyle(fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(
                                text: fellowshipName,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ]),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/characters/${viewModel.character!.value}.png',
                            fit: BoxFit.contain,
                            height: 200,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(viewModel.character!.displayName),
                                  subtitle: Text('${member?.drinks} drinks'),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('PIN: ${fellowship.pin}'),
                                  ),
                                  subtitle: ElevatedButton(
                                    onPressed: () {
                                      Clipboard.setData(
                                          ClipboardData(text: fellowship.pin));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'PIN copied to clipboard')),
                                      );
                                    },
                                    child: const Text('Copy PIN'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Your rules:\n',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: character.rules[0],
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal)),
                          ]),
                    ),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await viewModel.signOut();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
