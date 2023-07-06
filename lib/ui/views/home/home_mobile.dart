part of './home_view.dart';

class _HomeMobile extends StatelessWidget {
  const _HomeMobile(this.viewModel);
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            _DefaultView(viewModel),
            _ZenView(viewModel),
          ],
        ),
      )),
    );
  }
}
