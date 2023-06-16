import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/base_service.dart';
import '../../models/user.dart' as model;

/// AuthService handles the authentication of the app, by communicating with Firebase
///
/// The class will notify listeners when the auth is changed.
abstract class AuthServiceModel {
  model.User? get user;

  bool get isSignedIn;

  Future<void> signIn({
    required String email,
    required String password,
  });

  /// Signs the user out the app.
  Future<void> signOut();

  Future<model.UserStatus?> getUserStatus();
}

class AuthService extends BaseService implements AuthServiceModel {
  AuthService(this._ref, this._firebaseAuth);
  final Ref _ref;

  final FirebaseAuth _firebaseAuth;

  model.User? _user;

  @override
  bool get isSignedIn => user != null;

  @override
  model.User? get user => _user;

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      logError('signOut', e);
      return false;
    }
  }

  @override
  Future<model.UserStatus?> getUserStatus() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user == null) {
        return null;
      }
      final IdTokenResult token = await user.getIdTokenResult();
      _user = model.User.fromJson(
        user.uid,
        user.email!,
        user.displayName,
        token.claims,
      );
      return _user!.userStatus;
    } catch (e) {
      logError('_onAuthStateChanged', e);
      return null;
    }
  }
}

final Provider<AuthServiceModel> authService = Provider<AuthServiceModel>(
  (ProviderRef<AuthServiceModel> ref) => AuthService(
    ref,
    FirebaseAuth.instance,
  ),
);
