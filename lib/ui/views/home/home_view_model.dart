import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock/wakelock.dart';

import '../../../common/base_view_model.dart';
import '../../../constants/characters.dart';
import '../../../constants/conversions.dart';
import '../../../models/fellowship.dart';
import '../../../models/fellowship_member.dart';
import '../../../services/api/fellowship_service.dart';
import '../../../services/app/application_service.dart';
import '../../../services/app/dialog_service.dart';
import '../../../services/app/preferences_service.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._ref);

  final Ref _ref;
  Character? get character => _ref.read(preferencesService).character;

  Stream<Fellowship?> get fellowshipStream =>
      _ref.read(fellowshipService).fellowshipStream;

  Stream<bool> get zenModeEnabledStream =>
      _ref.read(applicationService).zenModeEnabledStream;

  Future<void> incrementDrink() async {
    await _ref.read(fellowshipService).incrementDrink();

    _ref.read(dialogService).showNotification(
          const NotificationRequest(message: '+1 drink!'),
        );
  }

  Future<void> downTheHatch(FellowshipMember member) async {
    final int currentDrinksAmount = member.drinksAmount;
    final int moreDrinksAmount = amountOfSipsUntilNextUnit(currentDrinksAmount);
    await _ref.read(fellowshipService).incrementDrink(amount: moreDrinksAmount);

    _ref.read(dialogService).showNotification(
          NotificationRequest(message: 'Drank $moreDrinksAmount drinks!'),
        );
  }

  Future<void> incrementSaves() async {
    await _ref.read(fellowshipService).incrementSaves();
    _ref.read(dialogService).showNotification(
          const NotificationRequest(message: 'Skipped 1 sip!'),
        );
  }

  void showCalloutDialog() {
    _ref.read(dialogService).showCalloutDialog(null);
  }

  void wakeyBaky() {
    Wakelock.enable();
  }

  void sleepyDeepy() {
    Wakelock.disable();
  }

  @override
  void dispose() {
    super.dispose();
    sleepyDeepy();
  }
}

final AutoDisposeProvider<HomeViewModel> homeViewModel =
    Provider.autoDispose((AutoDisposeProviderRef<HomeViewModel> ref) {
  final HomeViewModel viewModel = HomeViewModel(ref);
  ref.onDispose(viewModel.dispose);
  return viewModel;
});
