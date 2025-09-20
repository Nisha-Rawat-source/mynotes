import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_actions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
//import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // late final NotesService _notesService;

  late final FirebaseCloudStorage _notesService;

  // String get userEmail => AuthService.firebase().currentUser!.email;

  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    //_notesService = NotesService();
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  /*When you call NotesService() in initState(), it uses the factory constructor.

A factory constructor can return the same object instead of creating a new one.

First time → object is created and saved in _shared.

Next time → same _shared object is returned, no new object created.

That’s why in initState(), you always get the same single object with all its
public methods. */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        backgroundColor: Colors.blue,
        actions: [
          //list of widget in appbar
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            //here popupMenuButton is a widget of flutter which take generic type data ans here MenuAction is a type of data it takes which is a enum created by us in enum file
            //child is what user sees and value is what devloper or program sees
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              //this item builder is used for the items in popupMenuButton
              return const [
                PopupMenuItem<MenuAction>(
                  //popupmenuitems are defined in this item builder here value of this item is  MenuAction.logout, and this value is associated with logot text widget inside popupmenubutton
                  value: MenuAction.logout,
                  child: Text('log out'),
                ),
              ];
            },
          )
        ],
      ),

      body: StreamBuilder(
        //stream: _notesService.allNotes,
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //implecite fall through writing cases one after other meaning one case have no knowledge and that fall through to other case
            case ConnectionState
                  .waiting: //command click it is saying waiting for a note to we created
            case ConnectionState
                  .active: //it is when atleast one value or note is returned and waiting for others
              if (snapshot
                  .hasData) //snapshot.hasData is property of snapshot which tells wheither it have data or not in this snapshot it is talking about streams builders allnotes
              {
                //final allNotes = snapshot.data as List<DatabaseNote>;
                final allNotes = snapshot.data as Iterable<CloudNote>;
                //assigning snapshot data to all notes by cinverting it into list of databasenote

                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    //await _notesService.deleteNote(id: note.id);
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,

                      /*here we are passing a argument or parameter with 
                              the given route because on taping + on our scree
                              we are creating new note in database with same route
                              but we are not giving any argument there but here
                              we are giving argument which have some data which
                              that route will process and according to it it will
                              understand that we are not creating newnote but 
                              updating existing one thats why we use argument here 
                              Any object can be passed as arguments */

                      /*Sometimes when moving to another page, you need 
                              to pass some data.
                              Example:
                              page 1 → User clicks on a note.
                              Page 2 → Should show details of that specific note.
                              
                              Arguments = Data you send when changing screens.
                              You can pass them via constructors or Navigator 
                              arguments. */

                      arguments: note,
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      ),

      // body: FutureBuilder(
      //   future: _notesService.getOrCreateUser(email: userEmail),
      //   //creating user in noteservice or database if not exist with given email
      //   builder: (context, snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.done:
      //         return StreamBuilder(
      //           stream: _notesService.allNotes,
      //           builder: (context, snapshot) {
      //             switch (snapshot.connectionState) {
      //               //implecite fall through writing cases one after other meaning one case have no knowledge and that fall through to other case
      //               case ConnectionState
      //                     .waiting: //command click it is saying waiting for a note to we created
      //               case ConnectionState
      //                     .active: //it is when atleast one value or note is returned and waiting for others
      //                 if (snapshot
      //                     .hasData) //snapshot.hasData is property of snapshot which tells wheither it have data or not in this snapshot it is talking about streams builders allnotes
      //                 {
      //                   final allNotes = snapshot.data as List<
      //                       DatabaseNote>; //assigning snapshot data to all notes by cinverting it into list of databasenote

      //                   return NotesListView(
      //                     notes: allNotes,
      //                     onDeleteNote: (note) async {
      //                       await _notesService.deleteNote(id: note.id);
      //                     },
      //                     onTap: (note) {
      //                       Navigator.of(context).pushNamed(
      //                         createOrUpdateNoteRoute,

      //                         /*here we are passing a argument or parameter with
      //                         the given route because on taping + on our scree
      //                         we are creating new note in database with same route
      //                         but we are not giving any argument there but here
      //                         we are giving argument which have some data which
      //                         that route will process and according to it it will
      //                         understand that we are not creating newnote but
      //                         updating existing one thats why we use argument here
      //                         Any object can be passed as arguments */

      //                         /*Sometimes when moving to another page, you need
      //                         to pass some data.
      //                         Example:
      //                         page 1 → User clicks on a note.
      //                         Page 2 → Should show details of that specific note.

      //                         Arguments = Data you send when changing screens.
      //                         You can pass them via constructors or Navigator
      //                         arguments. */

      //                         arguments: note,
      //                       );
      //                     },
      //                   );
      //                 } else {
      //                   return CircularProgressIndicator();
      //                 }

      //               default:
      //                 return const CircularProgressIndicator();
      //             }
      //           },
      //         );

      //       default:
      //         return const CircularProgressIndicator();
      //     }
      //   },
      // ),
    );
  }
}


/* you can ignore it if you want this is extra of your previous init and dispose 
function  

initState() →

This is a lifecycle method in Flutter.

It runs only once when your widget is first created.

Inside the function:

_notesService = NotesService();

Here we are creating an object of NotesService and assigning it to _notesService.

This matches the late final variable we declared earlier.

_notesService.open();

We call the open() method on NotesService, maybe to open a database or file.

super.initState();

Calls the parent class's initState() to ensure Flutter does its default setup as well.

dispose() Method:
@override
void dispose() {
  _notesService.close();
  super.dispose();
}


Breakdown:

dispose() → Another Flutter lifecycle method.

It runs when the widget is being removed from the screen.

_notesService.close(); →

Closes the service when we are done, so no memory leaks happen.

super.dispose(); →

Calls the parent class's dispose logic. 

be change the init and dispose function because we were creating it to 
ensure db is open but we handeled it in notesservice by 
ensuredatabaseisopen funtion so we dont need theem */