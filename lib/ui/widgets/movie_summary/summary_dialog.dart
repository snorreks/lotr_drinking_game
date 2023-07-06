import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'summary_dialog_model.dart';

class SummaryDialog extends ConsumerWidget {
  const SummaryDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: PageView(
          controller: PageController(),
          onPageChanged: (int page) {
            ref.read(summaryDialogViewModelProvider).changePage(page);
          },
          children: [
            _buildPage(
              context,
              title: 'Movie Finished',
              content: 'The movie is done. The next movie is XYZ.',
            ),
            _buildPage(
              context,
              title: 'Who Drank the Most?',
              content: 'The person who drank the most in this movie is ABC.',
            ),
            _buildPage(
              context,
              title: 'Who Skipped the Most?',
              content: 'The person who used the most skips is DEF.',
            ),
            _buildPage(
              context,
              title: 'Top 3 Players',
              content: 'The top 3 players currently are GHI, JKL, and MNO.',
            ),
            _buildPage(
              context,
              title: 'Attention',
              content: 'Pay attention to your rules, they have changed!',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context,
      {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
