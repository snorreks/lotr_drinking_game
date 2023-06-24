import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/router_service.dart';
import '../../themes.dart';

class RootViewModel extends BaseViewModel {
  RootViewModel(this._ref);
  final Ref _ref;
  final ChangeNotifierProvider<ThemeProvider> themeProvider =
      ChangeNotifierProvider((_) => ThemeProvider());

  int get currentIndex {
    final String location = _ref.read(routerService).router.location;
    if (location.startsWith(Location.leaderBoard.value)) {
      return 1;
    }
    if (location.startsWith(Location.rules.value)) {
      return 2;
    }
    return 0;
  }

  Future<void> onItemTapped(int index) {
    switch (index) {
      case 0:
        return _ref.read(routerService).go(Location.home);
      case 1:
        return _ref.read(routerService).go(Location.leaderBoard);
      case 2:
        return _ref.read(routerService).go(Location.rules);
      default:
        throw Exception('onItemTapped: unknown index $index');
    }
  }

  Future<void> signOut() async {
    await _ref.read(fellowshipService).leaveFellowship();
    _ref.read(routerService).go(Location.login);
  }

  void changeTheme() {
    _ref.read(themeProvider).toggleTheme();
  }

  Stream<Character?> get characterStream =>
      _ref.read(fellowshipService).characterStream;
}

final AutoDisposeProvider<RootViewModel> rootViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<RootViewModel> ref) {
  final RootViewModel viewModel = RootViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
