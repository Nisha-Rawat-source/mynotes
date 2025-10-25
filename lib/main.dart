import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/helpers/loading/loading_screen.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/forgot_password_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
/* there is another way of changing screen which is routes without name where you push
content or widget on the same page instead of pushing and removing the page */

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); //make or initialize with firebase before rendering the ui
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,

      /*bloc provider is creating and managing the instance of bloc here it is 
      creating or giving context the address or access to our bloc which takes
      firebaseAuthProvider as parameter or constructor and these context or bloc 
      provider or context is applicable on its chile homepage
      /*
BlocProvider here is creating and managing the instance of AuthBloc. 
It takes FirebaseAuthProvider as a dependency for AuthBloc. 
BlocProvider makes this AuthBloc accessible to all child widgets 
(e.g., HomePage and its children) through the context, 
so they can read or listen to its states and send events.
*/
 */

//now authbloc is injected in context

      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        //route is a parameter or argumment which takes vale in map formate where key is string and value is function of build context
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //sending bloc a event of AuthEventInitiatize

    /*context is given .read authbloc from context and in that authbloc 
    .add(way of communicating with your bloc) this */
    context.read<AuthBloc>().add(const AuthEventInitiatize());

    /*BlocBuilder building the ui according to the bloc and bloc(BLoC type and state type specified.) 
    state given in the parameter and bulding it for given contect and state */
    return BlocConsumer<AuthBloc, AuthState>(
      //sideeffects

      listener: (context, state) {
        /* BlocConsumer listens to AuthBloc state changes.
   'state' = latest AuthState emitted.
   If state.isLoading → show loading screen.
   Else → hide it.
   Used to control loading UI based on authentication state. */

        if (state.isLoading) {
          LoadingScreen().show(
            context: context,

            //if null the execute right;

            text: state.loadingText ?? 'please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      //it is rebulding its ui again everytime it gets the state
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const EmailVerificationView();
        } else if (state is AuthStateLoggedOut) {
          return LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
