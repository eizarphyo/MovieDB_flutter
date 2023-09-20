import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  success,
  wrongPassword,
  weakPassword,
  emailAlreadyExists,
  invalidEmail,
  userNotFound,
  unknown
}

class AuthExceptiongHandler {
  static AuthStatus handleException(FirebaseAuthException err) {
    AuthStatus status;
    switch (err.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String sendErrorMsg(AuthStatus status) {
    String errMsg;
    switch (status) {
      case AuthStatus.invalidEmail:
        errMsg = "Invalid email";
        break;
      case AuthStatus.weakPassword:
        errMsg = "Password must have at least 6 characters";
        break;
      case AuthStatus.wrongPassword:
        errMsg = "Wrong password";
        break;
      case AuthStatus.emailAlreadyExists:
        errMsg = "Email already in use";
        break;
      case AuthStatus.userNotFound:
        errMsg = "No user found with this email";
        break;
      default:
        errMsg = "An error occurred. Please try again later";
    }
    return errMsg;
  }
}
