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
          Container(
            height: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo/logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(
                            text: 'Fellowship of the ',
                            style: const TextStyle(fontSize: 24),
                            children: <TextSpan>[
                          TextSpan(
                              text: fellowshipName,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold))
                        ])),
                    const SizedBox(height: 16),
                    Text(
                      'Fellowship PIN: ${fellowship.pin}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: fellowship.pin));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Fellowship PIN copied to clipboard')),
                        );
                      },
                      child: const Text('Copy Fellowship PIN'),
                    ),
                    Card(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/characters/${viewModel.character!.value}.png',
                            fit: BoxFit.contain,
                            height: 200,
                          ),
                          ListTile(
                            title: Text(viewModel.character!.displayName),
                            subtitle: Text('Level ${member?.drinks}'),
                          ),
                        ],
                      ),
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
