part of login_view;

class _LoginMobile extends StatelessWidget {
  const _LoginMobile(this.viewModel);
  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            getLogo(),
            StreamBuilder<String>(
              stream: viewModel.email,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: viewModel.changeEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter email',
                    errorText: snapshot.error as String?,
                  ),
                  controller: viewModel.emailController,
                );
              },
            ),
            StreamBuilder<String>(
              stream: viewModel.password,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: viewModel.changePassword,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    errorText: snapshot.error as String?,
                  ),
                  controller: viewModel.passwordController,
                );
              },
            ),
            StreamBuilder<bool>(
              stream: viewModel.isValid,
              builder: (context, snapshot) {
                return Button(
                  text: 'Login',
                  onPressed: snapshot.hasError || !snapshot.hasData
                      ? null
                      : viewModel.submit,
                  loadingStream: viewModel.loadingStream,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
