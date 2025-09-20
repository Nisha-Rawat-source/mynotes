// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:mynotes/extensions/list/filter.dart';
// import 'package:mynotes/services/crud/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// class NotesService {
//   Database? _db;

// /*stream is evolution of data through time a
//    A Stream is like a pipe that sends data over time instead of giving everything 
//    at once. */
//   List<DatabaseNote> _notes = [];

//   /* using user here so that all notes of that particular user is returned
//   rather then all notes in database */

//   DatabaseUser? _user;

// /*singletone where if we want to call or create a service only once if we dont
//  need copies of it every time like here in our noteservices this was creating 
//  every time by init function in notesview so whenever we do hotrestart or relode
//  or create ui again it get called every time and made various instance of 
//  noteservice so we make it singletone so it is created only one time */

//   /* here we are creating a private variable and creating a named constructor
//  and by calling NotesService we are saying call factory NotesService() => _shared;
//  if value exist in shared it will retuen the same instance rather then creating
//  new instance */

//   static final NotesService _shared = NotesService._sharedInstance();
//   NotesService._sharedInstance() {
//     _noteStreamController = StreamController<List<DatabaseNote>>.broadcast(
//       onListen: () {
//         //this on listen function will callback when a new listener listern stream controller stream
//         _noteStreamController.sink.add(_notes);
//         /*Term	Meaning
// _noteStreamController	= The controller that manages the stream
// .sink	= The input side of the stream its like a door to a tank
// .add(data)	= is the method that sends data into the sink.The data you add here
//  will be delivered to all listeners of the stream.
// .stream.listen()= The listener that reacts to the data */
//       },
//     );
//   }

//   factory NotesService() => _shared;

//   /*Dart doesn’t run top-to-bottom like normal code

// In Dart, the order of member declarations (fields, constructors, methods) inside a class doesn’t matter for compilation.

// When Dart compiles your class:

// It first parses all members (variables, methods, constructors).

// Then it sets up memory for fields.

// Then it runs the constructor when you create the object.

// So even though _noteStreamController is written after the constructor, Dart already knows it exists because the whole class was parsed before running anything.

// and we uses late here so that is one of the reason of no error */

//   late final StreamController<List<DatabaseNote>>
//       _noteStreamController; /*A StreamController is like the remote control for a Stream.

// A Stream itself is like a TV channel that keeps sending data.

// A StreamController is like the person controlling the channel — deciding when 
// and what data to send. */

// /* 
// This defines a getter 'allNotes' that returns a Stream<List<DatabaseNote>>.
// Instead of sending all notes from the stream,  
// it filters the notes so only the notes belonging to the current user are included.  

// Here’s what happens step by step:
// ---------------------------------
// 1) '_noteStreamController.stream'  
//    - This is the original stream containing lists of all notes (for all users).  

// 2) '.filter((note) { ... })'  
//    - 'filter' is the custom extension function we created earlier.  
//    - It takes a condition function (the one we pass here) to filter out unwanted items.  

// 3) '(note) { final currentUser = _user; ... }'  
//    - This is the actual condition function we are passing to 'filter'.  
//    - For each note in the stream, this function checks:  
//        → If 'currentUser' exists (not null).  
//        → Whether the note's userId matches the currentUser's id.  

// 4) 'return note.userId == currentUser.id;'  
//    - If this condition is true → the note stays in the list.  
//    - If false → the note is removed.  

// 5) 'else { throw UserShouldBeSetBeforeReadingAllNotes(); }'  
//    - If there is no currentUser set (null), we throw an error  
//      because we cannot filter notes without knowing the user first.  

// Final result:  
// -------------
// The stream 'allNotes' will now send only the notes belonging to the current user  
// instead of sending all notes from all users.
// */

//   Stream<List<DatabaseNote>> get allNotes =>
//       _noteStreamController.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotes();
//         }
//       });

//   Future<DatabaseUser> getOrCreateUser({
//     /* think of it like you register and loged in
//   and currently there is no user exist as you in database for this situation if
//   we didnt find that particular user we will create it in database and will we
//   able to get all the crud functionalities for that user */
//     required String email,
//     bool setAsCurrentUser = true,
//     //with getOrCreateUser we either create or get user so we are making our current use as true because it exist
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUser {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheNotes() async {
//     //here prefix _ is telling it is a private method accesse on in this class
//     final allNotes =
//         await getAllNotes(); //here allnotes is a iterable of type databasenote
//     _notes = allNotes
//         .toList(); //_notes is list of databasenote createdin the beginning
//     _noteStreamController.add(_notes);
//   }

//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabase0rThrow();

//     await getNote(id: note.id);

//     final updatesCount = await db.update(
//       noteTable,
//       {
//         textColumn: text,
//         isSyncedWithCloudColumn: 0,
//       },
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );

//     if (updatesCount == 0) {
//       throw CouldNotUpdateNote();
//     } else {
//       final updateNote = await getNote(id: note.id);

//       //before getting the node it might present in cache but it might have all data so it makes sence to update our cache as well so first delete existing node and then add current note and make update in stream controllers
//       _notes.removeWhere((note) => note.id == updateNote.id);
//       _notes.add(updateNote);
//       _noteStreamController.add(_notes);
//       return updateNote;
//     }
//   }

//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabase0rThrow();
//     final notes =
//         await db.query(noteTable); //notes is list of map<string,object>

//     return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));

//     /* notes → A list of rows from your database.
//     map() → A built-in Dart tool that goes through each row one by one and
//      changes it into something else.

// noteRow → A single row while map() is looping.

// DatabaseNote.fromRow(noteRow) → A special function (constructor) you wrote
//  that turns one row (a Map) into a DatabaseNote object.

// Result → You get a list-like collection of DatabaseNote objects instead of raw 
// database rows
//   */
//   }

//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabase0rThrow();
//     final notes = await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (notes.isEmpty) {
//       throw CouldNotFindNote();
//     } else {
//       final note = DatabaseNote.fromRow(notes.first); //first row of notes
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _noteStreamController.add(_notes);

//       return note;
//     }
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabase0rThrow();
//     final numberOfDeletions = await db.delete(noteTable);

//     _notes = [];
//     _noteStreamController.add(_notes);

//     return numberOfDeletions;
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();
//     await _ensureDbIsOpen();
//     final db = _getDatabase0rThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _noteStreamController.add(_notes);
//     }
//   }

//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabase0rThrow();
// // make sure owner exists in the database with the correct id
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }
//     const text = '';

// // create the note
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSyncedWithCloudColumn: 1,
//     });

//     final note = DatabaseNote(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//       isSyncedWithCloud: true,
//     );

//     _notes.add(note);
//     _noteStreamController.add(_notes);

//     return note;
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabase0rThrow();

//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       return DatabaseUser.fromRow(results.first); //read first row in given data
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabase0rThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (results.isNotEmpty) {
//       throw UserAlreadyExists();
//     }

//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });
//     return DatabaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabase0rThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }

//   Database _getDatabase0rThrow() {
//     /*it make sures that databse instance exist in noteservice and return it
//      it does not tell that weather database is open or not */
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> _ensureDbIsOpen() async {
//     /* it ensure databse is open so that we did not open it again and again 
//     if database is already open it will trow an error and we can just ignore
//     that error if db is already open in this function insead of opening 
//     it again and again in other functions */
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       //empty
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;

//       // create the user table

//       await db.execute(createUserTable);

//       // create the note table
//       await db.execute(createNoteTable);
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectory();
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(
//       Map<String, Object?>
//           map) //named constructor creating an instance of databaseuser class
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() =>
//       'Person, ID = $id, email = $email'; //printing in debug console

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id
//       .hashCode; //jab comaparison krna ho tho hashcode use hota hai ye dart m builtin generate hota hai jab object create hothe hai
// }

// class DatabaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   DatabaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   }); //ye class avi call nhi hue hai isliye ye avi database se connect nhi hai ye manually krna hoga object creattion m tb humko database se data assign hoaga

//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';
//   @override
//   bool operator ==(covariant DatabaseNote other) =>
//       id ==
//       other
//           .id; /* here Normally,
//    when you override a method in Dart, the parameter type must stay the same as 
//    the parent class.
// covariant lets you make the parameter type more specific in the child class.
// covariant = "I want to accept a more specific type here."

// simply == built in operator hai jo ek class m hota hai nd ye apne type k data se
// ek dusre ko compare kr skta hai pr jab humko kisi or type ya kisi epesipic type 
// se compare krna ho tho covariant keyword use krthe hai*/
//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = 'notes.db';
// const noteTable = 'note';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
// "id" INTEGER NOT NULL,
// "email" TEXT NOT NULL UNIQUE,
// PRIMARY KEY("id" AUTOINCREMENT)
// );''';
// const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
// "id" INTEGER NOT NULL,
// "user_id" INTEGER NOT NULL,
// "text" TEXT,
// "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
// FOREIGN KEY("user_id") REFERENCES "user"("id"),
// PRIMARY KEY("id" AUTOINCREMENT)
// );''';
