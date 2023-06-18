part of './login_view.dart';

class _LoginMobile extends StatelessWidget {
  const _LoginMobile(this.viewModel);
  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 32.0),
              const Text(
                'LOTR Drinking Game',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              getLogo(),
              const SizedBox(height: 32.0),
              const Text(
                'Join Session',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              // add a divider here that says "or"
              const Divider(),

              const SizedBox(height: 16.0),
              StreamBuilder<String>(
                stream: viewModel.pinCode,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return TextField(
                    onChanged: viewModel.changePinCode,
                    decoration: InputDecoration(
                      hintText: 'Enter pin code',
                      errorText: snapshot.error as String?,
                    ),
                    controller: viewModel.pinCodeController,
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Button(
                text: 'Join',
                onPressed: viewModel.submitJoin,
                loadingStream: viewModel.loadingStream,
              ),
              const SizedBox(height: 32.0),
              const Text(
                'Create Session',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              StreamBuilder<String>(
                stream: viewModel.sessionName,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return TextField(
                    onChanged: viewModel.changeSessionName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter session name',
                      errorText: snapshot.error as String?,
                    ),
                    controller: viewModel.sessionNameController,
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Button(
                text: 'Create',
                onPressed: viewModel.submitCreate,
                loadingStream: viewModel.loadingStream,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
