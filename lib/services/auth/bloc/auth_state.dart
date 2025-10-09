import 'package:equatable/equatable.dart';
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

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

/*with is used to add extra features or behavior to a class without inheritance.
It allows a class to use another class’s methods or properties — this is called a mixin.
with is used to include the code from another class (called a mixin) into your current class. 
extends AuthState → means this class is a child of AuthState.
with EquatableMixin → means it also borrows features from EquatableMixin.*/

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });

  /*we need equality here which we are using through equatable we need equality
here because this class can produce instances which have diff meaning
for eg: exception=null with isloading :true(if cant login produce exception),
exception=something with isloading :false exception=null with isloading :true 
(if cant login produce diff state) so we need to differentiate these states*/

  @override
  List<Object?> get props => [exception, isLoading];
}
