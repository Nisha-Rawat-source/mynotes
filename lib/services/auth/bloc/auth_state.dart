import 'package:flutter/cupertino.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';

/* We use abstract class because BLoC takes only one state type.
   Without it, we would need a separate BLoC for every state class.
   By using abstract, we create one common state which is being
   extended by other class while usinng bloc we are saying we are using this 
   type of class further in code */

@immutable
abstract class AuthState {
  const AuthState();
}

/*this is generic loading class if it does not exist the we have to make it separatly
for every state for instance logingin , logingout etc*/

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}

class AuthStateLogoutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogoutFailure(this.exception);
}
