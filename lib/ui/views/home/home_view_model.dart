import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../models/fellowship.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/preferences_service.dart';

class HomeViewModel extends ChangeNotifier implements BaseViewModel {
  HomeViewModel(this._ref);

  final Ref _ref;
  Character? get character => _ref.read(preferencesService).character;

  Stream<bool> get showCharacterSelectStream => _ref
      .read(fellowshipService)
      .characterStream
      .map((Character? character) => character == null);

  Stream<Fellowship?> get fellowshipStream =>
      _ref.read(fellowshipService).fellowshipStream;

  Future<void> incrementDrink() async {
    await _ref.read(fellowshipService).incrementDrink();
  }

  @override
  void dispose() {
    // implement your dispose logic here
    super.dispose();
  }

  @override
  void logError(String message, error, [StackTrace? stackTrace]) {
    //TODO: implement logError
  }

  @override
  void logInfo(String message) {
    // TODO: implement logInfo
  }

  @override
  void logWTF(String message, [error, StackTrace? stackTrace]) {
    // TODO: implement logWTF
  }

  @override
  void logWarning(String message, [error, StackTrace? stackTrace]) {
    // TODO: implement logWarning
  }

  @override
  // TODO: implement modelTitle
  String get modelTitle => throw UnimplementedError();
}

final AutoDisposeProvider<HomeViewModel> homeViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<HomeViewModel> ref) {
  final HomeViewModel viewModel = HomeViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
