import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../common/base_view_model.dart';
import '../../../models/fellowship.dart';
import '../../../models/movie_summary_stats.dart';
import '../../../services/api/fellowship_service.dart';

class SummaryDialogViewModel extends BaseNotifierViewModel {
  SummaryDialogViewModel(this._ref, this.endedMovie) {
    final Fellowship? snapshot = _ref.read(fellowshipService).fellowship;
    if (snapshot != null) {
      stats = MovieSummaryStats.fromFellowship(snapshot);
      nextMovie = snapshot.currentMovie;
    }
  }

  final Ref _ref;

  /// The movie that just ended, shown in the title.
  final String endedMovie;

  MovieSummaryStats? stats;
  String? nextMovie;

  final PageController pageController = PageController();
  int currentPage = 0;

  int get pageCount => 4;

  void changePage(int newPage) {
    currentPage = newPage;
    notifyListeners();
  }

  Future<void> goNext() async {
    if (currentPage + 1 >= pageCount) {
      return;
    }
    await pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

final ChangeNotifierProviderFamily<SummaryDialogViewModel, String>
    summaryDialogViewModelProvider = ChangeNotifierProvider.family.autoDispose(
  (Ref ref, String endedMovie) => SummaryDialogViewModel(ref, endedMovie),
);
