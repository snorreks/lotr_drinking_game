part of login_view;

class _LoginMobile extends StatelessWidget {
  const _LoginMobile(this.viewModel);
  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                getLogo(),
                const SizedBox(height: 50.0),
                _loginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Button(
      text: 'Login',
      onPressed: viewModel.submit,
      loadingStream: viewModel.loadingStream,
    );
  }
}
