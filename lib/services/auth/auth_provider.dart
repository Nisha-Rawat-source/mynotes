import 'package:mynotes/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> createuser({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordReset({required toEmail});
}
/*Here’s what happens step by step:

authprovider is just a blueprint how otherclass must have its functionalities

AuthService receives the call.

AuthService sends the request to FirebaseAuthProvider.

FirebaseAuthProvider talks to Firebase.

Result (success/failure) comes back to AuthService.

AuthService returns it to the UI. */
