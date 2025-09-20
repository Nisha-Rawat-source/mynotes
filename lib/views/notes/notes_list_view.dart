import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
//import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

//typedef noteCallBack = void Function(DatabaseNote note);

typedef noteCallBack = void Function(CloudNote note);

/* here this line is saying
that there is a function return type is void and takes argument of databasenote type 
and if any such kind function exist we created a typedef or alias or second name
as noteCallBack or means a shortcut name for any function that takes a
 DatabaseNote as input and returns nothing. the shorcut name is noteCallBack */

class NotesListView extends StatelessWidget {
  // final List<DatabaseNote> notes; //storing all the notes for notesview

  final Iterable<CloudNote> notes;

  /* these two are the function with alias or typdef of noteCallBack which is a 
  function that is of type void and have databasenote parameter we created these
  function because these function are define in notesview so that notesview can
  talk with notesservise and answer noteslistview so that our notesservies is only
  accesive by notesview only  */
  final noteCallBack onDeleteNote;
  final noteCallBack onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length, //total no. of notes processes by listview
      itemBuilder: (context, index) {
        //indexing every note and implementing below code on them one by one
        //final note = notes[index];

        final note = notes.elementAt(index);

        //one note at particular index ans implementing below code

        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap:
                true, //softWrap: true → Text will break into the next line when it reaches the end.
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            //in list at particular item its end or coner where delete button is
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}

/*ListTile in Flutter is a ready-made widget that creates a single row with:
Leading → icon/image on the left
Title → main text
Subtitle → optional smaller text below
Trailing → icon on the right
onTap → action when tapped
It’s mainly used inside lists like ListView to show items quickly. */


//this stateless widget is rendering list of notes beging shown on listview