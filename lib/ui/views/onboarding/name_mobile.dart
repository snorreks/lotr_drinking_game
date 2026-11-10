part of 'name_view.dart';

class _NameMobile extends StatelessWidget {
  const _NameMobile(this.viewModel);

  final OnboardingViewModel viewModel;

  void _continue(BuildContext context) {
    if (!viewModel.validateName()) {
      return;
    }
    context.go(Location.onboardingCharacter.value);
  }

  Future<void> _leaveFellowship(BuildContext context) async {
    final bool success = await viewModel.leaveFellowship();
    if (success && context.mounted) {
      context.go(Location.login.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 1,
      title: 'What should we call you?',
      subtitle: 'This is the name the rest of the fellowship will see.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: viewModel.nameController,
            autofocus: true,
            maxLength: 30,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            onChanged: viewModel.onNameChanged,
            onSubmitted: (String value) => _continue(context),
            decoration: InputDecoration(
              labelText: 'Your name',
              hintText: 'Enter your name',
              errorText: viewModel.nameError,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Button(
            text: 'Continue',
            onPressed:
                viewModel.canContinueFromName ? () => _continue(context) : null,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _leaveFellowship(context),
            child: const Text('Joined the wrong fellowship? Leave it'),
          ),
        ],
      ),
    );
  }
}
