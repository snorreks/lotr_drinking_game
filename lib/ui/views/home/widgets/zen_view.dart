part of '../home_view.dart';

class _ZenView extends StatelessWidget {
  const _ZenView(this.viewModel);
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel.wakeyBaky();
    return Scaffold(
      appBar: AppBar(
        title: Text('Zen Mode'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          viewModel.incrementDrink();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.local_drink),
                label: const Text(
                  'Drink',
                  style: TextStyle(fontSize: 48),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  textStyle: const TextStyle(fontSize: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  viewModel.incrementDrink();
                },
              ),
              SizedBox(
                  height: 20), // provides some space between the two buttons
              ElevatedButton.icon(
                icon: const Icon(Icons.skip_next),
                label: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 24),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  viewModel.incrementSaves();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
