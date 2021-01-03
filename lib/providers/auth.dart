import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserCredential _cred;

  Future<void> authenticate(String email, password) async {
    try {
      _cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (err) {
      throw err.toString();
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _cred = null;

    notifyListeners();
  }

  Future<void> register(String email, password) async {
    try {
      _cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (err) {
      throw err.toString();
    }

    final User user = _cred.user;
    assert(user != null);
    assert(user.uid != null);
    assert(user.email != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    notifyListeners();
  }

  User get user => _cred.user;
  bool get isAuthenticated => _cred != null;
}
