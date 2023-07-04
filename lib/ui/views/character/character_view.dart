library character_view;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../constants/characters.dart';
import '../../../models/fellowship.dart';
import '../../widgets/avatar.dart';
import '../../widgets/logo.dart';
import 'character_view_model.dart';

part 'character_mobile.dart';

class CharacterView extends ConsumerWidget {
  const CharacterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CharacterViewModel viewModel = ref.watch(homeViewModel);

    return _CharacterMobile(viewModel);
  }
}
