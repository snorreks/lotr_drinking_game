part of '../home_view.dart';

class _ZenView extends StatelessWidget {
  const _ZenView(this.viewModel);
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel.wakeyBaky();

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Center(
            child: SizedBox(
              height: screenHeight * 0.6, // Adjust as needed
              width: screenWidth, // Adjust as needed
              child: ElevatedButton.icon(
                icon: const Icon(Icons.local_drink),
                label: const Text(
                  'Drink',
                  style: TextStyle(fontSize: 48),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.1,
                  ),
                  textStyle: const TextStyle(fontSize: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: viewModel.incrementDrink,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              height: screenHeight * 0.3, // Adjust as needed
              width: screenWidth, // Adjust as needed
              child: ElevatedButton.icon(
                icon: const Icon(Icons.skip_next),
                label: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 24),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: viewModel.incrementSaves,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
