//here some commented code are of local crud or sqlite service or noteesservice

import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
//import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
//import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
//import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  // DatabaseNote? _note;
  CloudNote? _note;

  //this new note does not exist in database so we are creating it for it we are using future builder in body so every time we hotrelode it will create note again and again to does not happen this we are using these variables

  //late final NotesService _notesService;crud
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  //In Flutter, TextEditingController (like _textController) manages the text inside a TextField or TextFormField.

  @override
  void initState() {
    // _notesService = NotesService();
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    //it is a function which is updating text in note on the go while we are writing or constantly while we are writing
    final note = _note;

    if (note == null) {
      return;
    }

    final text = _textController.text;

    // await _notesService.updateNote(
    //   note: note,
    //   text: text,
    // );

    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    //You can attach a listener to it, so whenever the text changes, your listener function (like _textControllerListener) will automatically run.
    _textController.removeListener(_textControllerListener);
    //Hey _textController, stop calling _textControllerListener when text changes.It removes the connection between the text controller and your listener function."

    _textController.addListener(_textControllerListener);
    //Hey _textController, whenever the text changes, please call _textControllerListener function.
  }
  /*When your widget initializes, it removes any previous listener.

Then it adds a fresh listener to keep it clean and avoid duplicates. */

  //Future<DatabaseNote> createOrGetExistingNote(BuildContext) async {

  Future<CloudNote> createOrGetExistingNote(BuildContext) async {
    /*we are extracting an argument for a widget of buildcontext which returns
    databasrnote if it have it else return null 
    either you have a note of type databasenote and you tap on it and came here
    with argument or else you just clicked on plus button */

    // Step 1: Get the arguments passed to this screen using the extension method getArguments
// Here we expect the argument to be of type DatabaseNote.
// If no argument is passed or the type doesn't match, widgetNote will be null.

    // final widgetNote = context.getArguments<DatabaseNote>();

    final widgetNote = context.getArguments<CloudNote>();

// Step 2: Check if we actually received an argument (not null)
    if (widgetNote != null) {
      // Step 3: Store the received DatabaseNote object into a private variable for future use which is define above or which is current note
      _note = widgetNote;

      // Step 4: Set the text inside the text controller of the current note or _note variable note's text
      // This will display the note's content in the TextField of _note
      _textController.text = widgetNote.text;

      // Step 5: Return the same DatabaseNote object so the calling code can use it if needed
      return widgetNote;
    }

/*we are checking wheather note exist in notesservice or database if it does not 
exist this function creates it */

    final existingNote = _note;

    if (existingNote != null) {
      return existingNote;
    }

/*for creating a note in database it requires a owner for that we require our user email */

    final currentUser = AuthService.firebase().currentUser!;

    //final email = currentUser.email;
    // final owner = await _notesService.getUser(email: email); we dont need user in firebase cloud as it is handel by itsown
    //this owner is created inside database by a getorcreate user function inside notes view now for this user we are creating new notes

    // final newNote = await _notesService.createNote(owner: owner);

    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      // _notesService.deleteNote(id: note.id);
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;

    if (note != null && text.isNotEmpty) {
      //  // await _notesService.updateNote(
      //     note: note,
      //     text: text,
      //   );

      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('new note'),
        backgroundColor: Colors.blue,
      ),

      /*uptill know we were just creating variable or function above but in this body
      or ui we are calling them */
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener(); //above function call

              return TextField(
                controller:
                    _textController, //textediting controller is controlling this textfield
                keyboardType: TextInputType
                    .multiline, //just get a keyboard enter button in your keyboard for next line
                maxLines:
                    null, //this is eabling multiple line in textfiled as in flutter by default textfield are of one line
                decoration: const InputDecoration(
                  hintText: 'start typing from here...',
                ),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
