import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(
      FirebaseAuthProvider()); //here all the values is beging passed to firebase auth provider

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

  @override
  Future<void> initialize() => provider.initialize();
}

/* authprovider This is like a blueprint for authentication providers.

It doesn’t provide the real code — it only defines what methods any 

authentication provider must have. */

/*FirebaseAuthProvider promises to implement all methods in AuthProvider.

So anywhere Dart expects an AuthProvider, you can pass a FirebaseAuthProvider

 object. */

 /* provider is declared as AuthProvider

But the actual object in memory is FirebaseAuthProvider.

This is polymorphism → one interface, many implementations. */

/*so method in authservice is returning the method of firebaseauthprovider */