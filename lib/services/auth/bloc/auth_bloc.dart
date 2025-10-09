import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /*we are taking auth provider becase our authservice is doing the same whcih is our bussinesslogic
  -super(const AuthStateLoading()) alway have initial state in this code our initial state is AuthStateLoading
  */
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    /*event is the instance of the event class that triggered this handler.
    In your case, AuthEventInitiatize() */

    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createuser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });

    on<AuthEventInitiatize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;

      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ),
      );

      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.login(
          email: email,
          password: password,
        );

        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );

          emit(const AuthStateNeedsVerification());
        } else {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(user));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
  }
}



/*
BLoC Components & Concepts Cheat Sheet:

1. BlocProvider:
   -BlocProvider is a widget that provides a BLoC instance to its child widgets and
    automatically handles its lifecycle.if we use bloc directly there is various cons so use provider

2. BlocBuilder:
   -Rebuilds the UI automatically whenever the BLoC emits a new state.
   

3. BlocListener:
   - Listens for state changes but does NOT rebuild the UI.
   - Useful for showing one-time effects like dialogs, snackbars, or navigation.
   - Runs a listener function when the state changes.

4. BlocConsumer:
   - Combines BlocBuilder and BlocListener in a single widget.
   - Allows you to both rebuild UI (builder) and perform side effects (listener) in response to state changes.
   - Useful when you want UI updates and side effects together.

5. context.read<BLoC>():
   - Accesses a BLoC instance without listening to its state.
   - Used for sending events to the BLoC (context.read<Bloc>().add(Event)).
   - Does NOT trigger UI rebuild when the state changes.

6. context.watch<BLoC>():
   - Accesses a BLoC instance AND listens for its state changes.
   - UI automatically rebuilds whenever the BLoC emits a new state.
   - Useful when you want the widget to react to state changes.

7. add(Event):
   - Sends an event to the BLoC.
   - Triggers the BLoC to run the corresponding logic and emit a new state.
   - Example: AuthEventLogIn, AuthEventLogOut.

8. emit(State):
   - Sends a new state from the BLoC to the UI.
   - Any BlocBuilder or BlocConsumer listening to this BLoC will rebuild accordingly.
   - Represents the “current condition” of the app/UI.
*/

