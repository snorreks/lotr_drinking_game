import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/base_view_model.dart';

class SummaryDialogViewModel extends BaseNotifierViewModel {
  SummaryDialogViewModel(this._ref);

  final Ref _ref;

  int _currentPage = 0;

  int get currentPage => _currentPage;

  void changePage(int newPage) {
    _currentPage = newPage;
    notifyListeners();
  }
}

final ChangeNotifierProvider<SummaryDialogViewModel>
    summaryDialogViewModelProvider =
    ChangeNotifierProvider<SummaryDialogViewModel>(
        (ChangeNotifierProviderRef<SummaryDialogViewModel> ref) =>
            SummaryDialogViewModel(ref));
