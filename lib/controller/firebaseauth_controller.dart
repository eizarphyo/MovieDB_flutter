import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie/controller/firebase_auth_exception_handler.dart';

final _auth = FirebaseAuth.instance;
late AuthStatus _status;

class FirebaseAuthController {
  Future<AuthStatus> login(String email, String password) async {
    try {
      final UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _status = AuthStatus.success;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptiongHandler.handleException(e);
    } catch (err) {
      print(err);
      _status = AuthStatus.unknown;
    }
    return _status;
  }

  Future<AuthStatus> register(String email, String password) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // print(userCred);

      _auth.currentUser!.updateDisplayName(_auth.currentUser!.uid);
      _status = AuthStatus.success;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptiongHandler.handleException(e);
    } catch (e) {
      print(e);
      _status = AuthStatus.unknown;
    }
    return _status;
  }

  Future<AuthStatus> resetPassword(String email) async {
    _status = AuthStatus.success;
    await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.success)
        .catchError((e) => _status = AuthExceptiongHandler.handleException(e));
    return _status;
  }

  Future<AuthStatus> changePassword(
      String currentPassword, String newPassword) async {
    final user = _auth.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);

    try {
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      _status = AuthStatus.success;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptiongHandler.handleException(e);
    } catch (e) {
      _status = AuthStatus.unknown;
    }

    // user.reauthenticateWithCredential(cred).then((value) {
    //   user
    //       .updatePassword(newPassword)
    //       .then((value) => _status = AuthStatus.success)
    //       .catchError(
    //           (e) => _status = AuthExceptiongHandler.handleException(e));
    //   _status = AuthStatus.success;
    // }).catchError((e) => _status = AuthExceptiongHandler.handleException(e));

    return _status;
  }
}
