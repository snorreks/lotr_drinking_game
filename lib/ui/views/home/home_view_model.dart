import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../models/fellowship.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/alcohol_calculation_service.dart';
import '../../../services/app/preferences_service.dart';
import '../../../services/app/router_service.dart';

class HomeViewModel extends ChangeNotifier implements BaseViewModel {
  HomeViewModel(this._ref, this._alcoholService);

  final Ref _ref;
  final AlcoholCalculationService _alcoholService;
  double totalUnits = 0;

  Character? get character => _ref.read(preferencesService).character;

  Stream<bool> get showCharacterSelectStream => _ref
      .read(fellowshipService)
      .characterStream
      .map((Character? character) => character == null);

  Stream<Fellowship?> get fellowshipStream =>
      _ref.read(fellowshipService).fellowshipStream;

  Future<void> signOut() async {
    await _ref.read(fellowshipService).leaveFellowship();
    _ref.read(routerService).go(Location.login);
  }

  Future<void> incrementDrink() {
    return _ref.read(fellowshipService).incrementDrink();
  }

  void incrementUnits(double volumeInCl, double abv) {
    totalUnits += _alcoholService.calculateAlcoholUnits(volumeInCl, abv);
    notifyListeners();
  }

  @override
  void dispose() {
    // implement your dispose logic here
    super.dispose();
  }

  @override
  void logError(String message, error, [StackTrace? stackTrace]) {
    // TODO: implement logError
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
  final AlcoholCalculationService alcoholService =
      AlcoholCalculationService(); // you have to provide an instance of AlcoholCalculationService
  final HomeViewModel viewModel = HomeViewModel(ref, alcoholService);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
