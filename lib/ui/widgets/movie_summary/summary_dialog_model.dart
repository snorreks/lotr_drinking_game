import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../common/base_view_model.dart';

class SummaryDialogViewModel extends BaseNotifierViewModel {
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
        (Ref ref) => SummaryDialogViewModel());
