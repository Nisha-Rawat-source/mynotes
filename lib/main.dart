import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
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
      home: const HomePage(),
      routes: {
        //route is a parameter or argumment which takes vale in map formate where key is string and value is function of build context
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoutes: (context) => const NotesView(),
        verifyEmailRoute: (context) => const EmailVerificationView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(), //future of future builder
      builder: (context, snapshot) {
        //perform this builder after future returns future according to its results future have snapshot -> state of future wheater it failed done or processing
        switch (snapshot.connectionState) {
          //when future is done whit its work
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const EmailVerificationView();
              }
            } else {
              return const LoginView();
            }

          // if (user?.emailVerified ?? false) {
          //   return const Text('done');
          // } else {
          //   return const EmailVerificationView();
          // }

          default:
            return CircularProgressIndicator(); //other than done state it loads
        }
      },
    );
  }
}
