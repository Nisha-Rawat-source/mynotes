//'implements Exception' means this class is treated as an Exception in Dart.
//super class CloudStorageExceptions
class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

//extends for inheritence here these classes are inheriting from CloudStorageExceptions

//c in crud
class CouldNotCreateNoteException extends CloudStorageExceptions {}

//r in crud
class CouldNotGetAllNotesException extends CloudStorageExceptions {}

//u in crud
class CouldNotUpdateNoteException extends CloudStorageExceptions {}

//d in crud
class CouldNotDeleteNoteException extends CloudStorageExceptions {}
