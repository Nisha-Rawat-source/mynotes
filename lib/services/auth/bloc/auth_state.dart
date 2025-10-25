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
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'please wait a moment',
  });
}

/*super() means that the child class is calling the constructor of its parent 
class (in this case, AuthState). */

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

/*with is used to add extra features or behavior to a class without inheritance.
It allows a class to use another class’s methods or properties — this is called a mixin.
with is used to include the code from another class (called a mixin) into your current class. 
extends AuthState → means this class is a child of AuthState.
with EquatableMixin → means it also borrows features from EquatableMixin.*/

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          /*left side is parent class authstate and right side is subclass AuthStateLoggedOut*/

          isLoading: isLoading,
          loadingText: loadingText,
        );

  /*we need equality here which we are using through equatable we need equality
here because this class can produce instances which have diff meaning
for eg: exception=null with isloading :true(if cant login produce exception),
exception=something with isloading :false exception=null with isloading :true 
(if cant login produce diff state) so we need to differentiate these states*/

  @override
  List<Object?> get props => [exception, isLoading];
}

/*/* 
🔹 Explanation for revision:

- 'isLoading' variable is declared only once in the parent class (AuthState).
- All child classes (like AuthStateLoggedIn, AuthStateLoggedOut, etc.)
  share and use the SAME 'isLoading' variable from the parent — not a new one.
- In the child constructor, we pass 'isLoading' to the parent using 'super(isLoading: isLoading)'.
  This means we’re just giving the value to the parent’s variable, not creating a new one.
- When an object is created:
    1️⃣ Parent constructor (AuthState) runs first → sets 'isLoading'.
    2️⃣ Then child constructor runs → sets its own extra variables.
- This helps all states have a common 'isLoading' property,
  so UI or Bloc can easily check 'state.isLoading' for any state type.
*/
 */
