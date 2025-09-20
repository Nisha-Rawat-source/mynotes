import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'package:bloc/bloc.dart';
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

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialize(), //future of future builder
//       builder: (context, snapshot) {
//         //perform this builder after future returns future according to its results future have snapshot -> state of future wheater it failed done or processing
//         switch (snapshot.connectionState) {
//           //when future is done whit its work
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;

//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesView();
//               } else {
//                 return const EmailVerificationView();
//               }
//             } else {
//               return const LoginView();
//             }

//           // if (user?.emailVerified ?? false) {
//           //   return const Text('done');
//           // } else {
//           //   return const EmailVerificationView();
//           // }

//           default:
//             return CircularProgressIndicator(); //other than done state it loads
//         }
//       },
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => counterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("testing bloc"),
        ),
        body: BlocConsumer<counterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalid : '';

            return Column(
              children: [
                Text('current value => ${state.value}'),
                Visibility(
                  visible: state is CounterStateInvalidNumber,
                  child: Text('invalid input => $invalidValue'),
                ),
                TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: 'enter a number here'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          context
                              .read<counterBloc>()
                              .add(incrementEvent(_controller.text));
                        },
                        child: const Text('+')),
                    TextButton(
                        onPressed: () {
                          context
                              .read<counterBloc>()
                              .add(decrementEvent(_controller.text));
                        },
                        child: const Text('-'))
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

abstract class CounterState {
  final int value;

  const CounterState(
    this.value,
  );
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalid;

  const CounterStateInvalidNumber({
    required this.invalid,
    required int previousValue,
  }) : super(previousValue);
}

abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class incrementEvent extends CounterEvent {
  const incrementEvent(String value) : super(value);
}

class decrementEvent extends CounterEvent {
  const decrementEvent(String value) : super(value);
}

class counterBloc extends Bloc<CounterEvent, CounterState> {
  counterBloc()
      : super(
          const CounterStateValid(0),
        ) {
    on<incrementEvent>((event, emit) {
      final intger = int.tryParse(event.value);
      if (intger == null) {
        emit(
          CounterStateInvalidNumber(
              invalid: event.value, previousValue: state.value),
        );
      } else {
        emit(
          CounterStateValid(state.value + intger),
        );
      }
    });
    on<decrementEvent>((event, emit) {
      final intger = int.tryParse(event.value);
      if (intger == null) {
        emit(CounterStateInvalidNumber(
            invalid: event.value, previousValue: state.value));
      } else {
        emit(CounterStateValid(state.value - intger));
      }
    });
  }
}
