part of '../home_view.dart';

class _ZenView extends StatelessWidget {
  const _ZenView(this.viewModel);
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel.wakeyBaky();
    return GestureDetector(
      onTap: () {
        viewModel.incrementDrink();
      },
      child: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.local_drink),
          label: const Text(
            'Drink',
            style: TextStyle(fontSize: 48),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            textStyle: const TextStyle(fontSize: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () {
            viewModel.incrementDrink();
          },
        ),
      ),
    );
  }
}
