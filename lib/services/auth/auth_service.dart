import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthService provider;
  const AuthService(this.provider);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> createuser({
    required String email,
    required String password,
  }) =>
      provider.createuser(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
