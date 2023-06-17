// Validators
import 'dart:async';

final StreamTransformer<String, String> validateEmail =
    StreamTransformer<String, String>.fromHandlers(
        handleData: (String email, EventSink<String> sink) {
  if (email.contains('@')) {
    sink.add(email);
  } else {
    sink.addError('Enter a valid email');
  }
});

final StreamTransformer<String, String> validatePassword =
    StreamTransformer<String, String>.fromHandlers(
        handleData: (String password, EventSink<String> sink) {
  if (password.length > 4) {
    sink.add(password);
  } else {
    sink.addError('Password length should be greater than 4 chars.');
  }
});

final StreamTransformer<String, String> validatePinCode =
    StreamTransformer<String, String>.fromHandlers(
  handleData: (String pinCode, EventSink<String> sink) {
    if (isValidPinCode(pinCode)) {
      sink.add(pinCode);
    } else {
      sink.addError('Invalid pin code');
    }
  },
);

final StreamTransformer<String, String> validateSessionName =
    StreamTransformer<String, String>.fromHandlers(
  handleData: (String sessionName, EventSink<String> sink) {
    if (isValidSessionName(sessionName)) {
      sink.add(sessionName);
    } else {
      sink.addError('Invalid session name');
    }
  },
);

bool isValidPinCode(String pinCode) {
  return pinCode.isNotEmpty;
}

bool isValidSessionName(String sessionName) {
  return sessionName.isNotEmpty && sessionName.length <= 50;
}
