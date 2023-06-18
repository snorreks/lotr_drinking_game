import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../services/app/router_service.dart';

class RootViewModel extends BaseViewModel {
  RootViewModel(this._ref);
  final Ref _ref;

  int get currentIndex {
    final String location = _ref.read(routerService).router.location;
    if (location.startsWith(Location.leaderBoard.value)) {
      return 1;
    }
    return 0;
  }

  Future<void> onItemTapped(int index) {
    switch (index) {
      case 0:
        return _ref.read(routerService).go(Location.home);
      case 1:
        return _ref.read(routerService).go(Location.leaderBoard);
      default:
        throw Exception('onItemTapped: unknown index $index');
    }
  }
}

final AutoDisposeProvider<RootViewModel> rootViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<RootViewModel> ref) {
  final RootViewModel viewModel = RootViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
