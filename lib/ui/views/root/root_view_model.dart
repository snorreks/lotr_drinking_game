import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../models/fellowship.dart';
import '../../../models/fellowship_member.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/application_service.dart';
import '../../../services/app/router_service.dart';

class RootViewModel extends BaseViewModel {
  RootViewModel(this._ref)
      : _themeSubject = BehaviorSubject<ThemeMode>.seeded(
          _ref.read(applicationService).themeMode,
        );
  final Ref _ref;

  final BehaviorSubject<ThemeMode> _themeSubject;

  Stream<bool> get showCharacterSelectStream => _ref
      .read(fellowshipService)
      .characterStream
      .map((Character? character) => character == null);

  Stream<ThemeMode> get themeStream => _themeSubject.stream;

  int get currentIndex {
    final Location location = _ref.read(routerService).location;
    if (location == Location.leaderBoard) {
      return 1;
    }
    if (location == Location.rules) {
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

  Future<void> changeAdmin(
      FellowshipMember newAdmin, FellowshipMember oldAdmin) async {
    await _ref.read(fellowshipService).changeAdmin(newAdmin, oldAdmin);
  }

  void changeTheme(ThemeMode themeMode) {
    _themeSubject.add(themeMode);
    _ref.read(applicationService).changeTheme(themeMode);
  }

  Stream<FellowshipMember?> get memberStream =>
      _ref.read(fellowshipService).memberStream;

  Stream<Fellowship?> get fellowshipStream =>
      _ref.read(fellowshipService).fellowshipStream;
}

final AutoDisposeProvider<RootViewModel> rootViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<RootViewModel> ref) {
  final RootViewModel viewModel = RootViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
