library login_view;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/logo.dart';
import '../../widgets/button.dart';
import '../../widgets/loading.dart';
import 'login_view_model.dart';

part 'login_mobile.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginViewModel viewModel = ref.watch(loginViewModel);
    return _LoginMobile(viewModel);
  }
}
